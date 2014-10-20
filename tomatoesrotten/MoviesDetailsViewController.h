//
//  MoviesDetailsViewController.h
//  rottentomatoes
//
//  Created by Ravi Sathyam on 10/19/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *movieDetailsTableView;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterView;
@property (strong, atomic) NSDictionary* movieDetails;
@end
