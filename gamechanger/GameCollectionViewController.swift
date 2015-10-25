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
    var emptyView:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = true
        self.title = "Gamers Forecast"
        
        self.createFilterView()
        self.createEmptyView()
        
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
        
        let resultPredicate = NSPredicate(format: "ANY platforms.platformName in %@", filterArray())
        fetchRequest.predicate = resultPredicate
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            games = results as! [Game]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        collectionView?.reloadData()

        if games.count == 0 {
           self.emptyView.hidden = false
        } else {
            self.emptyView.hidden = true
        }
    }
 
    
    func filterArray()->NSArray {
        var filterArr: [String] = []
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let ps4Filter = defaults.boolForKey("PS4")
        let x1Filter = defaults.boolForKey("Xbox One")
        let pcFilter = defaults.boolForKey("PC")
        let ps3Filter = defaults.boolForKey("PS3")
        let x360Filter = defaults.boolForKey("Xbox 360")
        let wiiFilter = defaults.boolForKey("Wii")
        
        if ps4Filter {
            filterArr.append("PS4")
        }
        if x1Filter {
            filterArr.append("Xbox One")
        }
        if pcFilter {
            filterArr.append("PC")
        }
        if ps3Filter {
            filterArr.append("PS3")
        }
        if x360Filter {
            filterArr.append("Xbox 360")
        }
        if wiiFilter {
            filterArr.append("Wii")
        }
       
        let date = NSDate()
        let outFormatter = NSDateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        outFormatter.dateFormat = "hh:mm"
        
        let dimensions = [
            "time" : outFormatter.stringFromDate(date),
            "filterValues" : filterArr.description
        ]
        PFAnalytics.trackEvent("filtered", dimensions: dimensions)
        
        return filterArr
    }
    
    func createFilterView() {
        let width = self.view.frame.size.width
        filterView = UIView(frame: CGRectMake(0, -100, width, 100))
        filterView.backgroundColor = UIColor.blackColor()
        filterView.hidden = true
        self.view?.addSubview(filterView)
    }
    
    func createEmptyView() {
        let width = self.view.frame.size.width
        emptyView = UILabel(frame: CGRectMake(20, 200, width - 40, 100))
        emptyView.backgroundColor = UIColor.darkGrayColor()
        emptyView.text = "Choose a platform to look for, or choose more than one to expand your search!"
        emptyView.font = UIFont (name: "HelveticaNeue-Light", size: 18)
        emptyView.numberOfLines = 0
        emptyView.textAlignment = .Center
        emptyView.textColor = UIColor.whiteColor()
        emptyView.hidden = true
        self.collectionView?.addSubview(emptyView)
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
        self.getGames()
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

        }
    }

    func createButtonWithName(name:NSString, frame:CGRect){
        let button = UIButton(frame: frame)
        
        button.setTitle(name as String, forState: .Normal)
        button.addTarget(self, action: "filterButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let filter = NSUserDefaults.standardUserDefaults().boolForKey(name as String)
        if (filter == true){
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        } else {
            button.backgroundColor = UIColor.blackColor()
            button.titleLabel?.textColor = UIColor.whiteColor()
        }
        
        filterView.addSubview(button)
    }
    
    @IBAction func barButtonPressed(sender: AnyObject) {
        let width = self.view.frame.size.width
        
        //row 1
        self.createButtonWithName("PS4", frame:CGRectMake(0, 0, width/3, 50))
        self.createButtonWithName("Xbox One", frame:CGRectMake(width/3, 0, width/3, 50))
        self.createButtonWithName("PC", frame:CGRectMake(width - width/3, 0, width/3, 50))
        
        //row 2
        self.createButtonWithName("PS3", frame:CGRectMake(0, 50, width/3, 50))
        self.createButtonWithName("Xbox 360", frame:CGRectMake(width/3, 50, width/3, 50))
        self.createButtonWithName("Wii", frame:CGRectMake(width - width/3, 50, width/3, 50))
        
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
        let game = games[indexPath.row]
        
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
                    let date = NSDate()
                    let outFormatter = NSDateFormatter()
                    outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    outFormatter.dateFormat = "hh:mm"
                    
                    let dimensions = [
                        //I'd like to have user id here sometime... twitter integration or something?
                        "time" : outFormatter.stringFromDate(date),
                        "game" : game.name!
                    ]
                    
                    // Send the dimensions to Parse along with the 'read' event
                    PFAnalytics.trackEvent("opened", dimensions: dimensions)
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
