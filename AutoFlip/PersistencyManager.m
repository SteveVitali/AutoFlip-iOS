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
        
        //self.presentations = nil; //uncomment to reset the stored values on iphone sim
        if (self.presentations == nil) {
            NSLog(@"Nil shit nigga wassup");
            //we need some motherfuckin' presentations
            //going to initialize dummy presentation for now
            self.presentations = [[NSMutableArray alloc] init];
            for(int i=0; i<24; i++) {
                [self addPresentation:[[Presentation alloc] initWithRandomNotes:i+1] atIndex:i];
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
    
    if (self.presentations.count > index) {
        [self.presentations insertObject:presentation atIndex:index];
        presentation.arrayIndex = [NSNumber numberWithInt:index];
        // Shift every existing presentation up by one
        for (int i=index+1; i<self.presentations.count; i++) {
            Presentation *presentation = [self.presentations objectAtIndex:i];
            presentation.arrayIndex = [NSNumber numberWithInteger:([presentation.arrayIndex integerValue]+1)];
        }
    } else {
        [self.presentations addObject:presentation];
        presentation.arrayIndex = [NSNumber numberWithInt:self.presentations.count-1];
    }
}

- (void)setPresentation:(Presentation *)presentation atIndex:(int)index {
    
    if (self.presentations.count > index) {
        [self.presentations setObject:presentation atIndexedSubscript:index];
        presentation.arrayIndex = [NSNumber numberWithInt:index];
    } else {
        [self.presentations addObject:presentation];
        presentation.arrayIndex = [NSNumber numberWithInt:self.presentations.count-1];
    }
}

- (void)deletePresentationAtIndex:(int)index {
    
    for (int i=index+1; i<self.presentations.count; i++) {
        Presentation *presentation = [self.presentations objectAtIndex:i];
        presentation.arrayIndex = [NSNumber numberWithInteger:([presentation.arrayIndex integerValue]-1)];
    }
    [self.presentations removeObjectAtIndex:index];
}

@end
