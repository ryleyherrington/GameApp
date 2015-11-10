//
//  Networking.swift
//  gamechanger
//
//  Created by Yan Yu on 9/29/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

@objc class NetworkingProvider: NSObject
{
    let SERVER_URL = "http://gamerforecast.com/games.json"
    
    @objc override init() {
        
    }
    
    func GetGamesFromServerWithCompletion(completionHandler: (pGames: NSArray) -> Void) -> Void {
        //First get ones already in core data
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Game")
        var games:[Game] = []
        
        let df = NSDateFormatter()
        df.dateFormat = "MMMM-dd-yyyy"
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            games = results as! [Game]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //now get ones from server
        Alamofire.request(.GET, SERVER_URL).responseJSON {
            response in

            guard let dataFromNetworking = response.data else {
                return
            }
            
            guard let jsonData:JSON = JSON(data: dataFromNetworking) else {
               return
            }
            
            guard let jsonGameArray: [JSON] = jsonData["upcoming"].arrayValue else {
                return
            }
            
            for element in jsonGameArray {
                
                var platformSringArray: [String] = [String]()
                var platformString = ""
                
                guard let name = element["name"].string else {
                    print("Invalid name json")
                    return
                }
                
                guard let lastUpdate = element["last_updated"].string else {
                    print("Invalid last_update json")
                    return
                }
                
                guard let releaseDate = element["release_date"].string else {
                    print("Invalid release_date json")
                    return
                }
                
                guard let color = element["color"].string else {
                    print("Invalid color json")
                    return
                }
                
                guard let genre = element["genre"].string else {
                    print("Invalid genre json")
                    return
                }
               
                guard let imageUrl = element["image_url"].string else{
                    print ("Invalid imageUrl json")
                    return
                }
                
                guard let platforms: [JSON] = element["platforms"].arrayValue else {
                    print("Invalid platform json")
                    return
                }
                
                for platform in platforms {
                    platformString = platformString + ", " + platform.stringValue
                    platformSringArray.append(platform.stringValue)
                }
                
                var alreadySaved = false
                for g in games {
                    if g.name == name {
                        alreadySaved = true
                    }
                }
                
                if (!alreadySaved){ //we don't have it, so save it
                    //Save in core data now that we have the fields
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    let managedContext = appDelegate.managedObjectContext
                    let gameEntity =  NSEntityDescription.entityForName("Game", inManagedObjectContext:managedContext)
                    let platformEntity =  NSEntityDescription.entityForName("Platform", inManagedObjectContext:managedContext)
                    
                    let game = NSManagedObject(entity: gameEntity!, insertIntoManagedObjectContext: managedContext) as! Game
                    
                    
                    game.setValue(name, forKey: "name")
                    game.setValue(lastUpdate, forKey: "lastUpdated")
                    game.setValue(releaseDate, forKey: "releaseDate")
                    game.setValue(color, forKey: "color")
                    game.setValue(genre, forKey: "genre")
                    game.setValue(imageUrl, forKey: "imageUrl")
                    game.setValue(platformString, forKey: "platformString")
                    if (releaseDate.hasPrefix("Q") == false &&
                        releaseDate.hasPrefix("T") == false) { //Q4, TBA
                            game.setValue(df.dateFromString(releaseDate), forKey: "sortDate")
                    } else {
                        game.setValue(df.dateFromString("April 18, 2018"), forKey: "sortDate")
                    }
                    
                    for platform in platformSringArray {
                        let platformObj = NSManagedObject(entity: platformEntity!, insertIntoManagedObjectContext: managedContext) as! Platform
                        platformObj.platformName = platform
                        game.addPlatformsObject(platformObj)
                    }
                    
                    do {
                        try managedContext.save()
                        //append it to what we respond with
                        games.append(game)
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                }
            }
            completionHandler(pGames: games)
        }
    }
}