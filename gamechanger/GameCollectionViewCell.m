//
//  GameCollectionViewCell.m
//  gamechanger
//
//  Created by Ryley Herrington on 9/13/15.
//  Copyright (c) 2015 Ryley Herrington. All rights reserved.
//

#import "GameCollectionViewCell.h"


@implementation GameCollectionViewCell

+(NSString*)reuseIdentifier {
    return @"reuseIdentifier";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.isOpen = NO;
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0, frame.size.width - 20, 44.f)];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.textColor = [UIColor whiteColor];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.f];
        self.title.numberOfLines = 1;
        
        [self addSubview:self.title];;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.hidden = NO;
        [self addSubview:_imageView];
        

        CGFloat width = self.frame.size.width/2;
        _dateView = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, width, self.frame.size.height)];
        _dateView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.f];
        [_dateView setNumberOfLines:0];
        [_dateView setLineBreakMode:NSLineBreakByWordWrapping];
        _dateView.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_dateView];
                // Build a triangular path
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:(CGPoint){50, 0}];
        [path addLineToPoint:(CGPoint){0, self.frame.size.height}];
        [path addLineToPoint:(CGPoint){width, self.frame.size.height}];
        [path addLineToPoint:(CGPoint){width, 0}];
        
        // Create a CAShapeLayer with this triangular path
        // Same size as the original imageView
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = _dateView.bounds;
        mask.path = path.CGPath;
        
        // Mask the imageView's layer with this shape
        _dateView.layer.mask = mask;
 
    }
    
    return self;
}

@end
