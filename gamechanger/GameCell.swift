//
//  GameCell.swift
//  gamechanger
//
//  Created by Ryley Herrington on 10/20/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var platforms: UILabel!
    
    var isOpen:Bool
    
    override init(frame: CGRect) {
        self.isOpen = false
        super.init(frame:frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.isOpen = false
        super.init(coder: aDecoder)
    }
    
}