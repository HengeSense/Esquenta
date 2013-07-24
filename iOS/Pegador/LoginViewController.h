//
//  LoginViewController.h
//  Pegador
//
//  Created by Pedro Góes on 25/05/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *infoText;

- (IBAction)buttonRequestClickHandler:(id)sender;

@end
