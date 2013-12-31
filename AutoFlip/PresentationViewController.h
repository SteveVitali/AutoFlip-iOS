//
//  PresentationViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Presentation.h"

@interface PresentationViewController : UIViewController

@property Presentation *presentation;

@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UINavigationItem *slideTitle;

- (IBAction)nextSlide:(id)sender;
- (IBAction)previousSlide:(id)sender;

@end
