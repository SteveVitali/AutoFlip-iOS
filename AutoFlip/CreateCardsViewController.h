//
//  CreateCardsViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDeckViewController.h"

@interface CreateCardsViewController : CardDeckViewController <UITextViewDelegate>

- (IBAction)saveCards:(id)sender;

@end
