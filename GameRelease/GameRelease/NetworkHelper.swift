//
//  NetworkHelper.swift
//  GameRelease
//
//  Created by Ryley Herrington on 8/20/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//

import UIKit

class NetworkHelper: NSObject {
/*
    {
    upcoming: [
    {
    cover_art: "CoDTerrible.jpg",
    last_updated: "08/14/2015",
    name: "Call of Duty Terrible Warfare",
    release_date: "03/17/2100"
    },
    {
    cover_art: "BlartBlartBlart.jpg",
    last_updated: "08/20/2015",
    name: "Paul Blart, Mall Blart",
    release_date: "12/12/2015"
    },
    {
    cover_art: "CoDTerrible.jpg",
    last_updated: "08/1/2015",
    name: "Call of Duty Terrible Warfare",
    release_date: "03/10/2100"
    },
    {
    cover_art: "BlartBlartBlart.jpg",
    last_updated: "08/20/2015",
    name: "Paul Blart, Mall Blart",
    release_date: "12/12/2115"
    }
    ]
    }
*/
    func getGames() {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(
            NSMutableURLRequest(URL:NSURL(string:"https://gamescraper-1037.appspot.com/upcoming")!)
            ){(data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let result = NSString(data: data!, encoding: NSASCIIStringEncoding)!
                //let parsed = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
                print(result)
            }
        }
        task.resume()
        //        println(NSString(data: data, encoding: NSUTF8StringEncoding))
        //    }
    }
   
}
