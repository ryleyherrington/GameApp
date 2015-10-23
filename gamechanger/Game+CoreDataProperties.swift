//
//  Game+CoreDataProperties.swift
//  gamechanger
//
//  Created by Ryley Herrington on 10/20/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Game {

    @NSManaged var imageUrl: String?
    @NSManaged var name: String?
    @NSManaged var releaseDate: String?
    @NSManaged var color: String?
    @NSManaged var image: NSData?
    @NSManaged var genre: String?
    @NSManaged var lastUpdated: String?
    @NSManaged var platformString: String?
    @NSManaged var platforms: NSSet?

}
