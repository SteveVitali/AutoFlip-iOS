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
    
    [manager setPrimaryAccentColor:[UIColor wetAsphaltColor]];
    // Button colors
    [manager setButtonBGColor:[manager primaryAccentColor]];
    [manager setButtonShadowColor:[UIColor midnightBlueColor]];
    [manager setButtonTextColorNormal:[UIColor cloudsColor]];
    [manager setButtonTextColorHighlighted:[UIColor cloudsColor]];
    [manager setButtonShadowHeight:2.0f];
    [manager setButtonCornerRadius:4.0f];
    [manager setButtonFontSize:16];
    // Screen backgrounds
    [manager setViewControllerBGColor:[UIColor cloudsColor]];
    // TableView colors for ChooseCardsViewController
    [manager setTableViewBGColor:[[UIColor cloudsColor] colorWithAlphaComponent:.6]];
    [manager setTableCellBGColorNormal:[UIColor clearColor]];
    [manager setTableCellBGColorSelected:[[UIColor concreteColor] colorWithAlphaComponent:0.6]];
    [manager setTableCellSeparatorColor:[UIColor concreteColor]];
    [manager setTableCellTextColor:[UIColor blackColor]];
    [manager setTableCellDetailColor:[UIColor asbestosColor]];
    // CardDeckViewController styling
    [manager setTextAreaFontColor:[UIColor blackColor]];
    [manager setCardDeckTextViewBGColor:[[UIColor cloudsColor] colorWithAlphaComponent:0.6]];
    [manager setCardDeckViewControllerBGColor:[UIColor cloudsColor]];
    // Text sizes
    [manager setMinNotecardFontSize:[NSNumber numberWithInt:16]];
    [manager setMaxNotecardFontSize:[NSNumber numberWithInt:36]];
    // Other
    [manager setKxMenuTextColor:[UIColor cloudsColor]];
    //[manager setNavigationBarTintColor:[UIColor cloudsColor]];
}

- (void)customLog:(NSString *)log {
    
    self.debuggingResults = [self.debuggingResults stringByAppendingString:[NSString stringWithFormat:@"%@ \n", log]];
    NSLog(@"%@",log);
}

-(NSArray *)listFilesAtPath:(NSString *)path {
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    for (int count = 0; count < (int)[directoryContent count]; count++) {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

- (void)deleteFileAtPath:(NSString *)path {
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (success) {
        NSLog(@"File removed successfully: %@",path);
    } else {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

@end
