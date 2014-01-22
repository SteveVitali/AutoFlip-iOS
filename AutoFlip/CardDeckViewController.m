//
//  CardDeckViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "CardDeckViewController.h"
#import "Presentation.h"
#import "UIColor+FlatUI.h"

@interface CardDeckViewController () {
    
}

@end

@implementation CardDeckViewController

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
    self.cardIndex = 0;
    [self reloadCard];
    [self.navigationController.navigationBar setHidden:NO];
   // self.view.backgroundColor = [UIColor cloudsColor];
    
    UIView *customView = [[UIView alloc] init];
    UIProgressView *progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    self.progressBar = progressBar;
    
    [customView addSubview:self.progressBar];
    self.progressBarBarButton.customView = customView;
    
    [progressBar setFrame:CGRectMake(-64, 0, 128, 0)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.progressBar.frame = CGRectMake(-128, 0, 256, 0);
    } else {
        self.progressBar.frame = CGRectMake(-64, 0, 128, 0);
    }
}

- (void)reloadCard {
    
    self.textArea.text = [[self.presentation.notecards objectAtIndex:self.cardIndex] text];
    if (self.cardIndex == 0) {
        [self.previousCard setEnabled:false];
    } else {
        [self.previousCard setEnabled:true];
    }
    [self updateProgressBar];
}

- (void)updateProgressBar {
    
    float progress = (float)(self.cardIndex+1)/[self.presentation.notecards count];
    //NSLog(@"%f",progress);
    //NSLog(@"notecards count: %d",self.presentation.notecards.count);
    [self.progressBar setProgress:progress];
}

- (IBAction)nextCard:(id)sender {
    
    if (self.cardIndex < [self.presentation.notecards count] - 1) {
        self.cardIndex++;
        [self reloadCard];
    }
}

- (IBAction)previousCard:(id)sender {
    
    if (self.cardIndex != 0) {
        self.cardIndex--;
        [self reloadCard];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end