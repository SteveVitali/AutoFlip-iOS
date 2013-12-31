//
//  Notecard.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "Notecard.h"

@interface Notecard () {
    
}
@end

@implementation Notecard

- (id)initWithBullets:(NSMutableArray *)bullets {
    self = [super init];
    if (self) {
        //nonsense;
    }
    return self;
}

- (id)initWithRandomBullets {
    self = [super init];
    if (self) {
        self.bullets = [NSMutableArray arrayWithArray:
                        @[
                          @"Bullet 1",
                          @"Bullet 2",
                          @"Bullet 3",
                          @"Bullet 4",
                          @"Bullet 5",
                          @"Bullet 6",
                         ]
                    ];
        self.text = [self.bullets componentsJoinedByString:@"\n"];
    }
    return self;
}

@end
