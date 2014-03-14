//
//  Presentation.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "Presentation.h"
#import "Notecard.h"
#import "LibraryAPI.h"
#import "SSZipArchive.h"
#import "Notecard.h"

@implementation Presentation

- (id)init {
    
    self = [super init];
    if (self) {
        self.notecards = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithNotes:(NSMutableArray *)notecards {
    
    self = [super init];
    if (self) {
        self.notecards = notecards;
    }
    return self;
}

- (id)initWithRandomNotes:(int)num {
    
    self = [super init];
    if (self) {
        
        self.notecards = [[NSMutableArray alloc] init];
        for(int i=0; i<16; i++) {
            [self.notecards addObject:[[Notecard alloc] initWithRandomBullets]];
        }
        
        self.title = [NSString stringWithFormat:@"Title of presentation %d", num];
        self.description = [NSString stringWithFormat:@"Description of presentation %d", num];
        //self.title = [[[self.notecards objectAtIndex:0] bullets] objectAtIndex:0];
        
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

- (void)addCard {
    
    [self.notecards addObject:[[Notecard alloc] initWithEmptyCard]];
}

- (void)insertCardAtIndex:(NSInteger)index {
    
    [self.notecards insertObject:[[Notecard alloc] initWithEmptyCard] atIndex:index];
}

- (NSSet *)getAllWordsInPresentation {
    
    NSString *allText = @"";
    
    for (Notecard *card in self.notecards) {
        allText = [allText stringByAppendingString:card.getTextFromBulletFormat];
    }
    //NSMutableArray *words = [NSMutableArray arrayWithArray:[allText componentsSeparatedByString:@" "]];
    // The below method works much better.
    NSMutableArray *words = [NSMutableArray arrayWithArray:[[allText uppercaseString] componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]]];

    for (int i=0; i<[words count]; i++) {
        // I could shorten this line into several smaller ones, but I think it looks pretty sweet this way.
        // Actually, not even using it anymore, but will leave here anyway.
        //  NSString *word = [[[[[words objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\n" withString:@""] uppercaseString] componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        if ([[words objectAtIndex:i] isEqualToString:@""]) {
            [words removeObjectAtIndex:i];
            i--;
        }
    }
    NSSet *allWords = [NSSet setWithArray:words];
    
    return allWords;
}

// This should be used in the getAllWordsInPresentation
+ (NSSet *)getAllWordsFromCard:(Notecard *)card {
    
    NSString *allText = @"";
    
    allText = [allText stringByAppendingString:card.getTextFromBulletFormat];
    
    NSMutableArray *words = [NSMutableArray arrayWithArray:[[allText uppercaseString] componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]]];
    
    for (int i=0; i<[words count]; i++) {

        if ([[words objectAtIndex:i] isEqualToString:@""]) {
            [words removeObjectAtIndex:i];
            i--;
        }
    }
    NSSet *allWords = [NSSet setWithArray:words];
    
    return allWords;
}

- (NSString *)getPresentationInTextFormat {
    
    NSString *allText = @"";
    
    for (Notecard *card in self.notecards) {
        allText = [allText stringByAppendingString:[NSString stringWithFormat:@"%@\n\n",card.getTextFromBulletFormat]];
    }
    return allText;
}

+ (Presentation *)getPresentationFromText:(NSString *)text name:(NSString *)name description:(NSString *)description service:(NSString *)service {
    
    Presentation *presentation = [[Presentation alloc] init];
    
    NSMutableArray *slides = [NSMutableArray arrayWithArray:[text componentsSeparatedByString:@"\n\n"]];
    
    NSMutableArray *notecards = [[NSMutableArray alloc] init];
    for (NSString *slide in slides) {
        
        NSMutableArray *bullets = [NSMutableArray arrayWithArray:[slide componentsSeparatedByString:@"\n"]];
        
        Notecard *notecard = [[Notecard alloc] initWithBullets:bullets];
        // Fix glitch that causes extra card with just a bullet, a space, and a return character in it
        if (![notecard.text isEqualToString:@"\u2022 \n"]) {
            [notecards addObject:notecard];
        }
    }
    presentation.notecards = notecards;
    presentation.title = name;
    presentation.description = description;
    presentation.type = service;
    
    return presentation;
}

+ (Presentation *)getPresentationFromTextFileData:(NSData *)data andName:(NSString *)name fromService:(NSString *)service {
    
    Presentation *importedPresentation;
    importedPresentation = [[Presentation alloc] init];
    importedPresentation.title = name;
    
    if ( data ) {
        
        NSString *textFileText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSMutableArray *slides = [NSMutableArray arrayWithArray:[textFileText componentsSeparatedByString:@"\n\n"]];

        NSMutableArray *notecards = [[NSMutableArray alloc] init];
        for (NSString *slide in slides) {
            
            NSMutableArray *bullets = [NSMutableArray arrayWithArray:[slide componentsSeparatedByString:@"\n"]];
            Notecard *notecard = [[Notecard alloc] initWithBullets:bullets];
            // Fix glitch that causes extra card with just a bullet, a space, and a return character in it
            if (![notecard.text isEqualToString:@"\u2022 \n"]) {
                [notecards addObject:notecard];
            }
        }
        importedPresentation.notecards = notecards;

        importedPresentation.type = service;
        //Capitalize first letter of "service" type in the description
        importedPresentation.description = [NSString stringWithFormat:@"%@ imported from %@",name,
                                            [service stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                             withString:[[service substringToIndex:1] capitalizedString]]];
    }
    return importedPresentation;
}

+ (Presentation *)getPresentationFromPPTXData:(NSData *)data withName:(NSString *)name fromService:(NSString *)service {
    
    Presentation *importedPresentation;
    importedPresentation = [[Presentation alloc] init];
    importedPresentation.title = name;
    
    // If the file downloaded
    if ( data ) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        // Write dat file to a file whose name is the same as the imported file name
        
        // filePath = ~/DocumentsDirectory/name.zip
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[name stringByAppendingString:@".zip"]];
        // The .zip gets deleted after being unzipped, but not the unzipped folder of the same name (minus .zip extension),
        // so we want to check if a file of the name w/o the extension exists so we don't overwrite it.
        // Never mind the above comment.
        NSString  *directoryPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,name];
        
        // Enforce unique file names on presentations
        int count = 1;
        NSString *originalName = [NSString stringWithString:name];
        while ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
            NSLog(@"duplicate file at: %@",directoryPath);
            name = [originalName stringByAppendingString:[NSString stringWithFormat:@"%d",count]];
            directoryPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,name];
            count++;
        }
        
        NSMutableArray *notecards = [[NSMutableArray alloc] init];
        
        // Write the .zip file
        [data writeToFile:filePath atomically:YES];
        
        NSLog(@"documents directory");
        [[LibraryAPI sharedInstance] listFilesAtPath:documentsDirectory];
        
        NSString *zipPath = filePath;
        
        [SSZipArchive unzipFileAtPath:zipPath toDestination:directoryPath delegate:(id<SSZipArchiveDelegate>)self];
        
        NSString *slidesPath = [directoryPath stringByAppendingPathComponent:@"/ppt/slides"];
        
        NSLog(@"Files in unzipped powerpoint directory");
        [[LibraryAPI sharedInstance] listFilesAtPath:directoryPath];
        NSLog(@"Files in the ppt/slides directory %@ \n", slidesPath);
        NSArray *slides = [[LibraryAPI sharedInstance] listFilesAtPath:slidesPath];
        
        // Notecards array to hold cards for newPresentation (below)
        // i=1 to skip the blank slide at the beginning.
        
        for(int i=1; i<slides.count; i++) {
            
            // Load the slide and get its data as a string
            NSString *slidePath = [slidesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",[slides objectAtIndex:i]]];
            NSString *xml = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:slidePath] encoding:NSUTF8StringEncoding];
            
            NSLog(@"\t SLIDE %d: \n",i);
            NSMutableArray *slideBullets = [Presentation getTextFromXML:xml BetweenTag:@"a:t"];
            
            [notecards addObject:[[Notecard alloc] initWithBullets:slideBullets]];
            
            // Output bullets
            for (NSString *bullet in slideBullets) NSLog(@"    - %@", bullet);
        }
        
        importedPresentation.pathToUnzippedPPTX = directoryPath;
        // Remove the files, since they're not needed anymore.
        [[LibraryAPI sharedInstance] deleteFileAtPath:zipPath];
        
        importedPresentation.notecards = notecards;
        importedPresentation.type = service;
        //Capitalize first letter of "service" type
        importedPresentation.description = [NSString stringWithFormat:@"%@ imported from %@",name,
                                            [service stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                             withString:[[service substringToIndex:1] capitalizedString]]];
    } else {
        NSLog(@"no datas");
    }
    return importedPresentation;
}

// Takes a tag where <p> tag would be NSString "p"
+ (NSMutableArray *)getTextFromXML:(NSString *)xml BetweenTag:(NSString *)tag {
    
    //NSLog(@"\n\n XML:\n %@", xml);
    
    // @"<badgeCount>([^<]+)</badgeCount>";
    // Example of what the pattern should look like^
    NSString *pattern = [NSString stringWithFormat:@"<%@>([^<]+)</%@>",tag,tag];
    //NSLog(@"\nRegular expression: %@ \n",pattern);
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    //NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:xml options:0 range:NSMakeRange(0, xml.length)];
    NSArray *textCheckingResults = [regex matchesInString:xml options:0 range:NSMakeRange(0, xml.length)];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSRange matchRange;
    NSString *match;
    
    // Stick the search results in the results array
    for(NSTextCheckingResult *textCheckingResult in textCheckingResults) {
        matchRange = [textCheckingResult rangeAtIndex:1];
        match = [xml substringWithRange:matchRange];
        [results addObject:match];
    }
    
    return results;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.notecards forKey:@"notecards"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.arrayIndex forKey:@"arrayIndex"];
    [aCoder encodeObject:self.pathToUnzippedPPTX forKey:@"pathToUnzippedPPTX"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self)
    {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _type  = [aDecoder decodeObjectForKey:@"type"];
        _notecards = [aDecoder decodeObjectForKey:@"notecards"];
        _description = [aDecoder decodeObjectForKey:@"description"];
        _arrayIndex = [aDecoder decodeObjectForKey:@"arrayIndex"];
        _pathToUnzippedPPTX = [aDecoder decodeObjectForKey:@"pathToUnzippedPPTX"];
    }
    return self;
}

@end


