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
//    let SERVER_URL = "https://gamescraper-1037.appspot.com/upcoming/"
    let SERVER_URL = "https://gamersforecast-1094.appspot.com/games.json"
    
    @objc override init() {
        
    }
    
    @objc func GetGamesFromServerWithCompletion(completionHandler: (pGames: NSArray) -> Void) -> Void {
        
        Alamofire.request(.GET, SERVER_URL).responseJSON {
            response in
            
            var games:[Games] = [Games]()

            
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
                
                guard let platforms: [JSON] = element["platforms"].arrayValue else {
                    print("Invalid platform json")
                    return
                }
                
                for platform in platforms {
                    
                    platformSringArray.append(platform.stringValue)
                }
                
                games.append(Games(gameName: name, gameReleaseDate: releaseDate, gameLastUpdated: lastUpdate, gameGenre: genre, gamePlatforms: platformSringArray, gameColor: color))
                
            }
            
            print ("JSON: \(games)")
            
            completionHandler(pGames: games)
        }
    }
}