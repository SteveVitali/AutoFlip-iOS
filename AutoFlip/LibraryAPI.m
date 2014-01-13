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

@interface LibraryAPI() {
    
    PersistencyManager *persistencyManager;
}
@end

@implementation LibraryAPI

- (id)init {
    
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc] init];
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

- (void)customLog:(NSString *)log {
    
    self.debuggingResults = [self.debuggingResults stringByAppendingString:[NSString stringWithFormat:@"%@ \n", log]];
    NSLog(@"%@",log);
}

@end
