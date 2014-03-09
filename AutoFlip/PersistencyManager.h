//
//  PersistencyManager.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentation.h"

@interface PersistencyManager : NSObject

@property (strong, nonatomic) NSMutableArray *presentations;

- (NSMutableArray *)getPresentations;

- (void)savePresentations;
- (void)addPresentation:(Presentation *)presentation atIndex:(int)index;
- (void)setPresentation:(Presentation *)presentation atIndex:(int)index;
- (void)deletePresentationAtIndex:(int)index;

@end
