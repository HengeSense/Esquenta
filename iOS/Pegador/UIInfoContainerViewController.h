//
//  UIInfoContainerViewController.h
//  NegocioPresente
//
//  Created by Pedro Góes on 22/11/12.
//  Copyright (c) 2012 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol UIInfoContainerViewControllerDataSource <NSObject>

- (void) loadInfoContainerWithDictionary:(NSDictionary *)dictionary;

@end

@interface UIInfoContainerViewController : UIViewController

@end
