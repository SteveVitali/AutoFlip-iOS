//
//  CalibrationViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 2/8/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsEventsObserver.h>

@interface CalibrationViewController : UIViewController <OpenEarsEventsObserverDelegate>

- (IBAction)didPressCancel:(id)sender;
- (IBAction)didPressRecord:(id)sender;

@property BOOL isRecording;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// Speech recognition stuff
@property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;

@property NSMutableSet *spokenWords;
@property NSMutableSet *allWords;

@end
