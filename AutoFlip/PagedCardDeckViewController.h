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

@property (strong, nonatomic) Presentation *presentation;
@property (nonatomic) NSInteger cardIndex;
@property (strong, nonatomic) DesignManager *designManager;

@property (nonatomic) BOOL hasNextCard;
@property (nonatomic) BOOL hasPreviousCard;

@property (strong, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet UINavigationItem *presentationTitleNavBar;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *progressBarBarButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextCard;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousCard;

@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;

- (IBAction)nextCard:(id)sender;
- (IBAction)previousCard:(id)sender;
- (void)reloadCard;
- (void)resizeCardsBasedOnVisibleSpace;
- (void)resizeTextToFitScreen;

- (void)hideShowNavigation;

// Stuff added for new paged scroll view
@property (strong, nonatomic) UITextView *currentTextView; // use to be "textArea"; took out of Storyboard
@property (strong, nonatomic) UIScrollView *pagedScrollView;
@property (strong, nonatomic) NSMutableArray *textViews;

@end
