//
//  AppDelegate.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "AppDelegate.h"
//#import <DropboxSDK/DropboxSDK.h>
#import <DBChooser/DBChooser.h>
#import "LibraryAPI.h"
#import "UIColor+FlatUI.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    // Register NSUserDefaults
    NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithBool:YES], @"speechRecognition",
                                          [NSNumber numberWithFloat:0.5f], @"pointOneConstant",
                                          nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
    return YES;
}

#pragma mark - Dropbox Drop-ins Chooser hook

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation
{
    
    if ([[DBChooser defaultChooser] handleOpenURL:url]) {
        // This was a Chooser response and handleOpenURL automatically ran the
        // completion block
        return YES;
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 #pragma mark - Dropbox Core API hook
 
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
 
 NSLog(@"application handleopenurl bullshit");
 if ([[DBSession sharedSession] handleOpenURL:url]) {
 if ([[DBSession sharedSession] isLinked]) {
 NSLog(@"App linked successfully!");
 // At this point you can start making API calls
 } else { NSLog(@"not linked?");}
 return YES;
 } else {NSLog(@"def not linked");}
 // Add whatever other url handling code your app requires here
 return NO;
 }
 
 */

@end
