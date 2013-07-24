//
//  PickerViewController.h
//  Pegador
//
//  Created by Pedro Góes on 01/05/13.
//  Copyright (c) 2013 Pedro Góes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *instructionView;
@property (nonatomic, strong) IBOutlet UIView *optionWrapper;

- (void)moveToNextStep;

@end
