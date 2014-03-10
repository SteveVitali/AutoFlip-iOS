//
//  Presentation.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSZipArchive.h"
#import "Notecard.h"

@interface Presentation : NSObject <NSCoding, SSZipArchiveDelegate>

@property (strong, nonatomic) NSMutableArray *notecards;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSNumber *arrayIndex;

@property (strong, nonatomic) NSString *pathToUnzippedPPTX;

- (void)insertCardAtIndex:(NSInteger)index;
- (void)addCard;

- (NSSet *)getAllWordsInPresentation;
+ (NSSet *)getAllWordsFromCard:(Notecard *)card;

- (id) initWithNotes:(NSMutableArray *)notecards;
- (id)initWithRandomNotes:(int)num;

- (NSString *)getPresentationInTextFormat;
+ (Presentation *)getPresentationFromPPTXData:(NSData *)data withName:(NSString *)name fromService:(NSString *)service;
+ (Presentation *)getPresentationFromTextFileData:(NSData *)data andName:(NSString *)name fromService:(NSString *)service;

@end
