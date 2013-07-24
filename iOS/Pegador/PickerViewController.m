//
//  PickerViewController.m
//  Pegador
//
//  Created by Pedro Góes on 01/05/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import "PickerViewController.h"
#import "MPFoldTransition.h"
#import "MPFlipTransition.h"
#import <QuartzCore/QuartzCore.h>

@interface PickerViewController () {
    
    @private
    NSArray *instructions;
    NSArray *options;
    NSArray *optionsColor;
    NSInteger currentStep;
}

@end

@implementation PickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Create all the instructions
        
        instructions = @[@"Catando quem?", @"Você é?"];
        options = @[@[@"Homem?", @"Mulher?"], @[@"Homem?", @"Mulher?"]];
        currentStep = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // View
    self.view.backgroundColor = [[ThemeColors sharedInstance] backgroundColor];
    
    // Set the default state for the controller
    [self moveToNextStep];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)getOptionViewForIndex:(NSUInteger)index {
	
	UIView *container = [[UIView alloc] initWithFrame:self.optionWrapper.frame];
	container.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    container.backgroundColor = [[ThemeColors sharedInstance] tabBarBackgroundColor];
    container.tag = index;
    container.layer.shadowOpacity = 1.0;
    container.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    container.layer.shadowColor = [[[ThemeColors sharedInstance] shadowColor] CGColor];
    container.layer.shadowRadius = 5.0;
//    [container.layer setBorderColor:[[UIColor colorWithWhite:0.85 alpha:1] CGColor]];
//    [container.layer setBorderWidth:2];
    
    
    for (int i=0; i < 2; i++) {
    	// Control
        UIControl *option = [[UIControl alloc] initWithFrame:CGRectMake(0.0, 80.0f * i, self.view.frame.size.width, 80.0f)];
        [option setBackgroundColor:[[ThemeColors sharedInstance] optionBackgroundColorAtIndex:i]];
        [option addTarget:self action:@selector(moveToNextStep) forControlEvents:UIControlEventTouchUpInside];
        
        // Separator
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 79.0f, self.view.frame.size.width, 1.0f)];
        [separator setBackgroundColor:[[ThemeColors sharedInstance] shadowColor]];
        separator.layer.shadowOpacity = 1.0;
        separator.layer.shadowOffset = CGSizeMake(1.0, -1.0);
        separator.layer.shadowColor = [[[ThemeColors sharedInstance] borderColor] CGColor];
        separator.layer.shadowRadius = 1.0;
    
        // Label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0f, self.view.frame.size.width, 80.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [label setFont:[UIFont fontWithName:@"Thonburi" size:28.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[[ThemeColors sharedInstance] textColor]];
        [label setText:[[options objectAtIndex:index] objectAtIndex:i]];
        
        [option addSubview:separator];
        [option addSubview:label];
        [container addSubview:option];
    }
	
	return container;
}

- (UIView *)getInstructionViewForIndex:(NSUInteger)index {
    
    UIView *container = [[UIView alloc] initWithFrame:self.instructionView.frame];
	container.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    container.backgroundColor = [[ThemeColors sharedInstance] backgroundColor];
    container.tag = index;
    
    UILabel *label = [[UILabel alloc] initWithFrame:container.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [label setFont:[UIFont fontWithName:@"Thonburi" size:28.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[[ThemeColors sharedInstance] textColor]];
    [label setText:[instructions objectAtIndex:index]];
    
    [container addSubview:label];
    
    return container;
}

- (void)moveToNextStep {
    
    // Increment the current step
    if (currentStep == 1) currentStep = 0;
    
    if (currentStep + 1 < [instructions count]) {

        ++currentStep;
        
        // Load some views
        UIView *optionView = [self getOptionViewForIndex:currentStep];
        UIView *instructionView = [self getInstructionViewForIndex:currentStep];
        
        // Animate the transition
        [MPFoldTransition transitionFromView:self.optionWrapper toView:optionView duration: (currentStep == 0) ? 0.0f : [MPFoldTransition defaultDuration] style:MPFoldStyleCubic transitionAction:MPTransitionActionAddRemove
                                  completion:^(BOOL finished) {
                                      self.optionWrapper = optionView;
                                    }
         ];
        
        [MPFlipTransition transitionFromView:self.instructionView toView:instructionView duration: (currentStep == 0) ? 0.0f : [MPFlipTransition defaultDuration] style:MPFlipStyleDefault transitionAction:MPTransitionActionAddRemove
                                  completion:^(BOOL finished) {
                                      self.instructionView = instructionView;
                                  }
         ];
    }
}

@end
