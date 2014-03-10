//
//  TestCreateCardsViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 1/29/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveAsViewController.h"
#import "CardDeckViewController.h"
#import "PagedCardDeckViewController.h"

@interface CreateCardsViewController : CardDeckViewController <UITextViewDelegate,
                                                                    UIScrollViewDelegate,
                                                                    UIAlertViewDelegate,
                                                                    SaveAsViewControllerDelegate,
                                                                    UIGestureRecognizerDelegate>

// Technically this is redundant, since these values are stored by sinstance variable presentation
// But I need to pass the values from the UITextFields through the segue somehow
@property (strong, nonatomic) NSString *presentationTitle;
@property (strong, nonatomic) NSString *presentationDescription;

- (void)saveDataAs:(SaveAsViewController *)saveAsViewController;
- (void)cancelSave:(SaveAsViewController *)saveasViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)saveCards:(id)sender;
- (IBAction)didPressActionsButton:(id)sender;

- (IBAction)nextCard:(id)sender;
- (IBAction)previousCard:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@end
