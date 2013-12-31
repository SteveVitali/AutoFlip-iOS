//
//  Presentation.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Presentation : NSObject

@property NSMutableArray *notecards;
@property NSString *title;
@property NSString *type;

- (id) initWithNotes:(NSMutableArray *)notecards;
- (id)initWithRandomNotes:(int)num;

@end
