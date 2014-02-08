//
//  AboutViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 2/8/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "AboutViewController.h"
#import "RESideMenu.h"
#import "LibraryAPI.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    [self.view setBackgroundColor:[[[LibraryAPI sharedInstance] designManager] viewControllerBGColor]];
}

// For the sidebar
- (IBAction)showMenu {
    
    [self.sideMenuViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
