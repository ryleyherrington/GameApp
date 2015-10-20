//
//  ViewController.m
//  gamechanger
//
//  Created by Ryley Herrington on 9/13/15.
//  Copyright (c) 2015 Ryley Herrington. All rights reserved.
//

#import "ViewController.h"
#import "DefaultFlowLayout.h"
#import "GameCollectionViewCell.h"
#import "AppDelegate.h"
#import "Game.h"
#import "NetworkHelper.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *fetchedGames;
@property (nonatomic, strong) UILabel *emptyLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCollectionView];
    NetworkHelper* nh = [[NetworkHelper alloc] init];
    [nh getGamesWithCompletion:^(NSArray *games) {
        _fetchedGames = games;
        [self.collectionView reloadData];
    }];
    self.navigationController.hidesBarsOnSwipe = YES;

    
   // [self setupEmptyLabel];
    
    self.navigationItem.title = @"GamersForecast";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getGames];
}

- (void)setupEmptyLabel
{
    _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                            self.navigationController.navigationBar.frame.size.height + 20,
                                                            self.view.frame.size.width - 20,
                                                            90)];
    
    _emptyLabel.text = @"We are downloading the games.";
    _emptyLabel.textColor = [UIColor darkGrayColor];
    _emptyLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:16.f];
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _emptyLabel.numberOfLines = 0;
    _emptyLabel.hidden = YES;
    
    [self.view addSubview:_emptyLabel];
}

- (void)setupCollectionView
{
    DefaultFlowLayout *layout = [[DefaultFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    
    [_collectionView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height,
                                                      0,
                                                      0,
                                                      0)];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setScrollEnabled:YES];
    
    _collectionView.bounces = YES;
    _collectionView.alwaysBounceVertical = YES;
    
    [_collectionView registerClass:[GameCollectionViewCell class] forCellWithReuseIdentifier:[GameCollectionViewCell reuseIdentifier]];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewId"];

//    [_collectionView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_collectionView setBackgroundColor:[UIColor darkGrayColor]];
    
    [self.view addSubview:_collectionView];
}

- (void)getGames
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    _fetchedGames = [context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"Fetched:%@", _fetchedGames);
//    for (NSManagedObject *info in _fetchedGames) {
//        NSLog(@"Name: %@", [info valueForKey:@"name"]);
//        NSLog(@"ImageUrl: %@",    [info valueForKey:@"imageUrl"]);
//    }
    
    [self.collectionView reloadData];
    
//    if ([_fetchedGames count] < 1) {
//        _emptyLabel.hidden = NO;
//        _collectionView.hidden = YES;
//    } else {
//        _emptyLabel.hidden = YES;
//        _collectionView.hidden = NO;
//    }
}

#pragma mark - UICollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_fetchedGames count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(self.view.frame.size.width - 20, (self.view.frame.size.width-20)/2.23);
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/2.23);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(0, 50);
//}
//
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//    if (kind == UICollectionElementKindSectionHeader) {
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewId" forIndexPath:indexPath];
//        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//        label.text = @"hey";
//        [headerView addSubview:label];
//        reusableview = headerView;
//    }
//    
////    if (kind == UICollectionElementKindSectionFooter) {
////        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
////        reusableview = footerview;
////    }
////    
//    return reusableview;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[GameCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    cell.imageView.image = nil;
    cell.isOpen = NO;
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
//    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
//    [collectionView addGestureRecognizer:swipeGesture];

    Game* game = [_fetchedGames objectAtIndex:indexPath.row];
    cell.dateView.text = game.releaseDate;
    CGFloat red   = 127.f;
    CGFloat green = 191.f;
    CGFloat blue  = 255.f;
    cell.dateView.backgroundColor = [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:1.0];
    cell.dateView.hidden = YES;
    
    cell.title.text = game.name;//[[game valueForKey:@"name"] capitalizedString];
    if (game.imageUrl != nil){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSURL *imageURL = [NSURL URLWithString:game.imageUrl];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage* image = [UIImage imageWithData:imageData];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [cell.imageView setImage:image];
            });
        });
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"placeholder"]];
        [cell sendSubviewToBack:cell.imageView];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row:%ld", (long)indexPath.row);
    NSManagedObject *info = _fetchedGames[(int)indexPath.row];
    NSLog(@"name: %@", [info valueForKey:@"name"]);
    NSLog(@"imageUrl: %@",    [info valueForKey:@"imageUrl"]);

    GameCollectionViewCell *cell = (GameCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isOpen){
        [UIView animateWithDuration:.4 animations:^{
            CGFloat width = cell.frame.size.width/2;
            [cell.dateView setFrame:CGRectMake(self.view.frame.size.width, 0, width, cell.frame.size.height)];
        }completion:^(BOOL finished) {
            cell.dateView.hidden = YES;
            cell.isOpen = NO;
        }];
    } else {
        [UIView animateWithDuration:.4 animations:^{
            cell.dateView.hidden = NO;
            CGFloat width = cell.frame.size.width/2;
            [cell.dateView setFrame:CGRectMake(cell.frame.size.width-width, 0, width, cell.frame.size.height)];
        } completion:^(BOOL finished) {
            cell.isOpen = YES;
        }];
    }
    
}

-(void) handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
    
}
@end
