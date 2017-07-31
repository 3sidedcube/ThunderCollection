//
//  Model.swift
//  ThunderCollection
//
//  Created by Joel Trew on 19/07/2017.
//  Copyright © 2017 3 Sided Cube. All rights reserved.
//

import UIKit

struct Model {
    
    var name: String
    var age: Int
    var image: UIImage
}


extension Model: CollectionItemDisplayable {
    
    var cellClass: AnyClass? {
        return ModelCollectionViewCell.self
    }
    
    func configure(cell: UICollectionViewCell, at indexPath: IndexPath, in tableViewController: CollectionViewController) {
        
        guard let _cell = cell as? ModelCollectionViewCell else { return }
        
        _cell.titleLabel.text = name
        _cell.ageLabel.text = "\(age)"
        _cell.backgroundImageView.image = image
        
    }
}
