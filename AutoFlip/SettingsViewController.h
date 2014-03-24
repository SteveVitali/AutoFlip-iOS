//
//  SettingsViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 2/7/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionDelegate.h"
#import <StoreKit/StoreKit.h>

@interface SettingsViewController : UITableViewController <SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UISwitch *toggleRecognitionSwitch;
@property (weak, nonatomic) IBOutlet UIButton *calibrateButton;
@property (weak, nonatomic) IBOutlet UIButton *resetDefaultsButton;
@property (weak, nonatomic) IBOutlet UIButton *removeAdsButton;
@property (weak, nonatomic) IBOutlet UIButton *restorePurchasesButton;

// For transparent modal view controller
@property (nonatomic, strong) TransitionDelegate *transitionController;

- (IBAction)showMenu;

- (IBAction)didPressCalibrate:(id)sender;
- (IBAction)didToggleRecognitionSwitch:(id)sender;
- (IBAction)didPressResetDefaults:(id)sender;

- (IBAction)didPressRemoveAds:(id)sender;
- (IBAction)didPressRestorePurchases:(id)sender;
@end