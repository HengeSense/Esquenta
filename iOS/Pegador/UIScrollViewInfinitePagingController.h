//
//  UIScrollViewInfinitePagingController.h
//  NegocioPresente
//
//  Created by Pedro Góes on 22/11/12.
//  Copyright (c) 2012 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIInfoContainerViewController.h"
#import "AppDelegate.h"

@protocol UIScrollViewControllerInfinitePagingDataSource <NSObject>

@required
- (void)loadInitialInfoContainerControllers;

@optional
- (void)provideObjectInfoContainerControllers;

@end

@interface UIScrollViewInfinitePagingController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (void) setScrollViewWithLoadingMode:(BOOL)loading;
- (void) provideAnObjectForInfinitePagingContent:(NSArray *)content;
- (void) prepareViewControllerForInfinitePaging:(UIViewController<UIInfoContainerViewControllerDataSource> *)controller withIndex:(NSUInteger)index;
- (void) prepareScrollViewContentForInfinitePaging;

@end
