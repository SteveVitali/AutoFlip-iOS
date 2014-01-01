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
- (NSString *)getTextInBulletFormat;
@end

@implementation Notecard

- (id)initWithBullets:(NSMutableArray *)bullets {
    self = [super init];
    if (self) {
        //nonsense;
    }
    return self;
}

- (id)initWithEmptyCard {
    self = [super init];
    if (self) {
        self.bullets = [[NSMutableArray alloc] init];
        self.text = [[NSString alloc] init];
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
        self.text = [self getTextInBulletFormat];
    }
    return self;
}

- (NSString *)getTextInBulletFormat {
    for (int i=0; i<[self.bullets count]; i++) {
        [self.bullets setObject:[NSString stringWithFormat:@"\u2022 %@\n", [self.bullets objectAtIndex:i]] atIndexedSubscript:i];
    }
    return [self.bullets componentsJoinedByString:@""];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bullets forKey:@"bullets"];
    [aCoder encodeObject:self.text forKey:@"text"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _bullets = [aDecoder decodeObjectForKey:@"bullets"];
        _text  = [aDecoder decodeObjectForKey:@"text"];
    }
    return self;
}

@end
