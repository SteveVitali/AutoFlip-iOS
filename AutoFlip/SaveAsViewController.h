//
//  SaveAsViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 1/4/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveAsViewControllerDelegate;

@interface SaveAsViewController : UIViewController

@property (weak) id<SaveAsViewControllerDelegate> delegate;

@property NSString *titleText;
@property NSString *descriptionText;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

- (id)initWithPlaceholderTextTitle:(NSString *)title description:(NSString *)description;

@end

@protocol SaveAsViewControllerDelegate <NSObject>

@required

- (void)saveDataAs:(SaveAsViewController *)saveAsViewController;
- (void)cancelSave:(SaveAsViewController *)saveasViewController;

@end