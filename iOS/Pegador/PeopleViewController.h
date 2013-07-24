//
//  PeopleViewController.h
//  Pegador
//
//  Created by Pedro Góes on 25/05/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBRequestConnection;

#import "UIScrollViewInfinitePagingController.h"
#import "UIInfoContainerViewController.h"

@interface PeopleViewController : UIInfoContainerViewController <UIInfoContainerViewControllerDataSource>

@property (strong, nonatomic) NSString *currentOwnerID;
@property (strong, nonatomic) FBRequestConnection *requestConnection;

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UIImageView *cover;
@property (nonatomic, strong) IBOutlet UIImageView *picture;
@property (nonatomic, strong) IBOutlet UIScrollView *pagesLikes;
@end