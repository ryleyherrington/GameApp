//
//  Game+CoreDataProperties.h
//  gamechanger
//
//  Created by Ryley Herrington on 10/25/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Game.h"

NS_ASSUME_NONNULL_BEGIN

@interface Game (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *color;
@property (nullable, nonatomic, retain) NSString *genre;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *lastUpdated;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *platformString;
@property (nullable, nonatomic, retain) NSString *releaseDate;
@property (nullable, nonatomic, retain) NSSet<Platform *> *platforms;

@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addPlatformsObject:(Platform *)value;
- (void)removePlatformsObject:(Platform *)value;
- (void)addPlatforms:(NSSet<Platform *> *)values;
- (void)removePlatforms:(NSSet<Platform *> *)values;

@end

NS_ASSUME_NONNULL_END
