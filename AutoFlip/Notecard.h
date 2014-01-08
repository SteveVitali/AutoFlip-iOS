//
//  Notecard.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notecard : NSObject <NSCoding>

@property NSMutableArray *bullets;
@property NSString *text;

- (id)initWithBullets:(NSMutableArray *)bullets;
- (id)initWithEmptyCard;
- (id)initWithRandomBullets;

- (NSString *)getTextFromBulletFormat;

@end
