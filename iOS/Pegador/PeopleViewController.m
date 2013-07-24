//
//  PeopleViewController.m
//  Pegador
//
//  Created by Pedro Góes on 25/05/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "PeopleViewController.h"
#import "UIImageView+WebCache.h"
#import "NUIRenderer.h"
#import <QuartzCore/QuartzCore.h>

@interface PeopleViewController () {
    NSURL *pic_square;
}

@end

@implementation PeopleViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"People", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CALayer* containerLayer = [CALayer layer];
    containerLayer.shadowColor = [UIColor blackColor].CGColor;
    containerLayer.shadowRadius = 10.f;
    containerLayer.shadowOffset = CGSizeMake(0.f, 5.f);
    containerLayer.shadowOpacity = 1.f;
    
    // Picture
    [self.picture.layer setMasksToBounds:YES];
    [self.picture.layer setCornerRadius:self.picture.frame.size.width / 2.0f];
    [self.picture.layer setBorderColor:[[UIColor colorWithWhite:0.8f alpha:0.8f] CGColor]];
    [self.picture.layer setBorderWidth:2.0];
    
    [containerLayer addSublayer:self.picture.layer];
    [self.view.layer addSublayer:containerLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Facebook Methods

- (void)sendRequests {
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        [self requestCompleted:connection result:result error:error];
    };
    
    NSString *query1 = [NSString stringWithFormat:@"SELECT src_big, like_info FROM photo WHERE owner = %@ ORDER BY like_info.like_count DESC LIMIT 1", self.currentOwnerID];
    NSString *query2 = [NSString stringWithFormat:@"SELECT url, real_width, real_height FROM profile_pic WHERE id = %@ AND width='%f' AND height='%f'", self.currentOwnerID, self.picture.frame.size.width, self.picture.frame.size.height];
    NSString *query3 = [NSString stringWithFormat:@"SELECT name, pic_square FROM page WHERE page_id IN (SELECT page_id FROM page_fan WHERE uid = %@)", self.currentOwnerID];
    
    NSString* fql = [NSString stringWithFormat: @"{\"queryA\":\"%@\",\"queryB\":\"%@\",\"queryC\":\"%@\"}", query1, query2, query3];
    NSDictionary* queryParam = [NSDictionary dictionaryWithObject:fql forKey:@"q"];
    
    // Make the API request that uses FQL
    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"/fql" parameters:queryParam HTTPMethod:@"GET"];
    
    [newConnection addRequest:request completionHandler:handler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.requestConnection cancel];
    self.requestConnection = newConnection;
    [newConnection start];
}

- (void)requestCompleted:(FBRequestConnection *)connection result:(id)result error:(NSError *)error {
    
    if (self.requestConnection && connection != self.requestConnection) return;
    
    self.requestConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (error) {
        // error contains details about why the request failed
        NSLog(@"%@", error.localizedDescription);
    } else {
        NSArray *data = [(NSDictionary *)result objectForKey:@"data"];
        NSArray *fql_result_set;
        
        if ([data count] >= 3) {
            // Cover
            fql_result_set = [[data objectAtIndex:0] objectForKey:@"fql_result_set"];
            if ([fql_result_set count] > 0) {
                [self.cover setImageWithURL:[[fql_result_set objectAtIndex:0] objectForKey:@"src_big"]];
            }
            
            // Picture
            fql_result_set = [[data objectAtIndex:1] objectForKey:@"fql_result_set"];
            if ([fql_result_set count] > 0) {
                [self.picture setImageWithURL:[[fql_result_set objectAtIndex:0] objectForKey:@"url"]];
            } else {
                [self.picture setImageWithURL:pic_square];
            }
            
            // Likes
            fql_result_set = [[data objectAtIndex:2] objectForKey:@"fql_result_set"];
            if ([fql_result_set count] > 0) {
                for (int i = 0; i < [fql_result_set count]; i++) {
                    UIImageView *pageImage = [[UIImageView alloc] initWithFrame:CGRectMake(50.0f * i, 0.0f, 50.0f, 50.0f)];
                    [pageImage setImageWithURL:[[fql_result_set objectAtIndex:i] objectForKey:@"pic_square"]];
                    [self.pagesLikes addSubview:pageImage];
                }
            }
            [self.pagesLikes scrollRectToVisible:CGRectMake(0.0, 0.0, 0.0, 0.0) animated:NO];
            [self.pagesLikes setContentSize:CGSizeMake(50.0f * [fql_result_set count], 50.0f)];
        }
    }
}

#pragma mark - Info Container Methods

- (void) loadInfoContainerWithDictionary:(NSDictionary *)dictionary {

    // OwnerID
    [self setCurrentOwnerID:[dictionary objectForKey:@"uid"]];
    [self sendRequests];
    
    // Name
    [self.name setText:[dictionary objectForKey:@"name"]];

    // Cover
    if (![[dictionary objectForKey:@"pic_cover"] isEqual:[NSNull null]]) {
        [self.cover setImageWithURL:[[dictionary objectForKey:@"pic_cover"] objectForKey:@"source"]];
    }
    
    // Picture
    [self.picture setImageWithURL:[dictionary objectForKey:@"pic_square"]];
    
    // Likes
    for (UIView *view in self.pagesLikes.subviews) {
        [view removeFromSuperview];
    }
    
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager downloadWithURL:[dictionary objectForKey:@"pic_big"] options:0 progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0.0, 0.0, self.picture.frame.size.width, self.picture.frame.size.height));
//        image = [UIImage imageWithCGImage:imageRef];
//        CGImageRelease(imageRef);
//        [self.picture setImage:image];
//    }];
}

@end
