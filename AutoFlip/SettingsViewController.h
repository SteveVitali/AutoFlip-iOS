//
//  SettingsViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 2/7/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionDelegate.h"

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *toggleRecognitionSwitch;
@property (weak, nonatomic) IBOutlet UIButton *calibrateButton;

// For transparent modal view controller
@property (nonatomic, strong) TransitionDelegate *transitionController;

- (IBAction)showMenu;

- (IBAction)didPressCalibrate:(id)sender;
- (IBAction)didToggleRecognitionSwitch:(id)sender;
@end