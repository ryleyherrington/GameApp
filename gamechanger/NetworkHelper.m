//
//  NetworkHelper.m
//  gamechanger
//
//  Created by Ryley Herrington on 9/13/15.
//  Copyright (c) 2015 Ryley Herrington. All rights reserved.
//

#import "NetworkHelper.h"
#import "Game.h"
#import "AppDelegate.h"
#import "gamechanger-Swift.h"


@implementation NetworkHelper

/*
 {
 upcoming: [
 {
 cover_art: "CoDTerrible.jpg",
 image_url: "http://i.imgur.com/b78CZEG.jpg",
 last_updated: "08/1/2015",
 name: "Call of Duty Terrible Warfare",
 release_date: "03/10/2100"
 },
 {
 cover_art: "BlartBlartBlart.jpg",
 image_url: "http://i.imgur.com/9lZyc04.png",
 last_updated: "08/20/2015",
 name: "Paul Blart, Mall Blart",
 release_date: "12/12/2115"
 }
 ]
 } 
 */
- (void)getGamesWithCompletion:(void(^)(NSArray *games))completionBlock
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NetworkingProvider* pProvider = [[NetworkingProvider alloc] init];
    
    [pProvider GetGamesFromServerWithCompletion:^(NSArray* games){
        return;
    }];

    
    NSURL *url = [NSURL URLWithString:@"https://gamescraper-1037.appspot.com/upcoming"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    __block NSDictionary *json = nil;
    __block NSError *errResult = nil;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data == nil) {
            if (completionBlock) {
                NSLog(@"Uh oh, no data");
                completionBlock(nil);
                
                return;
            }
        }
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errResult];
        
        if (!errResult && json != nil) {
            NSMutableArray* games= [[NSMutableArray alloc] init];
            NSArray *upcoming = [json objectForKey:@"upcoming"];
            
            for (NSDictionary *dict in upcoming) {
                NSString *name = (NSString *)[dict valueForKey:@"name"];
                NSString *imageUrl = (NSString *)[dict valueForKey:@"image_url"];
                NSString *releaseDate = (NSString *)[dict valueForKey:@"release_date"];
                
                
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:context];
                Game* newGame = [[Game alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                newGame.imageUrl = imageUrl;
                newGame.name = name;
                newGame.releaseDate = releaseDate;
                
                [games addObject:newGame];
            }
            
            NSError* coreDataError;
            if (![context save:&coreDataError]) {
                NSLog(@"Uh oh, couldn't save:%@", [coreDataError localizedDescription]);
            }
            
            completionBlock(games);
        }
    }];
}

@end
