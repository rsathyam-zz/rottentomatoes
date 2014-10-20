//
//  MovieDetailsViewController.m
//  rottentomatoes
//
//  Created by Ravi Sathyam on 10/17/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

@interface MovieDetailsViewController ()
@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary* posters = self.movieDetails[@"posters"];
    NSString* thumbnail = posters[@"original"];
    
    //Replace 'tmb' with 'ori' to get the high def images
    NSString* original = [thumbnail stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_ori.jpg"];
    
    NSURLRequest* request = [ [NSURLRequest alloc] initWithURL:[NSURL URLWithString:original]];
    
    CGSize targetSize = self.view.bounds.size;
    [SVProgressHUD show];
    [self.detailedMovieImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
/*
        CGFloat imageHeight = image.size.height;
        CGFloat imageWidth = image.size.width;
        
        CGSize newSize = targetSize;
        CGFloat scaleFactor = targetSize.width / imageWidth;
        newSize.height = imageHeight * scaleFactor;
 */
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
//        UIImage *resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [SVProgressHUD dismiss];
        [self.detailedMovieImageView setImage:image];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", error);
    }];
    self.detailedMovieImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.detailedMovieImageView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
