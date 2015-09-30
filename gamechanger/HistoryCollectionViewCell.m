//
//  HistoryCollectionViewCell.m
//  wikiwaster
//
//  Created by Herrington, Ryley on 5/18/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

#import "HistoryCollectionViewCell.h"
#import "UIColor+WikiColors.h"

@implementation HistoryCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0, frame.size.width - 20, 44.f)];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.textColor = [UIColor globalColor];
        self.title.backgroundColor = [UIColor whiteColor];
        self.title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.f];
        self.title.numberOfLines = 1;

        [self addSubview:self.title];;

        self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 35.0, frame.size.width - 20, 44.f)];
        self.subtitle.textAlignment = NSTextAlignmentLeft;
        self.subtitle.textColor = [UIColor blackColor];
        self.subtitle.backgroundColor = [UIColor whiteColor];
        self.subtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
        self.subtitle.numberOfLines = 2;

        [self addSubview:self.subtitle];
    }
    self.backgroundColor = [UIColor whiteColor];

    return self;
}

+ (NSString *)reuseIdentifier
{
   return @"historyCellReuseIdentifier";
}

@end
