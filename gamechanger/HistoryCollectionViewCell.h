//
//  HistoryCollectionViewCell.h
//  wikiwaster
//
//  Created by Herrington, Ryley on 5/18/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCollectionViewCell : UICollectionViewCell

@property (retain, nonatomic) UILabel *title;
@property (retain, nonatomic) UILabel *subtitle;

+ (NSString *)reuseIdentifier;

@end
