//
//  NetworkHelper.h
//  gamechanger
//
//  Created by Ryley Herrington on 9/13/15.
//  Copyright (c) 2015 Ryley Herrington. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHelper : NSObject

- (void)getGamesWithCompletion:(void(^)(NSArray *games))completionBlock;

@end
