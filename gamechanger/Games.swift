//
//  Game.swift
//  gamechanger
//
//  Created by Yan Yu on 9/29/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//

import Foundation
import UIKit

func CreateUIColorFromString(hex: String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString.hasPrefix("#")) {

        cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
    }
    
    if (cString.characters.count != 6) {
        return UIColor.grayColor()
    }
    
    var hexValue:CUnsignedInt = 0
    NSScanner(string: cString).scanHexInt(&hexValue)

    
    return UIColor(red: CGFloat(((hexValue & 0xFF0000) >> 16))/255.0, green: CGFloat(((hexValue & 0xFF00) >> 8))/255.0, blue: CGFloat((hexValue & 0xFF))/255.0, alpha: CGFloat(1))
}

@objc class Games: NSObject
{
    var name: String
    var releaseDate: String
    var lastUpdated: String
    var genre: String
    var platforms: [String]
    var color: UIColor
    

    
    init(gameName: String, gameReleaseDate: String, gameLastUpdated: String,
        gameGenre: String, gamePlatforms: [String],  gameColor: String)
    {

        name        = gameName
        releaseDate = gameReleaseDate
        lastUpdated = gameLastUpdated
        genre       = gameGenre
        platforms   = gamePlatforms
        color       = CreateUIColorFromString(gameColor)
        
    }
    
}