//
//  MovieDetailsViewController.h
//  rottentomatoes
//
//  Created by Ravi Sathyam on 10/17/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *detailedMovieImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailedMovieLabel;
@property NSDictionary* movieDetails;
@end
