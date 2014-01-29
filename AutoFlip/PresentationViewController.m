//
//  PresentationViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "PresentationViewController.h"
#import "Presentation.h"
#import <OpenEars/OpenEarsEventsObserver.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/AcousticModel.h>
#import "Notecard.h"
#import "LibraryAPI.h"
#import "DesignManager.h"

@interface PresentationViewController () {
    
}

@end

@implementation PresentationViewController

@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:[self.presentation title]];
    
    // Don't run [self resetSpeechRecognition] here because it will get run in [self reloadCard];
    //[self resetSpeechRecognition];
    
    // Hide navigation bar w/ screen tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShowNavigation)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [self.textArea setFont:[UIFont systemFontOfSize:[self.designManager.presentTextSize floatValue]]];
}

- (void)resetSpeechRecognition {
    
    if (self.pocketsphinxController) {
        [self.pocketsphinxController stopListening];
    }
    
    self.pocketsphinxController = nil;
    self.openEarsEventsObserver = nil;
    
    // init language model
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    
    NSString *text = [NSString stringWithString:self.textArea.text];
    text = [text uppercaseString];
    
    NSLog(@"text: %@", text);
    if ([text isEqualToString:@""]) {
        // So the app doesn't crash, and so the slide essentially gets skipped.
        text = @"THE";
    }
    
    self.spokenWords = [[NSMutableSet alloc] init];
    // Set the set of all words, and also prepare the words array to be put into the language
    // model by removing duplicate words.
    NSArray *words = [text componentsSeparatedByString:@" "];
    self.allWords = [NSMutableSet setWithArray:words];
    words = [self.allWords allObjects];
    
    //NSArray *words = [NSArray arrayWithObjects:@"THE", @"COLD", @"WAR", @"COMMUNIST", @"COUNTRY", @"CHINA", nil];
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]];
    
    NSDictionary *languageGeneratorResults = nil;
    
    NSString *lmPath = nil;
    NSString *dicPath = nil;
	
    if([err code] == noErr) {
        
        languageGeneratorResults = [err userInfo];
		
        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
		
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    
    // Test speech out
    // right before my first self.pocketspinxcontroller
    [self.openEarsEventsObserver setDelegate:self];
    [self.pocketsphinxController setSecondsOfSilenceToDetect:.2];
    
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to perform Spanish recognition instead of English.
    
}

- (void) hideShowNavigation {
    
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    [self.navigationController setToolbarHidden:!self.navigationController.toolbarHidden animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.pocketsphinxController stopListening];
}

- (PocketsphinxController *)pocketsphinxController {
    
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
    
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    
    NSArray *newWords = [hypothesis componentsSeparatedByString:@" "];
    [self.spokenWords addObjectsFromArray:newWords];
    
    NSMutableString *portionOfCardSpoken = [NSMutableString stringWithString:@""];
    for (NSString *word in self.allWords) {
        if ([self.spokenWords containsObject:word]) {
            portionOfCardSpoken = [NSMutableString stringWithString:[portionOfCardSpoken stringByAppendingString:[NSString stringWithFormat:@"%@ ",word]]];
        }
    }
    
    NSLog(@"Spoken words: %d of %d: %@", self.spokenWords.count, self.allWords.count, portionOfCardSpoken);
    float progress = (float)[self.spokenWords count]/(float)[self.allWords count];
    if (progress >= .3) {
        if (self.hasNextCard) {
            [self nextCard:nil];
        }
        NSLog(@"Flipping card!");
    }
}

- (void) pocketsphinxDidStartCalibration {
    
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
    
	NSLog(@"Pocketsphinx calibration is complete.");
}

- (void) pocketsphinxDidStartListening {
    
	NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
    
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
    
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
    
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
    
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
    
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
    
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail {
    // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}
- (void) testRecognitionCompleted {
    
	NSLog(@"A test file that was submitted for recognition is now complete.");
}


- (IBAction)nextCard:(id)sender {
    
    [super nextCard:sender];
}

- (IBAction)previousCard:(id)sender {
    
    [super previousCard:sender];
}

- (void)reloadCard {
    
    [super reloadCard];
    [self resetSpeechRecognition];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
