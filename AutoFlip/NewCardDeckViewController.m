//
//  NewCardDeckViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 1/1/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "NewCardDeckViewController.h"
#import "CreateCardsViewController.h"

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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"createCards"]) {
        CreateCardsViewController *controller =
                                   (CreateCardsViewController *)[segue destinationViewController];
        controller.presentationTitle = [self.titleField text];
        controller.presentationDescription = [self.descriptionField text];
        NSLog(controller.presentationTitle);
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
