//
//  Presentation.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSZipArchive.h"

@interface Presentation : NSObject <NSCoding, SSZipArchiveDelegate>

@property NSMutableArray *notecards;
@property NSString *title;
@property NSString *description;
@property NSString *type;

@property NSNumber *arrayIndex;

@property NSString *pathToUnzippedPPTX;

- (void)insertCardAtIndex:(NSInteger)index;
- (void)addCard;

- (NSSet *)getAllWordsInPresentation;

- (id) initWithNotes:(NSMutableArray *)notecards;
- (id)initWithRandomNotes:(int)num;

- (NSString *)getPresentationInTextFormat;
+ (Presentation *)getPresentationFromPPTXData:(NSData *)data withName:(NSString *)name fromService:(NSString *)service;
+ (Presentation *)getPresentationFromTextFileData:(NSData *)data andName:(NSString *)name fromService:(NSString *)service;

@end
