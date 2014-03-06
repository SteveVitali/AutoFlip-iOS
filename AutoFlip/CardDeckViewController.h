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
#import "DesignManager.h"

@interface CardDeckViewController : UIViewController

@property (strong, nonatomic) Presentation *presentation;
@property (nonatomic) NSInteger cardIndex;
@property (strong, nonatomic) DesignManager *designManager;

@property (nonatomic) BOOL hasNextCard;
@property (nonatomic) BOOL hasPreviousCard;

@property (strong, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UINavigationItem *presentationTitleNavBar;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *progressBarBarButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextCard;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousCard;

@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;

- (IBAction)nextCard:(id)sender;
- (IBAction)previousCard:(id)sender;
- (void)reloadCard;
- (void)resizeTextToFitScreen;

@end
