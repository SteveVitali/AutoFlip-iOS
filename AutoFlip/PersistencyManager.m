//
//  PersistencyManager.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "PersistencyManager.h"
#import "Presentation.h"
#import "LibraryAPI.h"

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
//            for(int i=0; i<24; i++) {
//                [self addPresentation:[[Presentation alloc] initWithRandomNotes:i+1] atIndex:i];
//            }
            
            [self addPresentation:[self getAutoFlipTourPresentation] atIndex:0];
            
            [self savePresentations];
        }
        //NSLog(@"%@",[[[[presentations objectAtIndex:0] notecards] objectAtIndex:0] text]);
    }
    return self;
}

- (Presentation *)getAutoFlipTourPresentation {
    
    Presentation *tour = [Presentation getPresentationFromText:@"Tap the \"Present\" option to present a deck of notecards.\nBy default, AutoFlip will use speech recognition to flip your cards automatically.\nIn the settings page, you can calibrate the speech recognition, or turn it off altogether.\n\nTap the \"Edit\" option to open the card editor.\nThere you can edit, insert, or delete cards from the deck.\nDouble tap to hide the keyboard, and swipe left or right to navigate between cards.\n\nYou can export your cards to Google Drive or Dropbox from the card editor.\nYou can also import existing presentations or text files from Drive or Dropbox, and AutoFlip will automatically convert them to decks of notecards for you." name:@"AutoFlip Tour" description:@"Learn how to use AutoFlip" service:@"custom"];
    
    // Hardcoding becuase w/o it it will save twice.
    tour.arrayIndex = [NSNumber numberWithInt:1];
    
    return tour;
}

- (Presentation *)getTestPresentation {
    
    Presentation *test = [Presentation getPresentationFromText:@"" name:@"Test Presentation" description:@"Empty Test Presentation" service:@"custom"];
    return test;
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
    Presentation *presentationToDelete = [self.presentations objectAtIndex:index];
    
    // First delete the unzipped .pptx folder that was saved when the object was imported,
    // Then delete the presentation object.
    if ([presentationToDelete.type isEqualToString:@"drive"] || [presentationToDelete.type isEqualToString:@"dropbox"]) {
        
        [[LibraryAPI sharedInstance] deleteFileAtPath:presentationToDelete.pathToUnzippedPPTX];
    }
    [self.presentations removeObjectAtIndex:index];
}

@end
