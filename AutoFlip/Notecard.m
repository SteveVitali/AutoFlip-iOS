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

- (id)initWithEmptyCard {
    
    self = [super init];
    if (self) {
        self.bullets = [[NSMutableArray alloc] init];
        self.text = [[NSString alloc] init];
    }
    return self;
}

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
        
        self.bullets = [[NSMutableArray alloc] init];
        for(int i=0; i<6; i++) {
            [self.bullets addObject:[self getRandomBullet]];
        }
        
        self.text = [self getTextInBulletFormat];
    }
    return self;
}

- (NSString *)getRandomBullet {
    
    NSString *rand = @"";
    for(int i=0; i<6; i++) {
        rand = [rand stringByAppendingFormat:@"%@ ",[self getRandomWord]];
    }
    return rand;
}

- (NSString *)getRandomWord {
    
    int randomIndex = arc4random() % 13 + 1 ;
    switch (randomIndex) {
        case 1: return @"2 Chainz";
        case 2: return @"Hamlet";
        case 3: return @"wow";
        case 4: return @"Alas";
        case 5: return @"and";
        case 6: return @"but";
        case 7: return @"such";
        case 8: return @"very";
        case 9: return @"much";
        case 10:return @"wow";
        case 11:return @"flip";
        case 12:return @"auto";
        case 13:return @"poor Yorrick";
    }
    return @"wow such never actually executed code";
}

- (NSString *)getTextInBulletFormat {
    
    for (int i=0; i<[self.bullets count]; i++) {
        [self.bullets setObject:[NSString stringWithFormat:@"\u2022 %@\n",
                                 [self.bullets objectAtIndex:i]] atIndexedSubscript:i];
    }
    return [self.bullets componentsJoinedByString:@""];
}

- (NSString *)getTextFromBulletFormat {
    
    NSString *text = [NSString stringWithString:[self text]];
    
    NSCharacterSet *charactersToRemove = [[ NSCharacterSet alphanumericCharacterSet ] invertedSet ];
    
    NSString *newText =
              [[text componentsSeparatedByCharactersInSet:charactersToRemove ]
                                        componentsJoinedByString:@" " ];
    
    return newText;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bullets forKey:@"bullets"];
    [aCoder encodeObject:self.text forKey:@"text"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self)
    {
        _bullets = [aDecoder decodeObjectForKey:@"bullets"];
        _text  = [aDecoder decodeObjectForKey:@"text"];
    }
    return self;
}

@end
