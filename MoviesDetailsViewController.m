//
//  MoviesDetailsViewController.m
//  rottentomatoes
//
//  Created by Ravi Sathyam on 10/19/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "MoviesDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "MoviePosterTableViewCell.h"
#import "MovieTitleTableViewCell.h"

@interface MoviesDetailsViewController ()
@end

@implementation MoviesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.movieDetailsTableView.delegate = self;
    self.movieDetailsTableView.dataSource = self;
    
    [self.movieDetailsTableView registerNib:[UINib nibWithNibName:@"MoviePosterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoviePosterTableViewCell"];
    [self.movieDetailsTableView registerNib:[UINib nibWithNibName:@"MovieTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieTitleTableViewCell"];
//    self.movieDetailsTableView.rowHeight = 300;
    self.movieDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.movieDetailsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    } else {
        return 568;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString* title = self.movieDetails[@"title"];
        MovieTitleTableViewCell* mttvc = [self.movieDetailsTableView dequeueReusableCellWithIdentifier:@"MovieTitleTableViewCell"];
        mttvc.movieTitleTable.text = title;
        return mttvc;
    }
    else {// if (indexPath.row == 1) {
         MoviePosterTableViewCell* mptvc = [self.movieDetailsTableView dequeueReusableCellWithIdentifier:@"MoviePosterTableViewCell"];
         NSDictionary* posters = self.movieDetails[@"posters"];
         NSString* thumbnail = posters[@"thumbnail"];
         NSString* original = [thumbnail stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_ori.jpg"];
         NSData* image_data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:original]];
//         CGSize targetSize =  mptvc.moviePosterImageView.bounds.size;
         CGSize targetSize;
         targetSize.height = 300;
        targetSize.width = 200;
         UIImage * image = [UIImage imageWithData:image_data];
         UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
         [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
         UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();        
         [mptvc.moviePosterImageView setImage:resized];
         mptvc.moviePosterImageView.contentMode = UIViewContentModeScaleAspectFill;
         mptvc.moviePosterImageView.clipsToBounds = YES;
         return mptvc;
    }
 }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
