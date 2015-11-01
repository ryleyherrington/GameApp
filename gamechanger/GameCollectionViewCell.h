//
//  GameCollectionViewCell.h
//  gamechanger
//
//  Created by Ryley Herrington on 9/13/15.
//  Copyright (c) 2015 Ryley Herrington. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GameCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILabel* dateView;
@property (nonatomic, assign) BOOL isOpen;

+(NSString*)reuseIdentifier;

@end
