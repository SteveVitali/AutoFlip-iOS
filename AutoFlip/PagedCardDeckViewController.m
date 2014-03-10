//
//  PagedCardDeckViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 2/9/14.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "PagedCardDeckViewController.h"
#import "Presentation.h"
#import "UIColor+FlatUI.h"
#import "LibraryAPI.h"
#import "DesignManager.h"
#import "UITextView+AutoResizeFont.h"
#import "Notecard.h"
#import "NotecardTextView.h"
#import <QuartzCore/QuartzCore.h>

@interface PagedCardDeckViewController () {
    
}

@end

@implementation PagedCardDeckViewController

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
    // self.view.backgroundColor = [UIColor cloudsColor];
    
    UIView *customView = [[UIView alloc] init];
    UIProgressView *progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    self.progressBar = progressBar;
    
    [customView addSubview:self.progressBar];
    self.progressBarBarButton.customView = customView;
    
    [progressBar setFrame:CGRectMake(-64, 0, 128, 0)];
    
    //    [self.navigationController.navigationBar setTranslucent:NO];
    //
    //    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //        self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
    
    //[self.view setBackgroundColor:[[[LibraryAPI sharedInstance] designManager] viewControllerBGColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue1"]]];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.pagedScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)initPagedScrollView {
    
    // Init the scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.pagedScrollView = scrollView;
    
    // add to main view
    [self.view addSubview:self.pagedScrollView];
    
    self.pagedScrollView.pagingEnabled = YES;
    self.pagedScrollView.delegate = self;
    self.pagedScrollView.showsHorizontalScrollIndicator = NO;

    //self.pagedScrollView.showsVerticalScrollIndicator = NO;
    
    // Init the textviews that will occupy the scroll view pages
    self.textViews = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[self.presentation.notecards count]; i++) {
        
        // Kind of bad practice, since the "textArea" textview is initialized from the storyboard.
        NotecardTextView *textView = [[NotecardTextView alloc] initWithText:((Notecard *)[self.presentation.notecards objectAtIndex:i]).text];
        [self.textViews addObject:textView];
    }
    
    // This resizes the pagedScrollView and the textViews based on which navbars are showing
    [self resizeCardsBasedOnVisibleSpace];
    
    for(NotecardTextView *view in self.textViews) {
        [self.pagedScrollView addSubview:view];
    }
    
    [self setContentSizeOfPagedScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self initPagedScrollView];
}

- (void)setContentSizeOfPagedScrollView {
    
    CGSize pageSize = self.pagedScrollView.frame.size;
    
    self.pagedScrollView.contentSize = CGSizeMake(pageSize.width * [self.textViews count], pageSize.height);
    
    NSLog(@"just changed scrollview: %f, %f", pageSize.width, pageSize.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    //NSLog(@"page: %d",page);
    if (previousPage != page) {
        previousPage = page;
        /* Page did change */
        self.cardIndex = page;
        [self reloadCard];
    }
}

- (void)hideShowNavigation {
    
    [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    [self.navigationController setToolbarHidden:!self.navigationController.toolbarHidden animated:YES];
    
    //[self reloadCard];
}

// Resize card bounds and card text given the screen's bounds/etc.
- (void)resizeCardsBasedOnVisibleSpace {
    
    float basePadding   = 4;
    
    float topVerticalPadding    = 0;//self.navigationController.navigationBar.frame.size.height;
    float bottomVerticalPadding =  0;//self.navigationController.toolbar.frame.size.height;
    
    // Getting rid of this so cards don't have to be resizes every time navbar is shown.
//    if (self.navigationController.navigationBarHidden) {
//        topVerticalPadding = 0;
//    }
//    if (self.navigationController.toolbarHidden) {
//        bottomVerticalPadding = 0;
//    }
    
    self.pagedScrollView.frame = CGRectMake(0,
                                            topVerticalPadding,
                                            self.view.frame.size.width,
                                            self.view.frame.size.height - bottomVerticalPadding - topVerticalPadding);
    
    NSUInteger page = 0;
    for(NotecardTextView *view in self.textViews) {
        
        view.frame = CGRectMake(self.pagedScrollView.frame.size.width * page++ + basePadding,
                                self.pagedScrollView.frame.origin.y + basePadding,
                                self.pagedScrollView.frame.size.width - 2 * basePadding,
                                self.pagedScrollView.frame.size.height - 2 * basePadding);
        
        // Also resize its text
        [self resizeTextToFitScreenForTextView:view];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.pagedScrollView.delegate = nil;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.progressBar.frame = CGRectMake(-64, 0, 128, 0);
    } else {
        self.progressBar.frame = CGRectMake(-128, 0, 256, 0);
    }
    NSLog(@"First: %f, %f", self.pagedScrollView.frame.size.width, self.pagedScrollView.frame.size.height);

    self.pagedScrollView.frame = self.view.frame;
    
    [self setContentSizeOfPagedScrollView];

    // Fix paging stuff based on orientation
    [self resizeCardsBasedOnVisibleSpace];
    
    CGRect pageRect = [self getPageRectOfPage:self.cardIndex];
    [self.pagedScrollView scrollRectToVisible:pageRect animated:YES];
    [self reloadCard];
    
    NSLog(@"Last %f, %f", self.pagedScrollView.frame.size.width, self.pagedScrollView.frame.size.height);
}

- (void)reloadCard {
    
    NSLog(@"notecards count: %d",self.presentation.notecards.count);
    NSLog(@"card index: %d",self.cardIndex);
    
    NotecardTextView *newTextView = [self.textViews objectAtIndex:self.cardIndex];
    self.currentTextView = newTextView;
    
    self.currentTextView.text = [[self.presentation.notecards objectAtIndex:self.cardIndex] text];
    
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
}

- (void)resizeTextToFitScreen {
    
    // Default padY just because
//    float padY = 32;
//    
//    if (!self.navigationController.toolbarHidden) {
//        padY += self.navigationController.toolbar.frame.size.height;
//    }
//    if (!self.navigationController.navigationBarHidden) {
//        padY += self.navigationController.navigationBar.frame.size.height;
//    }
    
    [self.currentTextView sizeFontToFitText:self.currentTextView.text
                         minFontSize:[[[LibraryAPI sharedInstance] designManager] minNotecardFontSize].floatValue
                         maxFontSize:[[[LibraryAPI sharedInstance] designManager] maxNotecardFontSize].floatValue
                     verticalPadding:0];
}

- (void)resizeTextToFitScreenForTextView:(UITextView *)view {
    
    [view sizeFontToFitText:view.text
                                minFontSize:[[[LibraryAPI sharedInstance] designManager] minNotecardFontSize].floatValue
                                maxFontSize:[[[LibraryAPI sharedInstance] designManager] maxNotecardFontSize].floatValue
                            verticalPadding:0];
}

- (void)updateProgressBar {
    
    float progress = (float)(self.cardIndex+1)/[self.presentation.notecards count];
    [self.progressBar setProgress:progress];
}

- (IBAction)nextCard:(id)sender {
    
    NSLog(@"card indexxx: %d", self.cardIndex);
    self.cardIndex++;
    CGRect pageRect = [self getPageRectOfPage:self.cardIndex];
    [self.pagedScrollView scrollRectToVisible:pageRect animated:YES];
    [self reloadCard];
}

- (IBAction)previousCard:(id)sender {
    
    self.cardIndex--;
    CGRect pageRect = [self getPageRectOfPage:self.cardIndex];
    [self.pagedScrollView scrollRectToVisible:pageRect animated:YES];
    [self reloadCard];
}

- (CGRect)getPageRectOfPage:(NSInteger)page {
    
    CGRect rect;
    CGFloat pageWidth = self.pagedScrollView.frame.size.width;
    
    float x = pageWidth * page;
    float y = 0;
    float width  = pageWidth;
    float height = self.pagedScrollView.frame.size.height;
    
    rect = CGRectMake(x, y, width, height);
    
    return rect;
}

- (void)didReceiveMemoryWarning {
    
    NSLog(@"memory warning?");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end