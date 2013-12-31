//
//  Presentation.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "Presentation.h"
#import "Notecard.h"

@implementation Presentation

- (id)initWithNotes:(NSMutableArray *)notecards {
    self = [super init];
    if (self) {
        //nonsense
    }
    return self;
}

- (id)initWithRandomNotes:(int)num {
    self = [super init];
    if (self) {
        self.notecards = [NSMutableArray arrayWithArray:
                            @[
                              [[Notecard alloc] initWithRandomBullets],
                              [[Notecard alloc] initWithRandomBullets],
                              [[Notecard alloc] initWithRandomBullets],
                             ]
                          ];
        self.title = [NSString stringWithFormat:@"Title of presentation %d", num];
        
        int randomIndex = arc4random() % 10 + 1 ;
        switch (randomIndex) {
            case 1:
            case 2:
            case 3:
            case 4:
                self.type = @"drive";
                break;
            case 5:
            case 6:
            case 7:
            case 8:
                self.type = @"dropbox";
                break;
            case 9:
            case 10:
                self.type = @"custom";
                break;
        }
    }
    return self;
}

@end
