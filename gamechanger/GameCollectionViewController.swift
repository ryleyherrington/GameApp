//
//  GameCollectionViewController.swift
//  gamechanger
//
//  Created by Ryley Herrington on 10/11/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//

import UIKit
import Parse

class GameCollectionViewController: UICollectionViewController {
    var games:[Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.hidesBarsOnSwipe = true
        self.title = "Gamers Forecast"
        
        let network = NetworkingProvider()
        network.GetGamesFromServerWithCompletion { (pGames) -> Void in
            self.games = pGames as! [Game]
            self.getGames()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getGames() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Game")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            games = results as! [Game]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        for g in games {
            games.append(g)
        }
        collectionView?.reloadData()
    }
    
    
    @IBAction func barButtonPressed(sender: AnyObject) {
        
    }
    
   func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/2.23)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets{
            return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (games.count > 0) {
            return games.count
        } else {
          return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GameCell", forIndexPath: indexPath) as! GameCell
        
        cell.imageView.image = nil
        cell.isOpen = false
        
        let game = games[indexPath.row]
        
        let width = cell.frame.size.width;
        let height = cell.frame.size.height;
        
        cell.imageView.image = UIImage(named: "placeholder")
        //cell.openView.frame = CGRectMake(width+50, 0, width/2, height)
                cell.openView.frame = CGRectMake(width, 0, width/2, height)
        cell.dateLabel.text = game.valueForKey("releaseDate") as? String
 
        let color = game.valueForKey("color") as? String
        cell.openView.backgroundColor = hexStringToUIColor(color!)
       
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(50, 0))
        path.addLineToPoint(CGPointMake(0, height))
        path.addLineToPoint(CGPointMake(width, height))
        path.addLineToPoint(CGPointMake(width, 0))
        
        let mask = CAShapeLayer()
        mask.frame = cell.openView.bounds
        mask.path = path.CGPath
        cell.openView.layer.mask = mask
        
        let loadURL = NSURL(string:game.imageUrl!)
        let loadRequest = NSURLRequest(URL:loadURL!)
        NSURLConnection.sendAsynchronousRequest(loadRequest,
            queue: NSOperationQueue.mainQueue()) {
                response, data, error in
                
                if error != nil {
                    print("failed loading image")
                    return
                }
                if data != nil {
                    let returnedImage = UIImage(data: data!)
                    cell.imageView.image = returnedImage
                    cell.sendSubviewToBack(cell.imageView)
                    //TODO:We should save to core data now
                    return
                }
        }
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let cell : GameCell = collectionView.cellForItemAtIndexPath(indexPath)! as! GameCell
        //let game = games[indexPath.row]
        
        print("cell.isOpen: \(cell.isOpen)")
        
        let width = cell.frame.size.width;
        let height = cell.frame.size.height;
       
        
        if (cell.isOpen != false){
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                cell.openView.frame = CGRectMake(width, 0, width/2, height)
                }, completion: {(done) -> Void in
                    cell.isOpen = false;
            })
        } else {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                    cell.openView.frame = CGRectMake(width-width/2, 0, width/2, height)
                }, completion: { (done) -> Void in
                    cell.isOpen=true
                    
//                    let date = NSDate()
//                    let outFormatter = NSDateFormatter()
//                    outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//                    outFormatter.dateFormat = "hh:mm"

//                    let dimensions = [
//                        //I'd like to have user id here sometime... twitter integration or something?
//                        "time" : outFormatter.stringFromDate(date),
//                        "game" : game.name!
//                    ]
//                    
//                    // Send the dimensions to Parse along with the 'read' event
//                    PFAnalytics.trackEvent("opened", dimensions: dimensions)
            })
        }
    }
   
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
