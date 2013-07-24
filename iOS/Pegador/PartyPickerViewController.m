//
//  PartyPickerViewController.m
//  Pegador
//
//  Created by Pedro Góes on 25/05/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "PartyPickerViewController.h"
#import "EventViewController.h"
#import "NUIRenderer.h"

@interface PartyPickerViewController () {
    NSArray *events;
    NSString *sex;
}

@end

@implementation PartyPickerViewController

@synthesize requestConnection = _requestConnection;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Party", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", nil) style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonWasPressed:)]];
    [NUIRenderer renderBarButtonItem:self.navigationItem.rightBarButtonItem];
    
    [self sendRequests];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self.requestConnection cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Methods

- (void)logoutButtonWasPressed:(id)sender {
    if (FBSession.activeSession.isOpen) {
        [FBSession.activeSession closeAndClearTokenInformation];
        [self.navigationController popToRootViewControllerAnimated:YES];
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
    
//    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"/me/events"];
    
    NSString *query1 = @"SELECT eid, name, pic_big FROM event WHERE eid IN (SELECT eid FROM event_member WHERE uid=me()) AND (end_time > now() OR end_time = 'null') ORDER BY start_time";
    NSString *query2 = @"SELECT sex FROM user WHERE uid=me()";
//    NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:query2, @"q", nil];
    
    NSString* fql = [NSString stringWithFormat: @"{\"queryID\":\"%@\",\"queryName\":\"%@\"}", query1, query2];
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
        
        if ([data count] >= 2) {
            events = [[data objectAtIndex:0] objectForKey:@"fql_result_set"];
            sex = [[[[data objectAtIndex:1] objectForKey:@"fql_result_set"] objectAtIndex:0] objectForKey:@"sex"];
            sex = ([sex isEqualToString:@"female"]) ? @"male" : @"female";
            
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [events count];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CustomCellIdentifier];
    }
    
    NSDictionary *event = [events objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[event objectForKey:@"name"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventViewController *evc = [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
    [evc setTitle:[[events objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [evc setCurrentEventID:[[events objectAtIndex:indexPath.row] objectForKey:@"eid"]];
    [evc setCurrentSexPreference:sex];
    [self.navigationController pushViewController:evc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
