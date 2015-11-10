//
//  Platform+CoreDataProperties.h
//  gamechanger
//
//  Created by Ryley Herrington on 11/3/15.
//  Copyright © 2015 Ryley Herrington. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Platform.h"

NS_ASSUME_NONNULL_BEGIN

@interface Platform (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *platformName;
@property (nullable, nonatomic, retain) NSSet<Game *> *games;

@end

@interface Platform (CoreDataGeneratedAccessors)

- (void)addGamesObject:(Game *)value;
- (void)removeGamesObject:(Game *)value;
- (void)addGames:(NSSet<Game *> *)values;
- (void)removeGames:(NSSet<Game *> *)values;

@end

NS_ASSUME_NONNULL_END
