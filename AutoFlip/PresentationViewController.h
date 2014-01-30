//
//  PresentationViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Presentation.h"
#import "CardDeckViewController.h"
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsEventsObserver.h>

@interface PresentationViewController : CardDeckViewController <OpenEarsEventsObserverDelegate>

@property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;

@property NSMutableSet *slideWords;
@property NSMutableSet *spokenWords;
@property NSMutableSet *allWords;

@end
