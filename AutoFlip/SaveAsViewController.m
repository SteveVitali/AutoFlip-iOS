//
//  SaveAsViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 1/4/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "SaveAsViewController.h"
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "FUIButton.h"
#import "UIFont+FlatUI.h"
#import "FUITextField.h"
#import "UIBarButtonItem+FlatUI.h"
#import "LibraryAPI.h"

@interface SaveAsViewController ()

@end

@implementation SaveAsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPlaceholderTextTitle:(NSString *)title description:(NSString *)description {
    
    self = [super init];
    if (self) {
        self.titleText = title;
        self.descriptionText = description;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.titleField setPlaceholder:@"Title"];
    [self.descriptionField setPlaceholder:@"Brief description..."];
    
    [self.titleField setDelegate:self];
    [self.descriptionField setDelegate:self];

    [self.titleField setText:self.titleText];
    [self.descriptionField setText:self.descriptionText];

    [self.titleField becomeFirstResponder];
    
    [[[LibraryAPI sharedInstance] designManager] styleFlatUIButton:self.saveButton];
    [[[LibraryAPI sharedInstance] designManager] styleFlatUIButton:self.cancelButton];
    
    self.view.backgroundColor = [UIColor cloudsColor];
}
     
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField selectAll:self];    
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self.delegate cancelSave:self];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [self.delegate saveDataAs:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
