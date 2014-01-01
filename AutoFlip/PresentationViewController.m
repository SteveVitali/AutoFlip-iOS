//
//  PresentationViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "PresentationViewController.h"
#import "Presentation.h"

@interface PresentationViewController () {
    //etc.
}

@end

@implementation PresentationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)reloadCard {
    [super reloadCard];
    //etc.
}

- (IBAction)nextCard:(id)sender
{
    [super nextCard:sender];
}

- (IBAction)previousCard:(id)sender
{
    [super previousCard:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
