//
//  Library.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentation.h"

@interface LibraryAPI : NSObject

@property NSString *debuggingResults;

+ (LibraryAPI *)sharedInstance;

- (NSMutableArray *)getPresentations;
- (NSString *)appendBulletToString:(NSString *)str;
- (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale;

- (void)customLog:(NSString *)log;

- (void)savePresentations;
- (void)addPresentation:(Presentation *)presentation atIndex:(int)index;
- (void)deletePresentationAtIndex:(int)index;
- (void)setPresentation:(Presentation *)presentation atIndex:(int)index;

@end
