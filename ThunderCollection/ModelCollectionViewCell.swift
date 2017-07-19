//
//  ModelCollectionViewCell.swift
//  ThunderCollection
//
//  Created by Joel Trew on 19/07/2017.
//  Copyright © 2017 3 Sided Cube. All rights reserved.
//

import UIKit

class ModelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
