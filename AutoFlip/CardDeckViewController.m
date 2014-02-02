//
//  CardDeckViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "CardDeckViewController.h"
#import "Presentation.h"
#import "UIColor+FlatUI.h"
#import "LibraryAPI.h"
#import "DesignManager.h"
#import "UITextView+AutoResizeFont.h"

@interface CardDeckViewController () {

}

@end

@implementation CardDeckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.designManager = [[LibraryAPI sharedInstance] designManager];
    
	// Do any additional setup after loading the view.
    self.cardIndex = 0;
    [self reloadCard];
    [self.navigationController.navigationBar setHidden:NO];
   // self.view.backgroundColor = [UIColor cloudsColor];
    
    UIView *customView = [[UIView alloc] init];
    UIProgressView *progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    self.progressBar = progressBar;
    
    [customView addSubview:self.progressBar];
    self.progressBarBarButton.customView = customView;
    
    [progressBar setFrame:CGRectMake(-64, 0, 128, 0)];
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    [self.view addGestureRecognizer:swipeRightGestureRecognizer];
    
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.textArea addGestureRecognizer:self.pinchRecognizer];
    
//    [self.navigationController.navigationBar setTranslucent:NO];
//    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific

    [self resizeTextToFitScreen];
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer {
    
    NSLog(@"Pinch: Scale: %f Velocity: %f", recognizer.scale, recognizer.velocity);
 
    // Commenting this out because not really necessary right now.
    /*
    CGFloat pointSize = [self.textArea.font pointSize];
    NSString *fontName = [self.textArea.font fontName];
    
    pointSize = ((recognizer.velocity > 0) ? 1 : -1) * 1 + pointSize;
    
    //if (pointSize < 13) pointSize = 13;
    //if (pointSize < 42) pointSize = 42;
    
    self.textArea.font = [UIFont fontWithName:fontName size:pointSize];
     */
}

- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    
    if (self.hasNextCard) {
        [self nextCard:nil];
    }
}

- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    
    if (self.hasPreviousCard) {
        [self previousCard:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.progressBar.frame = CGRectMake(-128, 0, 256, 0);
    } else {
        self.progressBar.frame = CGRectMake(-64, 0, 128, 0);
    }
}


- (void)reloadCard {
    
    NSLog(@"notecards count: %d",self.presentation.notecards.count);
    NSLog(@"card index: %d",self.cardIndex);
    
    self.textArea.text = [[self.presentation.notecards objectAtIndex:self.cardIndex] text];
    
    if (self.cardIndex == 0) {
        [self.previousCard setEnabled:NO];
        self.hasPreviousCard = NO;
    } else {
        [self.previousCard setEnabled:YES];
        self.hasPreviousCard = YES;
    }
    if (self.cardIndex == self.presentation.notecards.count - 1) {
        [self.nextCard setEnabled:NO];
        self.hasNextCard = NO;
    } else {
        [self.nextCard setEnabled:YES];
        self.hasNextCard = YES;
    }
    
    [self updateProgressBar];
    
    [self resizeTextToFitScreen];
}

- (void)resizeTextToFitScreen {
    
    // Default padY just because
    float padY = 32;
    
    if (!self.navigationController.toolbarHidden) {
        padY += self.navigationController.toolbar.frame.size.height;
    }
    if (!self.navigationController.navigationBarHidden) {
        padY += self.navigationController.navigationBar.frame.size.height;
    }
    
    [self.textArea sizeFontToFitText:self.textArea.text
                         minFontSize:[[[LibraryAPI sharedInstance] designManager] minNotecardFontSize].floatValue
                         maxFontSize:[[[LibraryAPI sharedInstance] designManager] maxNotecardFontSize].floatValue
                     verticalPadding:padY];
}

- (void)updateProgressBar {
    
    float progress = (float)(self.cardIndex+1)/[self.presentation.notecards count];
    [self.progressBar setProgress:progress];
}

- (IBAction)nextCard:(id)sender {
    
    self.cardIndex++;
    [self reloadCard];
}

- (IBAction)previousCard:(id)sender {
    
    self.cardIndex--;
    [self reloadCard];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end