//
//  NewCardDeckViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 1/1/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUITextField.h"

@interface NewCardDeckViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet FUITextField *titleField;
@property (weak, nonatomic) IBOutlet FUITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;
@property (weak, nonatomic) IBOutlet UILabel *titleFieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionFieldLabel;

- (IBAction)didPressCreate:(id)sender;

@end
