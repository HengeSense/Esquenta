//
//  UIScrollViewInfinitePagingController.m
//  NegocioPresente
//
//  Created by Pedro Góes on 22/11/12.
//  Copyright (c) 2012 Pedro Góes. All rights reserved.
//

#import "UIScrollViewInfinitePagingController.h"

@interface UIScrollViewInfinitePagingController ()

@property (strong, nonatomic) NSMutableArray *infoContainerControllers;
@property (strong, nonatomic) NSArray *infoContainerControllersData;
@property (nonatomic) NSUInteger centeredBadgeIndex;
@property (nonatomic) NSUInteger numberOfInfoContainersPerWidth;
@property (nonatomic) NSUInteger numberOfInfoContainersPerHeight;

- (void)loadPageWithId:(NSUInteger)index onPage:(NSUInteger)page;

@end

@implementation UIScrollViewInfinitePagingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    _infoContainerControllers = [NSMutableArray array];
    _centeredBadgeIndex = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Methods

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
//        _scrollView.frame = CGRectMake(0.0, 0.0, 320.0, 416.0);
    } else {
//        _scrollView.frame = CGRectMake(0.0, 0.0, 480.0, 256.0);
    }
}


- (void) setScrollViewWithLoadingMode:(BOOL)loading {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = loading;
}

- (void) provideAnObjectForInfinitePagingContent:(NSArray *)content {
    // Save the content object
    _infoContainerControllersData = content;
}

- (void) prepareViewControllerForInfinitePaging:(UIViewController<UIInfoContainerViewControllerDataSource> *)controller withIndex:(NSUInteger)index {
    // Then we add it as a child inside our viewControler
    [self addChildViewController:controller];
    
    // Set the new frame (so we can scroll it)
    [controller.view setFrame:CGRectMake(self.view.frame.size.width * index + controller.view.frame.origin.x, controller.view.frame.origin.y, controller.view.frame.size.width, controller.view.frame.size.height)];
    
    // Select our object with data
    NSDictionary *infoContainerData;
    
    if ([_infoContainerControllersData count] > index) {
        infoContainerData = [_infoContainerControllersData objectAtIndex:index];
    } else {
        infoContainerData = [NSDictionary dictionary];
    }
    
    // Set the data
    [controller loadInfoContainerWithDictionary:infoContainerData];
    
    // Add the subview
    [self.scrollView addSubview:controller.view];
    
    // Append it to our array
    [_infoContainerControllers addObject:controller];
    
    // Notify the parent
    [controller didMoveToParentViewController:self];
}

- (void) prepareScrollViewContentForInfinitePaging {
    // Remove loading mode
    [self setScrollViewWithLoadingMode:NO];
    // Adjust scrollView frame to fit all the infoContainers
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * [_infoContainerControllers count],  self.scrollView.frame.size.height)];
}

- (void)loadPageWithId:(NSUInteger)index onPage:(NSUInteger)page {
    if ([_infoContainerControllersData count] > index) {
        [[_infoContainerControllers objectAtIndex:page] loadInfoContainerWithDictionary:[_infoContainerControllersData objectAtIndex:index]];
    }
}

#pragma mark - UIScrollViewDelegate Protocol

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > scrollView.frame.size.width) {
		// We are moving forward. Load the current doc data on the first page.
		[self loadPageWithId:_centeredBadgeIndex onPage:0];
        
		// Add one to the currentIndex or reset to 0 if we have reached the end.
		_centeredBadgeIndex = (_centeredBadgeIndex >= [_infoContainerControllersData count] - 1) ? 0 : _centeredBadgeIndex + 1;
		[self loadPageWithId:_centeredBadgeIndex onPage:1];
        
		// Load content on the last page. This is either from the next item in the array
		// or the first if we have reached the end.
		NSUInteger nextIndex = (_centeredBadgeIndex >= [_infoContainerControllersData count] - 1) ? 0 : _centeredBadgeIndex + 1;
		[self loadPageWithId:nextIndex onPage:2];
        
	} else if (scrollView.contentOffset.x < scrollView.frame.size.width) {
		// We are moving backward. Load the current doc data on the last page.
		[self loadPageWithId:_centeredBadgeIndex onPage:2];
        
		// Subtract one from the currentIndex or go to the end if we have reached the beginning.
		_centeredBadgeIndex = (_centeredBadgeIndex == 0) ? [_infoContainerControllersData count] - 1 : _centeredBadgeIndex - 1;
		[self loadPageWithId:_centeredBadgeIndex onPage:1];
        
		// Load content on the first page. This is either from the prev item in the array
		// or the last if we have reached the beginning.
		NSUInteger prevIndex = (_centeredBadgeIndex == 0) ? [_infoContainerControllersData count] - 1 : _centeredBadgeIndex - 1;
		[self loadPageWithId:prevIndex onPage:0];
	}
    
	// Reset offset back to middle page
    CGRect frame = self.scrollView.frame;
	[scrollView scrollRectToVisible:CGRectMake(frame.size.width, 0.0, frame.size.width, frame.size.height) animated:NO];
}

@end
