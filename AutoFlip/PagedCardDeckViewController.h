//
//  PagedCardDeckViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 2/9/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "REMenu.h"
#import "Presentation.h"
#import "DesignManager.h"

@interface PagedCardDeckViewController : UIViewController <UIScrollViewDelegate>

@property Presentation *presentation;
@property NSInteger cardIndex;
@property DesignManager *designManager;

@property BOOL hasNextCard;
@property BOOL hasPreviousCard;

@property (strong, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet UINavigationItem *presentationTitleNavBar;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *progressBarBarButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextCard;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousCard;

@property UIPinchGestureRecognizer *pinchRecognizer;

- (IBAction)nextCard:(id)sender;
- (IBAction)previousCard:(id)sender;
- (void)reloadCard;
- (void)resizeTextToFitScreen;

- (void)hideShowNavigation;

// Stuff added for new paged scroll view
@property UITextView *currentTextView; // use to be "textArea"; took out of Storyboard
@property UIScrollView *pagedScrollView;
@property NSMutableArray *textViews;

@end
