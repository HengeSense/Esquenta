//
//  LoginViewController.m
//  Pegador
//
//  Created by Pedro Góes on 25/05/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "PartyPickerViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Login", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.infoText.text = NSLocalizedString(@"To make your party awesome, hit Facebook to start Ice Breaker!", nil);
    
    // Para começar a ver quem está nessa festa, entre logo no seu Facebook!
    
    [self checkSessionAndAnimate:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Facebook Methods

- (void)buttonRequestClickHandler:(id)sender {
    [self loginSession];
}


- (void)loginSession {
    if (!FBSession.activeSession.isOpen) {
        
        NSArray *permissions = [NSArray arrayWithObjects:@"email", @"user_events", @"friends_likes", nil];
        
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          
                                          [self checkSessionAndAnimate:YES];
                                          
                                          // if login fails for any reason, we alert
                                          if (error) {
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                              message:error.localizedDescription
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                              // if otherwise we check to see if the session is open, an alternative to
                                              // to the FB_ISSESSIONOPENWITHSTATE helper-macro would be to check the isOpen
                                              // property of the session object; the macros are useful, however, for more
                                              // detailed state checking for FBSession objects
                                          }
                                      }];
    }
}

- (void)checkSessionAndAnimate:(BOOL)animate {
    if (FBSession.activeSession.isOpen) {
        PartyPickerViewController *ppvc = [[PartyPickerViewController alloc] initWithNibName:@"PartyPickerViewController" bundle:nil];
        [self.navigationController pushViewController:ppvc animated:animate];
    }
}


@end
