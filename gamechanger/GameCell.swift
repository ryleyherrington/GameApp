//
//  GameCell.swift
//  gamechanger
//
//  Created by Ryley Herrington on 10/20/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var isOpen:Bool
    var openView: UIView!
    var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        self.isOpen = false
        super.init(frame:frame)
        
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.clearColor()
        
        self.nameLabel.font = UIFont (name: "HelveticaNeue-Light", size: 18)
        nameLabel.textAlignment = .Left
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.numberOfLines = 1;
        nameLabel.backgroundColor = UIColor.clearColor()
        
        
        let width = frame.size.width
        let height = frame.size.height
        
        openView.frame = CGRectMake(
            width,
            0,
            width/2,
            frame.size.height)
        
        dateLabel = UILabel(frame: CGRect(
            x: 0,
            y: height/2,
            width: openView.frame.width,
            height: height/3))
        dateLabel.font = UIFont (name: "HelveticaNeue-Light", size: 15)
        dateLabel.textAlignment = .Right
        dateLabel.lineBreakMode = .ByWordWrapping
        openView.addSubview(dateLabel)
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(50, 0))
        path.addLineToPoint(CGPointMake(0, height))
        path.addLineToPoint(CGPointMake(width, height))
        path.addLineToPoint(CGPointMake(width, 0))
        
        let mask = CAShapeLayer()
        mask.frame = openView.bounds
        mask.path = path.CGPath
        openView.layer.mask = mask
        
        openView.backgroundColor=UIColor.lightGrayColor()
        addSubview(openView)
    }

    required init?(coder aDecoder: NSCoder) {
        isOpen = false
        super.init(coder: aDecoder)
    }
    
}