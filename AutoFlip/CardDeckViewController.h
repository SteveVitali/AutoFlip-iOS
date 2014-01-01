//
//  CardDeckViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "Presentation.h"

@interface CardDeckViewController : UIViewController

@property Presentation *presentation;

@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UINavigationItem *slideTitle;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *previousCard;
@property (weak, nonatomic) IBOutlet UIButton *nextCard;

@property NSInteger cardIndex;

- (IBAction)nextCard:(id)sender;
- (IBAction)previousCard:(id)sender;
- (void)reloadCard;

@end