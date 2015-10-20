//
//  SocialFlowLayout.m
//  Trapit
//
//  Created by Ryley Herrington on 6/26/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

#import "DefaultFlowLayout.h"

@implementation DefaultFlowLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width, 64);
    self.minimumInteritemSpacing = 5.0f;
    self.minimumLineSpacing = 5.0f;
    
    return self;
}

@end
