//
//  Game.swift
//  gamechanger
//
//  Created by Yan Yu on 9/29/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//

import Foundation
import UIKit

func CreateDateFromString(dateString: String) -> NSDate {
    
    return NSDate()
}

func CreateUIColorFromString(colorString: String) -> UIColor {
    return UIColor()
}

@objc class Games: NSObject
{
    var name: String
    var releaseDate: NSDate
    var lastUpdated: NSDate
    var genre: String
    var platforms: [String]
    var color: UIColor
    

    
    init(gameName: String, gameReleaseDate: String, gameLastUpdated: String,
        gameGenre: String, gamePlatforms: [String],  gameColor: String)
    {

        name        = gameName
        releaseDate = CreateDateFromString(gameReleaseDate)
        lastUpdated = CreateDateFromString(gameLastUpdated)
        genre       = gameGenre
        platforms   = gamePlatforms
        color       = CreateUIColorFromString(gameColor)
        
    }
    
}