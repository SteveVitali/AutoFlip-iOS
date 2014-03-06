//
//  SaveAsViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 1/4/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "FUIButton.h"
#import "UIFont+FlatUI.h"
#import "FUITextField.h"
#import "UIBarButtonItem+FlatUI.h"

@protocol SaveAsViewControllerDelegate;

@interface SaveAsViewController : UIViewController <UITextFieldDelegate>

@property (weak) id<SaveAsViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *descriptionText;

@property (weak, nonatomic) IBOutlet FUITextField *titleField;
@property (weak, nonatomic) IBOutlet FUITextField *descriptionField;
@property (weak, nonatomic) IBOutlet FUIButton *cancelButton;
@property (weak, nonatomic) IBOutlet FUIButton *saveButton;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

- (id)initWithPlaceholderTextTitle:(NSString *)title description:(NSString *)description;

@end

@protocol SaveAsViewControllerDelegate <NSObject>

@required

- (void)saveDataAs:(SaveAsViewController *)saveAsViewController;
- (void)cancelSave:(SaveAsViewController *)saveasViewController;

@end