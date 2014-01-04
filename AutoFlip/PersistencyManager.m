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

}
@end

@implementation PersistencyManager

- (id)init {
    
    self = [super init];
    if (self) {
        
        NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory()
                              stringByAppendingString:@"/Documents/presentations.bin"]];
        self.presentations = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        //presentations = nil; //uncomment to reset the stored values on iphone sim
        if (self.presentations == nil) {
            NSLog(@"Nil shit nigga wassup");
            //we need some motherfuckin' presentations
            //going to initialize dummy presentation for now
            self.presentations = [[NSMutableArray alloc] init];
            for(int i=0; i<24; i++) {
                [self.presentations addObject:[[Presentation alloc] initWithRandomNotes:i+1]];
            }
            [self savePresentations];
        }
        //NSLog(@"%@",[[[[presentations objectAtIndex:0] notecards] objectAtIndex:0] text]);
    }
    return self;
}

- (NSMutableArray *)getPresentations {
    
    return self.presentations;
}

- (void)savePresentations {
    
        NSString *filename =
                    [NSHomeDirectory() stringByAppendingString:@"/Documents/presentations.bin"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.presentations];
        [data writeToFile:filename atomically:YES];
}

- (void)addPresentation:(Presentation *)presentation atIndex:(int)index {
    
    if (self.presentations.count >= index) {
        [self.presentations insertObject:presentation atIndex:index];
    } else {
        [self.presentations addObject:presentation];
    }
}

- (void)deletePresentationAtIndex:(int)index {
    
    [self.presentations removeObjectAtIndex:index];
}

@end
