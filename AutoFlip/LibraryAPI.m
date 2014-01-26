//
//  Library.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//
//
//ABOUT THIS CLASS:
//It's mostly utility methods for things
//It uses the "Facade" design pattern to encapsulate
//the functionality of PersistencyManager/etc. but from
//the outside it looks like it's all coming from LibraryAPI

#import "LibraryAPI.h"
#import "PersistencyManager.h"
#import "DesignManager.h"
#import "UIColor+FlatUI.h"

@interface LibraryAPI() {
    
    PersistencyManager *persistencyManager;
}
@end

@implementation LibraryAPI

- (id)init {
    
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc] init];
        self.designManager = [[DesignManager alloc] init];
        
        [self setDesignManagerConstantsFromManager:self.designManager];
        
        self.debuggingResults = [[NSString alloc] init];
        self.debuggingResults = @"Debugging Results:\n";
    }
    return self;
}

+ (LibraryAPI *)sharedInstance {
    
    static LibraryAPI *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

- (NSMutableArray *)getPresentations {
    
    return [persistencyManager getPresentations];
}

- (NSString *)appendBulletToString:(NSString *)str {
    
    return [NSString stringWithFormat:@"\u2022 %@\n", str];
}

- (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale {
    
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:(image.scale * scale)
                         orientation:(image.imageOrientation)];
}

#pragma mark - PersistencyManager methods

- (void)savePresentations {
    
    [persistencyManager savePresentations];
}

- (void)addPresentation:(Presentation *)presentation atIndex:(int)index {
    
    [persistencyManager addPresentation:presentation atIndex:index];
}

- (void)setPresentation:(Presentation *)presentation atIndex:(int)index {
    
    [persistencyManager setPresentation:presentation atIndex:index];
}

- (void)deletePresentationAtIndex:(int)index {
    
    [persistencyManager deletePresentationAtIndex:index];
}

#pragma mark - DesignManager methods
// Color/Size constants for all the views in the application.
- (void)setDesignManagerConstantsFromManager:(DesignManager *)manager {
    
    // Button colors
    [manager setButtonBGColor:[UIColor turquoiseColor]];
    [manager setButtonTextColorNormal:[UIColor cloudsColor]];
    [manager setButtonTextColorHighlighted:[UIColor cloudsColor]];
    [manager setButtonShadowColor:[UIColor greenSeaColor]];
    // Screen backgrounds
    [manager setHomeScreenBGColor:[UIColor cloudsColor]];
    // TableView colors for ChooseCardsViewController
    [manager setTableCellBGColorNormal:[UIColor cloudsColor]];
    [manager setTableCellBGColorSelected:[UIColor grayColor]];
    [manager setTableCellSeparatorColor:[UIColor cloudsColor]];
    [manager setTableCellTextColor:[UIColor blackColor]];
    [manager setTableCellDetailColor:[UIColor grayColor]];
    // Text sizes
    [manager setEditorTextSize:[NSNumber numberWithInt:14]];
    [manager setPresentTextSize:[NSNumber numberWithInt:18]];
}


- (void)customLog:(NSString *)log {
    
    self.debuggingResults = [self.debuggingResults stringByAppendingString:[NSString stringWithFormat:@"%@ \n", log]];
    NSLog(@"%@",log);
}

@end
