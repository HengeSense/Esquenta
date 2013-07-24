//
//  ColorReaperViewController.m
//  Pegador
//
//  Created by Pedro Góes on 15/05/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "ColorReaperViewController.h"
#import "MPFoldTransition.h"
#import "MPFlipTransition.h"
#import "ThemeColors.h"
#import "UIColor+Expanded.h"
#import <QuartzCore/QuartzCore.h>

@interface ColorReaperViewController () {
    
    NSInteger repeater;
    
    NSMutableArray *views;
    NSMutableArray *viewsCache;
    NSArray *colors;
    NSTimer *looper;
}

@end

@implementation ColorReaperViewController

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

    [self allocColors];
    [self allocViews];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Create our looper
    looper = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(flipRandomView) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [looper invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Allocation

- (void)allocViews {
    
    // Alloc the desired array
    views = [NSMutableArray arrayWithCapacity:8];
    
    // And populate it
    for (int i = 0; i < 8; i++) {
        UIView *view = [self getOptionViewForIndex:i];
        [self.view addSubview:view];
        [views addObject:view];
    }
    
    // Alloc the desired array
    viewsCache = [NSMutableArray arrayWithCapacity:8];
    
    // And populate it
    for (int i = 0; i < 8; i++) {
        UIView *view = [self getOptionViewForIndex:i];
        [viewsCache addObject:view];
    }
}

- (void)allocColors {

    colors = @[[UIColor colorWithHexString:@"#C63D0F"],
               [UIColor colorWithHexString:@"#3B3738"],
               [UIColor colorWithHexString:@"#FDF3E7"],
               [UIColor colorWithHexString:@"#7E8F7C"],
               ];
    
    colors = @[[UIColor colorWithHexString:@"#7D1935"],
               [UIColor colorWithHexString:@"#4A96AD"],
               [UIColor colorWithHexString:@"#F5F3EE"],
               [UIColor colorWithHexString:@"#FFFFFF"],
               ];
    
    colors = @[[UIColor colorWithHexString:@"#E44424"],
               [UIColor colorWithHexString:@"#67BCDB"],
               [UIColor colorWithHexString:@"#A2AB58"],
               [UIColor colorWithHexString:@"#FFFFFF"],
               ];
}

#pragma mark - Configuration

- (UIView *)getOptionViewForIndex:(NSUInteger)index {
	
	UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height * index / 8.0f, self.view.frame.size.width, self.view.frame.size.height / 8.0f)];
	container.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    container.backgroundColor = [colors objectAtIndex:(arc4random() % [colors count])];
    container.tag = index;
    container.layer.shadowOpacity = 1.0;
    container.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    container.layer.shadowColor = [[[ThemeColors sharedInstance] shadowColor] CGColor];
    container.layer.shadowRadius = 5.0;
//    [container.layer setBorderColor:[[UIColor colorWithWhite:0.85 alpha:1] CGColor]];
//    [container.layer setBorderWidth:2];
    
    // Separator
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0f, self.view.frame.size.width, 1.0f)];
    [separator setBackgroundColor:[[ThemeColors sharedInstance] shadowColor]];
    separator.layer.shadowOpacity = 1.0;
    separator.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    separator.layer.shadowColor = [[[ThemeColors sharedInstance] borderColor] CGColor];
    separator.layer.shadowRadius = 1.0;
    [container addSubview:separator];
	
	return container;
}

- (void)flipRandomView {
    
    // Increment the overall count
    repeater++;
    
    if (repeater < 40) {
        
        int random = arc4random() % [views count];
        [self flipViewAtIndex:random];
        
    } else {
        
        [looper invalidate];
        repeater = 0;
    }
}

- (void)flipViewAtIndex:(NSInteger)step {
    
    if (step + 1 < [views count]) {
        
        // Load some views
        UIView *originalView = [views objectAtIndex:step];
        [originalView setBackgroundColor:[colors objectAtIndex:(arc4random() % [colors count])]];
        UIView *cacheView = [viewsCache objectAtIndex:step];
        [cacheView setBackgroundColor:[colors objectAtIndex:(arc4random() % [colors count])]];
        
        // Animate the transition
        [MPFoldTransition transitionFromView:originalView toView:cacheView duration:[MPFoldTransition defaultDuration] style:MPFoldStyleCubic transitionAction:MPTransitionActionAddRemove
                                  completion:^(BOOL finished) {
                                      [views replaceObjectAtIndex:step withObject:cacheView];
                                      [viewsCache replaceObjectAtIndex:step withObject:originalView];
                                  }
         ];
    }
}

@end
