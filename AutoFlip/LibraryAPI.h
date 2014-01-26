//
//  Library.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentation.h"
#import "DesignManager.h"

@interface LibraryAPI : NSObject

// Technically I should have this as a hidden property and just implement its methods in
// the LibraryAPI.m file, but in this case that would kind of be a waste of time, so I'm
// just going to make it a property here for convenience.
// The only difference is that now we have to run [[[LibraryAPI sharedInstance] designManager] someMethod:];
// instead of [[LibraryAPI sharedInstance] someDesignManagerMethod:];
@property DesignManager *designManager;
- (void)setDesignManagerConstantsFromManager:(DesignManager *)manager;

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

- (void)deleteFileAtPath:(NSString *)path;
- (NSArray *)listFilesAtPath:(NSString *)path;

@end
