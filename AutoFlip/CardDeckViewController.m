//
//  CardDeckViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "CardDeckViewController.h"
#import "Presentation.h"

@interface CardDeckViewController () {
    //etc.
}

@end

@implementation CardDeckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cardIndex = 0;
        self.presentation = [[Presentation alloc] init];
        self.textArea.text = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self reloadCard];
}

- (void)reloadCard {
    self.textArea.text = [[self.presentation.notecards objectAtIndex:self.cardIndex] text];
    if (self.cardIndex == 0) {
        [self.previousCard setEnabled:false];
    } else {
        [self.previousCard setEnabled:true];
    }
}

- (IBAction)nextCard:(id)sender
{
    if (self.cardIndex < [self.presentation.notecards count] - 1) {
        self.cardIndex++;
        [self reloadCard];
    }
}

- (IBAction)previousCard:(id)sender
{
    if (self.cardIndex != 0) {
        self.cardIndex--;
        [self reloadCard];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end