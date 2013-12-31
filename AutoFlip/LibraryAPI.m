//
//  Library.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "LibraryAPI.h"
#import "PersistencyManager.h"

@interface LibraryAPI() {
    PersistencyManager *persistencyManager;
}
@end

@implementation LibraryAPI


- (id)init
{
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc] init];
    }
    return self;
}

+ (LibraryAPI *)sharedInstance
{
    // 1
    static LibraryAPI *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

- (NSMutableArray *)getPresentations {
    return [persistencyManager getPresentations];
}

@end
