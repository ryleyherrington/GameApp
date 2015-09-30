//
//  Game.h
//  gamechanger
//
//  Created by Ryley Herrington on 9/13/15.
//  Copyright (c) 2015 Ryley Herrington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * releaseDate;

@end
