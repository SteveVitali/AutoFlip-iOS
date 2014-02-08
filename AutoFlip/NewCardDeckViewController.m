//
//  NewCardDeckViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 1/1/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "NewCardDeckViewController.h"
#import "CreateCardsViewController.h"
#import "DrEditUtilities.h"
#import "LibraryAPI.h"

@interface NewCardDeckViewController ()

@end

@implementation NewCardDeckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.titleFieldLabel setHidden:YES];
    [self.titleFieldLabel setText:@"* Title field cannot be blank"];
    [self.titleFieldLabel setTextColor:[UIColor redColor]];

    [self.descriptionFieldLabel setText:@"* Description field cannot be blank"];
    [self.descriptionFieldLabel setTextColor:[UIColor redColor]];
    [self.descriptionFieldLabel setHidden:YES];

    [self.navigationController.navigationBar setHidden:NO];
    self.view.backgroundColor = [UIColor cloudsColor];
    
    [self.view setBackgroundColor:[[[LibraryAPI sharedInstance] designManager] viewControllerBGColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    
    [self.titleField becomeFirstResponder];
}

- (IBAction)didPressCreate:(id)sender {
    
    if (self.titleField.text.length > 0) {
        [self performSegueWithIdentifier:@"createCards" sender:self];
    } else {
        [self.titleFieldLabel setHidden:NO];
        //[DrEditUtilities showErrorMessageWithTitle:@"Error" message:@"Title field cannot be empty." delegate:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"createCards"]) {
        CreateCardsViewController *controller =
                                   (CreateCardsViewController *)[segue destinationViewController];
        controller.presentationTitle = [self.titleField text];
        controller.presentationDescription = [self.descriptionField text];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
