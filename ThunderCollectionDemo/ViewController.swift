//
//  ViewController.swift
//  ThunderCollection
//
//  Created by Joel Trew on 19/07/2017.
//  Copyright © 2017 3 Sided Cube. All rights reserved.
//

import UIKit

class ViewController: CollectionViewController {
    
    var models = [Model(name: "1", age: 4, image: #imageLiteral(resourceName: "heart")), Model(name: "Soemthing", age: 10, image: #imageLiteral(resourceName: "heart"))]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [CollectionSection(items: models)]
        
    }
}

