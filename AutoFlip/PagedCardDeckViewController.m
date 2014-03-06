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
    [self.navigationController.navigationBar setHidden:NO];
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
    
    [self initPagedScrollView];
    
    [self reloadCard];
}

- (void)initPagedScrollView {
    
    // Init the scroll view
    self.pagedScrollView = [[UIScrollView alloc] init];
    self.pagedScrollView.pagingEnabled = YES;
    self.pagedScrollView.delegate = self;
    self.pagedScrollView.showsHorizontalScrollIndicator = NO;
    // add to main view
    [self.view addSubview:self.pagedScrollView];
    
    // This resizes the pagedScrollView and the textViews based on which navbars are showing
    [self resizeCardsBasedOnVisibleSpace];
    
    // Init the textviews that will occupy the scroll view pages
    self.textViews = [[NSMutableArray alloc] init];
    for (int i=0; i<[self.presentation.notecards count]; i++) {
        
        // Kind of bad practice, since the "textArea" textview is initialized from the storyboard.
        UITextView *textView = [[UITextView alloc] init];
        textView.backgroundColor =[self.designManager cardDeckTextViewBGColor];
        textView.textColor = [self.designManager textAreaFontColor];
        textView.editable = NO;
        textView.text = ((Notecard *)[self.presentation.notecards objectAtIndex:i]).text;
        [textView.layer setCornerRadius:2.0f];
        [textView.layer setMasksToBounds:YES];
        [self.textViews addObject:textView];
    }
    for(UIView *view in self.textViews) {
        [self.pagedScrollView addSubview:view];
    }
    
    CGSize pageSize = self.pagedScrollView.frame.size;
    
    self.pagedScrollView.contentSize = CGSizeMake(pageSize.width * [self.textViews count], pageSize.height);
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
    
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    [self.navigationController setToolbarHidden:!self.navigationController.toolbarHidden animated:YES];
    
    [self reloadCard];
}

- (void)resizeCardsBasedOnVisibleSpace {
    
    float basePadding   = 8;
    float topVerticalPadding    = self.navigationController.navigationBar.frame.size.height;
    float bottomVerticalPadding = self.navigationController.toolbar.frame.size.height;
    
    if (self.navigationController.navigationBarHidden) {
        topVerticalPadding = 0;
    }
    if (self.navigationController.toolbarHidden) {
        bottomVerticalPadding = 0;
    }
    
    self.pagedScrollView.frame = CGRectMake(0,
                                            topVerticalPadding,
                                            self.view.frame.size.width,
                                            self.view.frame.size.height - bottomVerticalPadding - topVerticalPadding);
    
    NSUInteger page = 0;
    for(UIView *view in self.textViews) {
        
        view.frame = CGRectMake(self.pagedScrollView.frame.size.width * page++ + basePadding,
                                self.pagedScrollView.frame.origin.y + basePadding,
                                self.pagedScrollView.frame.size.width - 2 * basePadding,
                                self.pagedScrollView.frame.size.height - 4 * basePadding);
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;//YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.pagedScrollView.delegate = nil;
}

- (void)didRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.progressBar.frame = CGRectMake(-128, 0, 256, 0);
    } else {
        self.progressBar.frame = CGRectMake(-64, 0, 128, 0);
    }
}

- (void)reloadCard {
    
    NSLog(@"notecards count: %d",self.presentation.notecards.count);
    NSLog(@"card index: %d",self.cardIndex);
    
    self.currentTextView = [self.textViews objectAtIndex:self.cardIndex];
    
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
    
    [self resizeCardsBasedOnVisibleSpace];
    [self resizeTextToFitScreen];
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
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end