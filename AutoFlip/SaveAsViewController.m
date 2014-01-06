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
    self.titleField.placeholder = self.titleText;
    self.descriptionField.placeholder = self.descriptionText;
    NSLog(@"%@",self.descriptionText);
    
    self.cancelButton.buttonColor = [UIColor turquoiseColor];
    self.cancelButton.shadowColor = [UIColor greenSeaColor];
    self.cancelButton.shadowHeight = 3.0f;
    self.cancelButton.cornerRadius = 6.0f;
    self.cancelButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.cancelButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    self.saveButton.buttonColor = [UIColor turquoiseColor];
    self.saveButton.shadowColor = [UIColor greenSeaColor];
    self.saveButton.shadowHeight = 3.0f;
    self.saveButton.cornerRadius = 6.0f;
    self.saveButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.saveButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
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
