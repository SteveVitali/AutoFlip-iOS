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
    NSInteger cardIndex;
    //etc.
}

@end

@implementation PresentationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cardIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self reloadSlide];
}

- (void)reloadSlide {
    self.textArea.text = [[self.presentation.notecards objectAtIndex:cardIndex] text];
   // self.title = [NSString ]
}

- (IBAction)nextSlide:(id)sender
{
    cardIndex++;
    [self reloadSlide];
}

- (IBAction)previousSlide:(id)sender
{
    cardIndex--;
    [self reloadSlide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
