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

+ (LibraryAPI *)sharedInstance;

- (NSMutableArray *)getPresentations;

@end
