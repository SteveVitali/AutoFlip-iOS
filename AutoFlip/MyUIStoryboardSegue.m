//
//  MyUIStoryboardSegue.m
//  AutoFlip
//
//  Created by Steve John Vitali on 2/8/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "MyUIStoryboardSegue.h"
#import "ChooseCardsViewController.h"
#import "PresentationViewController.h"

@implementation MyUIStoryboardSegue

- (void)perform {
    
    [((ChooseCardsViewController *)self.sourceViewController).navigationController pushViewController:self.destinationViewController animated:YES];
}

@end
