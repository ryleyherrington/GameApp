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
    var filterView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = true
        self.title = "Gamers Forecast"
        
        let network = NetworkingProvider()
        network.GetGamesFromServerWithCompletion { (pGames) -> Void in
            self.games = pGames as! [Game]
            self.getGames()
        }
        
        self.createFilterView()
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
   
    func getGamesWithFilter(filterString:NSString){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Game")
        //TODO: MAKE THIS WORK
        //let resultPredicate = NSPredicate(format: "predicateString contains[c] %@", filterString)
        //fetchRequest.predicate = resultPredicate
        
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
    
    func createFilterView() {
        let width = self.view.frame.size.width
        filterView = UIView(frame: CGRectMake(0, -100, width, 100))
        filterView.backgroundColor = UIColor.blackColor()
        filterView.hidden = true
        self.view?.addSubview(filterView)
    }
    
    func filterButtonTouched(sender: UIButton){
        print("TOUCHED: \(sender.titleLabel?.text)")
        if sender.backgroundColor == UIColor.whiteColor() {
            sender.backgroundColor = UIColor.blackColor()
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: (sender.titleLabel?.text)!)
        } else {
            sender.backgroundColor = UIColor.whiteColor()
            sender.setTitleColor(UIColor.blackColor(), forState: .Normal)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: (sender.titleLabel?.text)!)
        }
        self.toggleFilterView()
        self.getGamesWithFilter((sender.titleLabel?.text)!)
    }
  
    func toggleFilterView(){
        let width = self.view.frame.size.width
        if (filterView.hidden == true) { //show it
            filterView.hidden = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.filterView.frame = CGRectMake(0, 64, width, 100)
                }, completion: { (finished) -> Void in
                    self.filterView.hidden = false
            })
        } else { //hide it
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.filterView.frame = CGRectMake(0, -100, width, 100)
                }, completion: { (finished) -> Void in
                    self.filterView.hidden = true
            })
//            UIView.animateWithDuration(0.2, animations: {
//                self.filterView.frame = CGRectMake(0, -100, width, 100)
//                }, completion: { finished in
//                    self.filterView.hidden = true
//            })
        }
    }
    
    @IBAction func barButtonPressed(sender: AnyObject) {
        let width = self.view.frame.size.width
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let ps4Filter = defaults.boolForKey("PS4")
        let x1Filter = defaults.boolForKey("XBOX ONE")
        let pcFilter = defaults.boolForKey("PC")
        let ps3Filter = defaults.boolForKey("PS3")
        let x360Filter = defaults.boolForKey("XBOX 360")
        let wiiFilter = defaults.boolForKey("WII")
        
        //row 1
        let ps4 = UIButton(frame: CGRectMake(0, 0, width/3, 50))
        let x1 = UIButton(frame: CGRectMake(width/3, 0, width/3, 50))
        let pc = UIButton(frame: CGRectMake(width - width/3, 0, width/3, 50))
        ps4.setTitle("PS4", forState: .Normal)
        x1.setTitle("XBOX ONE", forState: .Normal)
        pc.setTitle("PC", forState: .Normal)
        if (ps4Filter == true){
            ps4.backgroundColor = UIColor.whiteColor()
            ps4.setTitleColor(UIColor.blackColor(), forState: .Normal)
        } else {
            ps4.backgroundColor = UIColor.blackColor()
            ps4.titleLabel?.textColor = UIColor.whiteColor()
        }
        if (x1Filter == true){
            x1.backgroundColor = UIColor.whiteColor()
            x1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        } else {
            x1.backgroundColor = UIColor.blackColor()
            x1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        if (pcFilter == true){
            pc.backgroundColor = UIColor.whiteColor()
            pc.setTitleColor(UIColor.blackColor(), forState: .Normal)
        } else {
            pc.backgroundColor = UIColor.blackColor()
            pc.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        
        ps4.addTarget(self, action: "filterButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        x1.addTarget(self, action: "filterButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        pc.addTarget(self, action: "filterButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)

        
        
        //row 2
        let ps3 = UIButton(frame: CGRectMake(0, 50, width/3, 50))
        let x360 = UIButton(frame: CGRectMake(width/3, 50, width/3, 50))
        let wii = UIButton(frame: CGRectMake(width - width/3, 50, width/3, 50))
        ps3.setTitle("PS3", forState: .Normal)
        x360.setTitle("XBOX 360", forState: .Normal)
        wii.setTitle("WII", forState: .Normal)
        
        if (ps3Filter == true){
            ps3.backgroundColor = UIColor.whiteColor()
            //TODO: CHANGE THE LAST THREE TO CORRECT TEXT COLOR SEE ABOVE
            ps3.titleLabel?.textColor = UIColor.blackColor()
        } else {
            ps3.backgroundColor = UIColor.blackColor()
            ps3.titleLabel?.textColor = UIColor.whiteColor()
        }
        if (x360Filter == true){
            x360.backgroundColor = UIColor.whiteColor()
            x360.titleLabel?.textColor = UIColor.blackColor()
        } else {
            x360.backgroundColor = UIColor.blackColor()
            x360.titleLabel?.textColor = UIColor.whiteColor()
        }
        if (wiiFilter == true){
            wii.backgroundColor = UIColor.whiteColor()
            wii.titleLabel?.textColor = UIColor.blackColor()
        } else {
            wii.backgroundColor = UIColor.blackColor()
            wii.titleLabel?.textColor = UIColor.whiteColor()
        }
        
        ps3.addTarget(self, action: "filterButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        x360.addTarget(self, action: "filterButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        wii.addTarget(self, action: "filterButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
       
        filterView.addSubview(ps4)
        filterView.addSubview(x1)
        filterView.addSubview(wii)
        filterView.addSubview(ps3)
        filterView.addSubview(x360)
        filterView.addSubview(pc)
        
        self.toggleFilterView()
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
        cell.openView.frame = CGRectMake(width, 0, width/2, height)
        cell.dateLabel.text = game.valueForKey("releaseDate") as? String
        var platforms = game.valueForKey("platformString") as? String
        if (platforms!.hasPrefix(",")) {
            platforms = String(platforms!.characters.dropFirst())
        }
        cell.platforms.text = platforms
        
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
        
        if game.image != nil{
            let returnedImage = UIImage(data:game.image!)
            cell.imageView.image = returnedImage
        } else{
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
                        let imageData = NSData(data: UIImageJPEGRepresentation(returnedImage!, 1.0)!)
                        game.setValue(imageData, forKey: "image")
                        
                        return
                    }
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
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                cell.openView.frame = CGRectMake(width, 0, width/2, height)
                }, completion: {(done) -> Void in
                    cell.isOpen = false;
            })
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
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
