//
//  CalibrationViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 2/8/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "CalibrationViewController.h"
#import "LibraryAPI.h"
#import <OpenEars/OpenEarsEventsObserver.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/AcousticModel.h>
#import "DrEditUtilities.h"
#import "MBProgressHUD.h"

@interface CalibrationViewController ()

@end

@implementation CalibrationViewController {
    
    BOOL pocketSphinxCalibrated;
}

@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.isRecording = NO;
    
    [self.recordButton setTitle:@"Begin Calibration" forState:UIControlStateNormal];
    
    self.textView.text = @"By reading this sample text, I will help calibrate speech recognition for this app. The quick brown fox jumped over the lazy dog.";
    self.textView.font = [UIFont systemFontOfSize:20];
    self.textView.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:.5];
    
    [self.activityIndicator setHidden:YES];
}

#pragma mark - rotation/orientation-related methods

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
}

- (IBAction)didPressCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressRecord:(id)sender {
    
    if (self.isRecording) {
        
        // Stop the speech recognition algorithm and do the calculations
        [self deconstructVoiceRecognition];
        
        float pointOneConstant = (float)[self.spokenWords count]/(float)[self.allWords count];
        NSLog(@"New pointOneConstant: %f", pointOneConstant);
        
        // Alert that it was successful.
        // Arbitrary minimum value
        if (pointOneConstant < .15) {
            [DrEditUtilities showErrorMessageWithTitle:@"Calibration Unsuccessful" message:@"Try again for more accurate calibration" delegate:self];
            [self.recordButton setTitle:@"Begin Calibration" forState:UIControlStateNormal];
        }
        else {
            [DrEditUtilities showErrorMessageWithTitle:@"Calibration successful!" message:nil delegate:self];
            // Store new PointOneConstant in defaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSNumber numberWithFloat:pointOneConstant] forKey:@"pointOneConstant"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        [self.recordButton setTitle:@"Finish Calibration" forState:UIControlStateNormal];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Initializing speech recognition...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [self initSpeechRecognition];
            
            while (!pocketSphinxCalibrated) {
                // Not sure if bad practice
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }
    self.isRecording = !self.isRecording;
}

- (void)initSpeechRecognition {
    
    pocketSphinxCalibrated = NO;
    
    NSString *uppercaseText = [self.textView.text uppercaseString];
    self.allWords = [NSMutableSet setWithArray:[uppercaseText componentsSeparatedByString:@" "]];
    self.spokenWords = [[NSMutableSet alloc] init];
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
    lmWords = words;
    
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
    
    [self.openEarsEventsObserver setDelegate:self];
    [self.pocketsphinxController setSecondsOfSilenceToDetect:.2];
    
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
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
    for (NSString *word in self.allWords) {
        if ([self.spokenWords containsObject:word]) {
            portionOfCardSpoken = [NSMutableString stringWithString:[portionOfCardSpoken stringByAppendingString:[NSString stringWithFormat:@"%@ ",word]]];
        }
    }
    
    NSLog(@"Spoken words: %d of %d: %@", self.spokenWords.count, self.allWords.count, portionOfCardSpoken);
    
    float progress = (float)[self.spokenWords count]/(float)[self.allWords count];
    NSLog(@"progress: %f", progress);
}

- (void) pocketsphinxDidStartCalibration {
    
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
    
	NSLog(@"Pocketsphinx calibration is complete.");
    pocketSphinxCalibrated = YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
