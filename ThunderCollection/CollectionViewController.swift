//
//  CollectionViewController.swift
//  ThunderCollection
//
//  Created by Joel Trew on 19/07/2017.
//  Copyright © 2017 3 Sided Cube. All rights reserved.
//

import Foundation
import UIKit

@objc(TSCCollectionViewController)
open class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var _data: [CollectionSectionDisplayable] = []
    
    open var data: [CollectionSectionDisplayable] {
        set {
            _data = newValue
            collectionView?.reloadData()
        }
        get {
            return _data
        }
    }
	
	open var columns: Int = 1 {
		didSet {
            collectionView?.collectionViewLayout.invalidateLayout()
		}
	}
	
	open var rows: Int = 1 {
		didSet {
            collectionView?.collectionViewLayout.invalidateLayout()
		}
	}
	
	open var minimumInterimSpacing: CGFloat? {
		get {
			return (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing
		}
		set {
			if let newValue = newValue {
				(collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = newValue
			}
			collectionViewLayout.invalidateLayout()
		}
	}
	
	open var minimumLineSpacing: CGFloat? {
		get {
			return (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing
		}
		set {
			if let newValue = newValue {
				(collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = newValue
			}
			collectionViewLayout.invalidateLayout()
		}
	}
    
    public var selectedIndexPath: IndexPath?
    
    private var registeredClasses: [String] = []
    
    // MARK: - Helper functions!
    
    open func configure(cell: UICollectionViewCell, with item: CollectionItemDisplayable, at indexPath: IndexPath) {
		
        item.configure(cell: cell, at: indexPath, in: self)
    }
    
    private func register(item: CollectionItemDisplayable) {
        
        guard let identifier = item.identifier else { return }
        
        if let nib = item.nib {
            collectionView?.register(nib, forCellWithReuseIdentifier: identifier)
        } else if let cellClass = item.collectionCellClass {
            collectionView?.register(cellClass, forCellWithReuseIdentifier: identifier)
        }
    }
    
    // MARK: - TableView data source
    
    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _data.count
    }
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section - 1 > _data.count { return 0 }
        
        let section = _data[section]
        return section.items.count
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = _data[indexPath.section].items[indexPath.item]
        
        let identifier: String = item.identifier ?? "Cell"
        
        // If we don't have a prototype identifier (Prototype cells are automatically registered by the OS
        if item.prototypeIdentifier == nil {
            
            // Make sure it's registered before de-queueing it
            if !registeredClasses.contains(where: {identifier == $0}) {
                register(item: item)
            }
        }
        
        if identifier == "Cell" {
            print("You didn't provide a cellClass or prototypeIdentifier for \(item), falling back to our default cell class")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        configure(cell: cell, with: item, at: indexPath)
        
        return cell
    }
	
	override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if selectable(indexPath) {
			set(indexPath: indexPath, selected: true)
		}
	}
	
	override open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		if selectable(indexPath) {
			set(indexPath: indexPath, selected: false)
		}
	}
	
	private var dynamicHeightCells: [String: UICollectionViewCell] = [:]
	
	private var cellConstrainedSize: CGSize {
		
		guard let collectionView = collectionView, let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
			return CGSize(width: view.bounds.width, height: 10000)
		}

		// Inset view.bounds by contentInset
		var insetSize = CGSize(width: view.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right, height: view.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom)
		
		// Inset again by section's insets
		let edgeInsets = collectionViewFlowLayout.sectionInset
		insetSize.width -= (edgeInsets.left + edgeInsets.right)
		insetSize.height -= (edgeInsets.top + edgeInsets.bottom)
		
		// Calculate cell height
		if collectionViewFlowLayout.scrollDirection == .horizontal {
			return CGSize(width: 10000, height: (insetSize.height / CGFloat(rows)) - (collectionViewFlowLayout.minimumLineSpacing * CGFloat(rows-1)))
		} else {
			return CGSize(width: (insetSize.width / CGFloat(columns)) - (collectionViewFlowLayout.minimumInteritemSpacing * CGFloat(columns-1)), height: 10000)
		}
	}
	
	private var scrollDirection: UICollectionViewScrollDirection {
		guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
			return .vertical
		}
		
		return flowLayout.scrollDirection
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let row = _data[indexPath.section].items[indexPath.item]
		
		if let size = row.size(constrainedTo: cellConstrainedSize, in: collectionView) {
			return size
		}
		
		// Let's calculate this mothertrucker!
		
		var identifier: String = "Cell"
		// If the row defines a cell class use the identifier for that
		if let rowIdentifier: String = row.identifier {
			identifier = rowIdentifier
		}
		
		var cell = dynamicHeightCells[identifier]
		
		// If no nib, then calculate size via layoutSubviews
		guard let nib = row.nib else  {
			
			if cell == nil {
				
				if let aClass = row.collectionCellClass as? UICollectionViewCell.Type {
					cell = aClass.init(coder: NSCoder())
				}
			}
			
			guard let _cell = cell else { return .zero }
			
			configure(cell: _cell, with: row, at: indexPath)
			return manualCellSize(cell: _cell)
		}
		
		if cell == nil, let view = nib.instantiate(withOwner: self, options: nil).filter({ $0 as? UICollectionViewCell != nil }).first as? UICollectionViewCell {
			cell = view
			dynamicHeightCells[identifier] = view
		}
		
		guard let _cell = cell else { return .zero }
		
		configure(cell: _cell, with: row, at: indexPath)
		
		var size: CGSize?
		let view = _cell.contentView
		
		let translates = view.translatesAutoresizingMaskIntoConstraints
		let mask = view.autoresizingMask
		view.translatesAutoresizingMaskIntoConstraints = true
		
		if scrollDirection == .vertical {
			
			let width = NSNumber(value: Float(cellConstrainedSize.width))
			let temporaryWidthConstraint = NSLayoutConstraint.constraints(withVisualFormat: "[view(width)]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: ["width": width], views: ["view": view])
			view.addConstraints(temporaryWidthConstraint)
			view.bounds = CGRect(origin: .zero, size: CGSize(width: cellConstrainedSize.width, height: 0))
			
			view.autoresizingMask = .flexibleHeight
			view.setNeedsUpdateConstraints()
			
			// Force the view to layout itself and any children
			view.setNeedsLayout()
			view.updateConstraints()
			view.layoutSubviews()
			
			size = view.systemLayoutSizeFitting(cellConstrainedSize)
			view.removeConstraints(temporaryWidthConstraint)
			
		} else {
			
			let height = NSNumber(value: Float(cellConstrainedSize.height))
			let temporaryHeightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "[view(height)]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: ["height": height], views: ["view": view])
			view.addConstraints(temporaryHeightConstraint)
			view.bounds = CGRect(origin: .zero, size: CGSize(width: cellConstrainedSize.width, height: 0))
			
			view.autoresizingMask = .flexibleHeight
			view.setNeedsUpdateConstraints()
			
			// Force the view to layout itself and any children
			view.setNeedsLayout()
			view.updateConstraints()
			view.layoutSubviews()
			
			size = view.systemLayoutSizeFitting(cellConstrainedSize)
			view.removeConstraints(temporaryHeightConstraint)
		}
		
		view.translatesAutoresizingMaskIntoConstraints = translates
		view.autoresizingMask = mask
		
		return size ?? .zero
	}

	private func manualCellSize(cell: UICollectionViewCell) -> CGSize {
		
		cell.frame = CGRect(x: 0, y: 0, width: cellConstrainedSize.width, height: cellConstrainedSize.height)
		cell.layoutSubviews()
		
		if scrollDirection == .vertical {
			
			var totalHeight: CGFloat = 0;
			let subviews = cell.contentView.subviews
			var lowestYValue: CGFloat = 0;
			
			subviews.forEach { (view) in
				
				if view.frame.height == 0 { return }
				
				let maxY = view.frame.maxY
				if maxY > totalHeight {
					totalHeight = maxY
				}
				
				let minY = view.frame.minY
				if minY < lowestYValue {
					lowestYValue = minY
				}
			}
			
			var cellHeight = totalHeight + fabs(lowestYValue) + 8
			
			cellHeight = ceil(cellHeight);
			let size = CGSize(width: cellConstrainedSize.width, height: cellHeight)
			return size;
			
		} else {
			
			var totalWidth: CGFloat = 0;
			let subviews = cell.contentView.subviews
			var lowestXValue: CGFloat = 0;
			
			subviews.forEach { (view) in
				
				if view.frame.height == 0 { return }
				
				let maxX = view.frame.maxX
				if maxX > totalWidth {
					totalWidth = maxX
				}
				
				let minX = view.frame.minX
				if minX < lowestXValue {
					lowestXValue = minX
				}
			}
			
			var cellWidth = totalWidth + fabs(lowestXValue) + 8
			
			cellWidth = ceil(cellWidth);
			let size = CGSize(width: cellWidth, height: cellConstrainedSize.height)
			return size;
		}
	}
}

public extension CollectionViewController {
	
	internal func selectable(_ indexPath: IndexPath) -> Bool {
		
		let section = _data[indexPath.section]
		let row = section.items[indexPath.item]
		
		return row.selectionHandler != nil || section.selectionHandler != nil || !row.remainSelected
	}
	
	internal func set(indexPath: IndexPath, selected: Bool) {
		
		let section = _data[indexPath.section]
		let row = section.items[indexPath.item]
		
		// Row selection overrides section selection
		if let rowSelectionHandler = row.selectionHandler {
			rowSelectionHandler(row, selected, indexPath, collectionView!)
		} else if let sectionSelectionHandler = section.selectionHandler {
			sectionSelectionHandler(row, selected, indexPath, collectionView!)
		}
		
		// Deselect it if remain selected is false
		if selected && !row.remainSelected {
			collectionView?.deselectItem(at: indexPath, animated: true)
		} else if selected && row.remainSelected {
			selectedIndexPath = indexPath
		}
	}
}
