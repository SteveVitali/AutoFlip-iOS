//
//  PersistencyManager.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "PersistencyManager.h"
#import "Presentation.h"

@interface PersistencyManager() {
    NSMutableArray *presentations;
}
@end

@implementation PersistencyManager

- (id)init {
    self = [super init];
    if (self) {
        NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/presentations.bin"]];
        presentations = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        //if (presentations == nil) {
            NSLog(@"Nil shit nigga wassup");
            //we need some motherfuckin' presentations
            //going to initialize dummy presentation for now
            presentations = [[NSMutableArray alloc] init];
            for(int i=0; i<10; i++) {
                [presentations addObject:[[Presentation alloc] initWithRandomNotes:i+1]];
            }
            [self savePresentations];
      //  }
    }
    return self;
}

- (NSMutableArray *)getPresentations {
    return presentations;
}

- (void)savePresentations {
        NSString *filename = [NSHomeDirectory() stringByAppendingString:@"/Documents/presentations.bin"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:presentations];
        [data writeToFile:filename atomically:YES];
}

@end
