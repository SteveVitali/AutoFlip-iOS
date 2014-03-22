//
//  AboutViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 2/8/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "AboutViewController.h"
#import "RESideMenu.h"
#import "LibraryAPI.h"
#import "MBProgressHUD.h"
#import <iAd/iAd.h>

@interface AboutViewController () {
    
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[[[LibraryAPI sharedInstance] designManager] viewControllerBGColor]];
    
    [self.navigationController setToolbarHidden:YES];
    
//    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + self.view.frame.size.width/2  - 64/2,
//                                                                                  self.view.frame.origin.y + self.view.frame.size.height/2 - 64/2,
//                                                                                  64, 64)];
//    [self.view addSubview:activityIndicator];
//    [activityIndicator startAnimating];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://auto-flip.herokuapp.com/"]]];
    
    self.webView.delegate = self;
  
//    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedDown)];
//    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
//    swipeDown.delegate = self;
//    
//    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedUp)];
//    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
//    swipeUp.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    
    self.canDisplayBannerAds = [[[NSUserDefaults standardUserDefaults] objectForKey:@"showAds"] boolValue];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

- (void)tapScreen {
    
    NSLog(@"tapped...");
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:self.navigationController.navigationBarHidden];
}

- (void)swipedDown {
    
    NSLog(@"swiping down...");
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)swipedUp {
    
    NSLog(@"swiping up...");
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

// For the sidebar
- (IBAction)showMenu {
    
    [self.sideMenuViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
