//
//  CollectionSection.swift
//  ThunderCollection
//
//  Created by Joel Trew on 19/07/2017.
//  Copyright © 2017 3 Sided Cube. All rights reserved.
//

import Foundation


open class CollectionSection: CollectionSectionDisplayable {
    
    open var items: [CollectionItemDisplayable]
    
    open var selectionHandler: SelectionHandler?
    
    public init(items: [CollectionItemDisplayable], selectionHandler: SelectionHandler? = nil) {
        
        self.items = items
        self.selectionHandler = selectionHandler
    }
}
