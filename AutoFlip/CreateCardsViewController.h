//
//  CreateCardsViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDeckViewController.h"

@interface CreateCardsViewController : CardDeckViewController <UITextViewDelegate, UIScrollViewDelegate>

// Technically this is redundant, since these values are stored by superclass instance variable presentation
// But I need to pass the values from the UITextFields through the segue somehow, and idk how else to do it then this.
@property NSString *presentationTitle;
@property NSString *presentationDescription;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)saveCards:(id)sender;

@end
