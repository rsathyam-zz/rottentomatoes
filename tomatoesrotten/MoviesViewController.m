//
//  MoviesViewController.m
//  rottentomatoes
//
//  Created by Ravi Sathyam on 10/16/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "MoviesViewController.h"
//#import "MovieDetailsViewController.h"
#import "MoviesDetailsViewController.h"
//#import "MoviesTableViewCell.h"
#import "MoviesCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (weak, nonatomic) IBOutlet UILabel *networkFailureLabel;
@property (weak, nonatomic) IBOutlet UITabBar *movieCategoryBar;
@property (weak, nonatomic) IBOutlet UIView *networkFailureView;
@property (strong, atomic) NSArray* movies;
@property bool isBoxOfficeView;
@property UIRefreshControl *refreshControl;
@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.moviesCollectionView.delegate = self;
    self.moviesCollectionView.dataSource = self;
    self.movieCategoryBar.delegate = self;
    self.title = @"Box Office";
    self.networkFailureLabel.text = @"Network Failure";
    self.networkFailureView.hidden = true;
    
//    [self.moviesTableView registerNib:[UINib nibWithNibName:@"MoviesTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoviesTableViewCell"];
    [self.moviesCollectionView registerNib:[UINib nibWithNibName:@"MoviesCollectionViewCell" bundle:nil]
        forCellWithReuseIdentifier:@"MoviesTableViewCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.moviesCollectionView insertSubview:self.refreshControl atIndex:0];
    
    NSURL* url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=50&country=us&apikey=fa5tazjnfbbngqbwcy6v74zn"];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];

    [SVProgressHUD show];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [SVProgressHUD dismiss];
        if(connectionError || !data || !response) {
            self.networkFailureView.hidden = false;
        } else {
        self.movies = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"movies"];
        }
        [self.moviesCollectionView reloadData];
    }];
}

- (void)onRefresh {
    self.networkFailureView.hidden = true;
    NSURL* url;
    if (self.isBoxOfficeView == true) {
        url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=50&country=us&apikey=fa5tazjnfbbngqbwcy6v74zn"];
    } else {
        url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?limit=50&country=us&apikey=fa5tazjnfbbngqbwcy6v74zn"];
    }
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    [SVProgressHUD show];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        if(connectionError || !data || !response) {
            self.networkFailureView.hidden = true;
        } else {
            self.movies = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"movies"];
        }
        [self.moviesCollectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoviesCollectionViewCell* mtvc = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoviesTableViewCell" forIndexPath:indexPath];
     NSDictionary* movie = self.movies[indexPath.row];
     NSDictionary* posters = movie[@"posters"];
     NSString* thumbnail = posters[@"thumbnail"];
     NSString* original = [thumbnail stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_ori.jpg"];
    
     NSData * image_data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: thumbnail]];
    
     NSURLRequest* request = [ [NSURLRequest alloc] initWithURL:[NSURL URLWithString:original]];
     CGSize targetSize = mtvc.movieImageView.bounds.size;
     UIImage * image = [UIImage imageWithData:image_data];
     UIImage * resized_thumbnail;
     UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
     [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
     resized_thumbnail = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
    
    __block UIImage* resized;
    __weak MoviesCollectionViewCell* mtvc_weak = mtvc;
    [mtvc.movieImageView setImageWithURLRequest:request placeholderImage:resized_thumbnail success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
        resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [mtvc_weak.movieImageView setImage:resized];
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         self.networkFailureView.hidden = true;
//         NSLog(@"%@", error);
     }];
     mtvc.movieImageView.contentMode = UIViewContentModeScaleAspectFill;
     mtvc.movieImageView.clipsToBounds = YES;
     return mtvc;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MoviesDetailsViewController* mdvc = [[MoviesDetailsViewController alloc] init];
    mdvc.movieDetails = self.movies[indexPath.row];
    [self.navigationController pushViewController:mdvc animated:YES];
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"Box Office"]) {
        if(self.isBoxOfficeView == false) {
            self.title = @"Box Office";
            NSURL* url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=50&country=us&apikey=fa5tazjnfbbngqbwcy6v74zn"];
            NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
            [SVProgressHUD show];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                [SVProgressHUD dismiss];
                [self.refreshControl endRefreshing];
                self.movies = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"movies"];
                [self.moviesCollectionView insertSubview:self.refreshControl atIndex:0];
                [self.moviesCollectionView reloadData];
            }];
        }
        self.isBoxOfficeView = true;
    } else if ([item.title isEqualToString:@"Rentals"]) {
        if(self.isBoxOfficeView == true) {
            NSURL* url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?limit=50&country=us&apikey=fa5tazjnfbbngqbwcy6v74zn"];
            self.title = @"Rentals";
            NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
            [SVProgressHUD show];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                [SVProgressHUD dismiss];
                [self.refreshControl endRefreshing];
                self.movies = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"movies"];
                [self.moviesCollectionView insertSubview:self.refreshControl atIndex:0];
                [self.moviesCollectionView reloadData];
            }];
        }
        self.isBoxOfficeView = false;
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
