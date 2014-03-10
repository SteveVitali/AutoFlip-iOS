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
#import "UITextView+AutoResizeFont.h"

@interface PresentationViewController () {
    
}

@end

@implementation PresentationViewController {
    
    BOOL speechRecognitionOn;
    float pointOneConstant;
}

@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pocketSphinxCalibrated = NO;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Don't run [self resetSpeechRecognition] here because it will get run in [self reloadCard];
    //[self resetSpeechRecognition];
    
    // Hide navigation bar w/ screen tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShowNavigation)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];

    speechRecognitionOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"speechRecognition"] boolValue];
    
    // Commenting out, since right now it's getting initialized from the Chooser's prepareForSegue
//    if (speechRecognitionOn && !self.pocketSphinxCalibrated) {
//        [self initSpeechRecognition];
//    }
    [self.navigationItem setTitle:[self.presentation title]];
    
    pointOneConstant = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pointOneConstant"] floatValue] ?
                       [[[NSUserDefaults standardUserDefaults] objectForKey:@"pointOneConstant"] floatValue] : 0.3;
    NSLog(@"PointOneConstant: %f", pointOneConstant);
    
    [self reloadCard];
}

- (void)initSpeechRecognition {
    
    self.pocketSphinxCalibrated = NO;

    self.allWords = [NSMutableSet setWithSet:[self.presentation getAllWordsInPresentation]];

    // init language model
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    
    NSMutableArray *words = [[NSMutableArray alloc] initWithArray:[self.allWords allObjects]];
    // Words for language model
    NSArray *lmWords;
    // To keep the app from crashing due to nil language model
    // Also to get rid of words which are just empty "" strings.
    for (int i=0; i<words.count; i++) {
        NSString *word = [words objectAtIndex:i];
        if ([word isEqualToString:@""]) {
            [words removeObject:word];
            i--;
        }
    }
    if ([words count] ==0) {
        lmWords = @[@"THE"];
    } else {
        lmWords = words;
    }
    
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    NSError *err = [lmGenerator generateLanguageModelFromArray:lmWords withFilesNamed:name forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]];
    
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
    
    NSLog(@"All words: %@", self.allWords);
    
}

- (void)resetSpeechRecognitionForNewSlide {
    
    // // // // // // // All the stuff is commented out below because the new method in the Presentaiton model takes care of it.
//    NSString *slideText = [[self.presentation.notecards objectAtIndex:self.cardIndex] getTextFromBulletFormat];
//    slideText = [slideText uppercaseString];
//    
//    if ([slideText isEqualToString:@""]) {
//        // So the app doesn't crash, and so the slide essentially gets skipped.
//        slideText = @"THE";
//    }
//    
    // Set the set of all words, and also prepare the words array to be put into the language
    // model by removing duplicate words.
//    NSMutableArray *words = [NSMutableArray arrayWithArray:[slideText componentsSeparatedByString:@" "]];
//    
//    for (int i=0; i<words.count; i++) {
//        NSString *word = [words objectAtIndex:i];
//        if ([word isEqualToString:@""]) {
//            [words removeObjectAtIndex:i];
//            i--;
//        }
//    }
//    self.slideWords = [NSMutableSet setWithArray:words];
    
    self.slideWords = [[NSMutableSet alloc] initWithSet:[Presentation getAllWordsFromCard:[self.presentation.notecards objectAtIndex:self.cardIndex]]];
    
    // Reset the spoken words array
    self.spokenWords = [[NSMutableSet alloc] init];
    
    NSLog(@"Slide words: %@", self.slideWords);
}

- (void) hideShowNavigation {
    
    [super hideShowNavigation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
//    [self resizeCardsBasedOnVisibleSpace];
//    [self resizeTextToFitScreen];
    NSLog(@"what about this");
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)resizeTextToFitScreen {
    
    [super resizeTextToFitScreen];
}

- (void)resizeCardsBasedOnVisibleSpace {
    
    [super resizeCardsBasedOnVisibleSpace];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self deconstructVoiceRecognition];
}

- (void)deconstructVoiceRecognition {
    
    if (self.pocketsphinxController) {
        [self.pocketsphinxController stopListening];
        [self.pocketsphinxController stopVoiceRecognitionThread];
    }
    
    self.pocketsphinxController = nil;
    self.openEarsEventsObserver = nil;
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
    for (NSString *word in self.slideWords) {
        if ([self.spokenWords containsObject:word]) {
            portionOfCardSpoken = [NSMutableString stringWithString:[portionOfCardSpoken stringByAppendingString:[NSString stringWithFormat:@"%@ ",word]]];
        }
    }
    
    float progress = (float)[self.spokenWords count]/(float)[self.slideWords count];
    NSLog(@"Spoken words: %d of %d: [%f] %@", self.spokenWords.count, self.slideWords.count, progress, portionOfCardSpoken);

    if (progress >= pointOneConstant) {
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
    self.pocketSphinxCalibrated = YES;
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
    
    NSLog(@"card index: %d", self.cardIndex);
    [super nextCard:sender];
}

- (IBAction)previousCard:(id)sender {
    
    [super previousCard:sender];
}

- (void)reloadCard {
    
    [super reloadCard];
    //[self.textArea setFont:[UIFont systemFontOfSize:[self.designManager.presentTextSize floatValue]]];
    if (speechRecognitionOn) {
        [self resetSpeechRecognitionForNewSlide];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
