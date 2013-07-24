//
//  EventViewController.m
//  Pegador
//
//  Created by Pedro Góes on 25/05/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "EventViewController.h"
#import "NUIRenderer.h"
#import "PeopleViewController.h"

@interface EventViewController () {
    NSArray *attenders;
}

@end

@implementation EventViewController

@synthesize requestConnection = _requestConnection;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Event", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UISwipeGestureRecognizer *gesture;
    
    // Down
    gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNavigationBar)];
    [gesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [gesture setDelegate:self];
    [gesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:gesture];
    
    // Up
    gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideNavigationBar)];
    [gesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [gesture setDelegate:self];
    [gesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:gesture];
    
    [self sendRequests];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self.requestConnection cancel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

- (void)dealloc {
    [_requestConnection cancel];
}

#pragma mark - User Methods

- (void)showNavigationBar {
    if (self.navigationController.navigationBarHidden) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, self.scrollView.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)hideNavigationBar {
    if (!self.navigationController.navigationBarHidden) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, self.scrollView.frame.size.height)];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Facebook Methods

- (void)sendRequests {
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        [self requestCompleted:connection result:result error:error];
    };
    
//    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:[NSString stringWithFormat:@"/%@/attending?fields=cover,picture.type(large),name", self.currentEventID]];
    
    NSString *query = [NSString stringWithFormat:@"SELECT uid, pic_cover, pic_square, name FROM user WHERE uid IN (SELECT uid FROM event_member WHERE eid = %@ AND rsvp_status != 'declined') AND sex = '%@'", self.currentEventID, self.currentSexPreference];
    NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    
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
        // result is the json response from a successful request
        attenders = [(NSDictionary *)result objectForKey:@"data"];
        [self loadInitialInfoContainerControllers];
    }
}

#pragma mark - UIScrollViewControllerInfinitePaging DataSource

- (void) loadInitialInfoContainerControllers {
    [self setScrollViewWithLoadingMode:YES];
    
    [self provideAnObjectForInfinitePagingContent:attenders];
    
    for (int i=0; i<3; i++) {
        // We alloc the controller
        PeopleViewController *peopleViewController = [[PeopleViewController alloc] init];
        
        [self prepareViewControllerForInfinitePaging:peopleViewController withIndex:i];
    }
    
    [self prepareScrollViewContentForInfinitePaging];
}

#pragma mark - UIScrollView Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}


@end
