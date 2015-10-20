//
//  GameCollectionViewController.swift
//  gamechanger
//
//  Created by Ryley Herrington on 10/11/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GameCell"

class GameCollectionViewController: UICollectionViewController {
    var games:[Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.hidesBarsOnSwipe = true
//        navigationController?.title = "Gamers Forecast"
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
        
        //    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
        //    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
        //    [collectionView addGestureRecognizer:swipeGesture];
        
        let game = games[indexPath.row]
        
        cell.nameLabel.text = game.valueForKey("name") as? String
        cell.backgroundColor = UIColor.redColor()
        cell.imageView.image = UIImage(named: "placeholder")
        if let label = cell.dateLabel{
            label.text = game.valueForKey("releaseDate") as? String
        }
        
        let color = game.valueForKey("color") as? String
        if let openView = cell.openView{
            openView.backgroundColor = hexStringToUIColor(color!)
        }
        
        
        let loadURL = NSURL(string:game.imageUrl!)
        let loadRequest = NSURLRequest(URL:loadURL!)
        NSURLConnection.sendAsynchronousRequest(loadRequest,
            queue: NSOperationQueue.mainQueue()) {
                response, data, error in
                
                if error != nil {
                    //failed... do something?
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
        print("cell.isOpen: \(cell.isOpen)")
        
        let width = cell.frame.size.width;
        let height = cell.frame.size.height;
        if (cell.isOpen){
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                if let openView = cell.openView {
                    openView.frame = CGRectMake(width, 0, width/2, height)
                }
                }, completion: {(done) -> Void in
                    if let openView = cell.openView{
                        openView.hidden = true;
                    }
                cell.isOpen = false;
            })
            
        } else {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                if let openView = cell.openView{
                    openView.hidden = false;
                    openView.frame = CGRectMake(width-width/2, 0, width/2, height)
                }
                }, completion: { (done) -> Void in
                    cell.isOpen=true
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
