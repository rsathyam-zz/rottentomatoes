//
//  MoviesViewController.h
//  rottentomatoes
//
//  Created by Ravi Sathyam on 10/16/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController <UITabBarDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollectionView;

@end