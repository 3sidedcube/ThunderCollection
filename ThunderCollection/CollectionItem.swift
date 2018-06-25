//
//  CollectionItem.swift
//  ThunderCollection
//
//  Created by Joel Trew on 19/07/2017.
//  Copyright © 2017 3 Sided Cube. All rights reserved.
//

import Foundation
import UIKit


public typealias SelectionHandler = (_ item: CollectionItemDisplayable, _ selected: Bool, _ indexPath: IndexPath, _ collectionView: UICollectionView?) -> (Void)

public protocol CollectionItemDisplayable {
    
    /// The class for the `UICollectionViewCell` subclass for the cell
    var cellClass: UICollectionViewCell.Type? { get }
    
    /// A prototype identifier for a cell which is defined in a storyboard
    /// file, which this item will use
    var prototypeIdentifier: String? { get }
    
    /// A function which will be called when the item is pressed on in the collection view
    var selectionHandler: SelectionHandler? { get set }
    
    /// Whether if no nib was found with the same file name as `cellClass`
    /// (expected behaviour is to name your cell's xib the same file name as the
    /// class you return from `cellClass`), we should then find a xib for a
    /// superclass of `cellClass`
    ///
    /// Defaults to true, meaning all cells without their own xib will use
    /// a superclasses xib to layout, this will eventually come across the base
    /// cell class `TableViewCell` so if you wish to have a none Interface Builder
    /// row, then make sure to return false from this, or subclass from UITableViewCell rather than TableViewCell!
    var useNibSuperclass: Bool { get }
	
	/// Whether the cell should remain selected when pressed by the user
	///
	/// Defaults to false
	var remainSelected: Bool { get }
	
    /// A function which will be called in `cellForRow:atIndexPath` delegate
    /// method which can be used to provide custom overrides on your cell from
    /// the item controlling it
    ///
    /// - Parameters:
    ///   - cell: The cell which needs configuring
    ///   - indexPath: The index path which that cell is at
    ///   - collectionViewController: The collection view controller which the cell is in
    func configure(cell: UICollectionViewCell, at indexPath: IndexPath, in collectionViewController: CollectionViewController)
	
	/// A function which allows providing a manual size for a cell not layed
	/// out using Interface Builder
	///
	/// - Parameters:
	///   - size: The size which the row has available to it
	///   - tableView: The table view which the row will be displayed in
	/// - Returns: The height (or nil, to have this ignored) the row should be displayed at
	func size(constrainedTo size: CGSize, in collectionView: UICollectionView) -> CGSize?
}


extension CollectionItemDisplayable {
    
    public var cellClass: UICollectionViewCell.Type? {
        return nil
    }
    
    public var prototypeIdentifier: String? {
        return nil
    }
	
	public var remainSelected: Bool {
		return false
	}
	
    public var selectionHandler: SelectionHandler? {
        get { return nil }
        set {}
    }
    
    public var useNibSuperclass: Bool {
        return true
    }
    
    public func configure(cell: UICollectionViewCell, at indexPath: IndexPath, in collectionViewController: CollectionViewController) {
        
    }
	
	public func size(constrainedTo size: CGSize, in collectionView: UICollectionView) -> CGSize? {
		return nil
	}
}


extension CollectionItemDisplayable {
    
    /// Returns a nib for the row's cell class if one exists in the bundle for the class
    var nib: UINib? {
        
        get {
            
            guard var cellClass = cellClass else { return nil }
            
            var classString = String(describing: cellClass)
            guard var nibName = classString.components(separatedBy: ".").last else { return nil }
            
            var bundle = Bundle(for: cellClass)
            var nibPath = bundle.path(forResource: nibName, ofType: "nib")
            
            // Only look for nib superclasses if we're told to by CollectionItemDisplayable protocol
            if useNibSuperclass {
                
                // Sometimes a cell may have subclassed without providing it's own nib file
                // In this case always use it's superclass!
                while nibPath == nil, let superClass = cellClass.superclass() as? UICollectionViewCell.Type {
                    
                    // Make sure we're still looking in the correct bundle
                    bundle = Bundle(for: superClass)
                    // Find the new class name
                    classString = String(describing: superClass)
                    // Get the new nib name for the classes superClass
                    if let superNibName = classString.components(separatedBy: ".").last, let path = bundle.path(forResource: superNibName, ofType: "nib") {
                        // Update nibPath and nibName
                        nibPath = path
                        nibName = superNibName
                    }
                    cellClass = superClass
                }
            }
            
            guard nibPath != nil else { return nil }
            let nib = UINib(nibName: nibName, bundle: bundle)
            return nib
        }
    }
    
    var identifier: String? {
        
        if let prototypeIdentifier = prototypeIdentifier {
            return prototypeIdentifier
        } else if let cellClass = cellClass {
            return String(describing: cellClass)
        }
        
        return nil
    }
}

public protocol CollectionSectionDisplayable {
    
    var items: [CollectionItemDisplayable] { get set }
    
    var selectionHandler: SelectionHandler? { get set }
}
