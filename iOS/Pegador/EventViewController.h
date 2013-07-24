//
//  EventViewController.h
//  Pegador
//
//  Created by Pedro Góes on 25/05/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollViewInfinitePagingController.h"

@class FBRequestConnection;

@interface EventViewController : UIScrollViewInfinitePagingController <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSString *currentSexPreference;
@property (strong, nonatomic) NSString *currentEventID;
@property (strong, nonatomic) FBRequestConnection *requestConnection;

@end
