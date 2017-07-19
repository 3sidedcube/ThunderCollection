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
open class CollectionViewController: UICollectionViewController {
    
    open var data: [CollectionSectionDisplayable] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    public var selectedIndexPath: IndexPath?
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        let defaultNib = UINib(nibName: "CollectionViewCell", bundle: Bundle(for: CollectionViewController.self))
        collectionView?.register(defaultNib, forCellWithReuseIdentifier: "Cell")
    }
    
//    public var inputDictionary: [String: Any?]? {
//        
//        guard let inputItems = data.flatMap({ $0.rows.filter({ $0 as? InputRow != nil }) }) as? [InputRow] else { return nil }
//        
//        var dictionary: [String: Any?] = [:]
//        
//        inputRows.forEach { (row) in
//            dictionary[row.id] = row.value
//        }
//        
//        return dictionary
//    }
    
//    public var missingRequiredInputRows: [InputRow]? {
//        
//        guard let inputRows = data.flatMap({ $0.rows.filter({ $0 as? InputRow != nil }) }) as? [InputRow] else { return nil }
//        
//        return inputRows.filter({ (inputRow) -> Bool in
//            return inputRow.required && inputRow.value == nil
//        })
//    }
    
    private var registeredClasses: [String] = []
    
    // MARK: - Helper functions!
    
    open func configure(cell: UICollectionViewCell, with item: CollectionItemDisplayable, at indexPath: IndexPath) {
        
        
        item.configure(cell: cell, at: indexPath, in: self)

    }
    
    private func register(item: CollectionItemDisplayable) {
        
        guard let identifier = item.identifier else { return }
        
        if let nib = item.nib {
            collectionView?.register(nib, forCellWithReuseIdentifier: identifier)
        } else if let cellClass = item.cellClass {
            collectionView?.register(cellClass, forCellWithReuseIdentifier: identifier)
        }
    }
    
    // MARK: - TableView data source
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section - 1 > data.count { return 0 }
        
        let section = data[section]
        return section.items.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = data[indexPath.section].items[indexPath.row]
        
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
}
