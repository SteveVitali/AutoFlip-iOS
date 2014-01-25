//
//  ViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "ViewController.h"
#import "KxMenu.h"
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIBarButtonItem+FlatUI.h"
#import <DropboxSDK/DropboxSDK.h>
#import <DBChooser/DBChooser.h>
#import "MZFormSheetController.h"
#import "LibraryAPI.h"
#import "SSZipArchive.h"
#import "Presentation.h"
#import "Notecard.h"
#import "CreateCardsViewController.h"
#import "DriveFilesListViewController.h"
#import "DrEditUtilities.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    UIImage *drive;
    UIImage *dropbox;
    UIImage *custom;
    
    Presentation *importedPresentation;
}

@synthesize restClient = _restClient;

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    drive   = [UIImage imageNamed:@"drive.png"];
    dropbox = [UIImage imageNamed:@"dropbox.png"];
    custom  = [UIImage imageNamed:@"custom.png"];
    
    //scale 4.0 = 1/4 original image size
    //makes assumptions on image sizes, which is bad but this is just to test the menu thing.
    drive = [self scaleImage:drive withScale:8.0];
    dropbox=[self scaleImage:dropbox withScale:8.0];
    custom =[self scaleImage:custom withScale:4.0];
    
    self.logoLabel.font = [UIFont flatFontOfSize:36];
    self.logoLabel.textColor = [UIColor midnightBlueColor];
  //  self.logoLabel.font = [UIFont systemFontOfSize:36];
    
    self.view.backgroundColor = [UIColor cloudsColor];
    
    self.importButton.buttonColor = [UIColor turquoiseColor];
    self.importButton.shadowColor = [UIColor greenSeaColor];
    self.importButton.shadowHeight = 3.0f;
    self.importButton.cornerRadius = 6.0f;
    self.importButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.importButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.importButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
   
    self.startButton.buttonColor = [UIColor turquoiseColor];
    self.startButton.shadowColor = [UIColor greenSeaColor];
    self.startButton.shadowHeight = 3.0f;
    self.startButton.cornerRadius = 6.0f;
    self.startButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.startButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setToolbarHidden:YES];
}

- (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale {
    
    return [UIImage imageWithCGImage:[image CGImage]
                              scale:(image.scale * scale)
                        orientation:(image.imageOrientation)];
}

- (IBAction)showMenu:(UIButton *)sender {
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Import Notecards"
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"Google Drive"
                     image:drive
                    target:self
                    action:@selector(pushDriveView:)],
      
      [KxMenuItem menuItem:@"Dropbox"
                     image:dropbox
                    target:self
                    action:@selector(pushDropboxView:)],
      
      [KxMenuItem menuItem:@"Create cards"
                     image:custom
                    target:self
                    action:@selector(pushCreateCardsView:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor turquoiseColor];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)pushDriveView:(id)sender {
    
    [self performSegueWithIdentifier:@"driveFiles" sender:sender];
}

- (void)didCancelDriveFileChooser:(id)sender {
    NSLog(@"dismissing");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushDropboxView:(id)sender {
    
    //[self dropBoxCoreAuthentication];
    [self dropboxChooser];
}

#pragma mark - Dropbox Drop-ins methods

- (void)dropboxChooser {
    
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypeDirect
                                    fromViewController:self completion:^(NSArray *results)
     {
         if ([results count]) {
             // Process results from Chooser
             
             for (DBChooserResult *result in results) {
                 NSLog(@"results: %@",result.link);
                
                 [self handleDropboxFileWithResult:result];
             }
             
         } else {
             // User canceled the action
         }
     }];
}

- (void)handleDropboxFileWithResult:(DBChooserResult *)result {
    
    // Get the extension from the file name
    NSRange range = [result.name rangeOfString:@"."];
    NSString *extension = [result.name substringFromIndex:range.location];
    //NSString *name = [result.name substringToIndex:range.location];
    
    if ([extension isEqualToString:@".pptx"]) {
        
        // As it turns out, this sweet method exists, so the above isn't necessary (I think).
        NSString *name = [result.name stringByDeletingPathExtension];

        // Download the data of the file w/ the URL
        NSURL *url = result.link;
        NSData *urlData = [NSData dataWithContentsOfURL:url];
    
        [self createImportedPresentationWithData:urlData andName:name fromService:@"dropbox"];
    } else {
        [DrEditUtilities showErrorMessageWithTitle:@"Unsupported File Type"
                                           message:@"Try importing a .pptx file instead."
                                          delegate:self];
    }
}

- (void)driveFileDidDownloadWithData:(NSData *)data andName:(NSString *)name {
    
    [self dismissViewControllerAnimated:NO completion:^{
        [self createImportedPresentationWithData:data andName:name fromService:@"drive"];
    }];
}

- (void)createImportedPresentationWithData:(NSData *)data andName:(NSString *)name fromService:(NSString *)service {
    
    // If the file downloaded
    if ( data ) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        // Write dat file to a file whose name is the same as the imported file name
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,name];
        [data writeToFile:filePath atomically:YES];
        
        NSLog(@"documents directory");
        [self listFilesAtPath:documentsDirectory];
        
        //if ([extension isEqualToString:@".pptx"] || [extension isEqualToString:@".ppt"]) {
            
            // Set output path for zip file in a directory whose name is the same as the file name minus its extension
            NSString *outputPath = [documentsDirectory stringByAppendingPathComponent:
                                                           [NSString stringWithFormat:@"/%@",
                                                           [NSString stringWithFormat:@"%@.zip",name]]];
            NSString *zipPath = filePath;
            
            [SSZipArchive unzipFileAtPath:zipPath toDestination:outputPath delegate:self];
        
            NSString *slidesPath = [outputPath stringByAppendingPathComponent:@"/ppt/slides"];
            
            NSLog(@"Files in unzipped powerpoint directory");
            [self listFilesAtPath:outputPath];
            
            NSLog(@"Files in the ppt/slides directory %@ \n", slidesPath);
            NSArray *slides = [self listFilesAtPath:slidesPath];
            
            // Notecards array to hold cards for newPresentation (below)
            // i=1 to skip the blank slide at the beginning.
            NSMutableArray *notecards = [[NSMutableArray alloc] init];
            for(int i=1; i<slides.count; i++) {
                
                // Load the slide and get its data as a string
                NSString *slidePath = [slidesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",[slides objectAtIndex:i]]];
                NSString *xml = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:slidePath] encoding:NSUTF8StringEncoding];
                
                NSLog(@"\t SLIDE %d: \n",i);
                NSMutableArray *slideBullets = [self getTextFromXML:xml BetweenTag:@"a:t"];
                
                [notecards addObject:[[Notecard alloc] initWithBullets:slideBullets]];
                
                // Output bullets
                for (NSString *bullet in slideBullets) NSLog(@"    - %@", bullet);
            }
            importedPresentation = [[Presentation alloc] init];
            importedPresentation.title = name;
            importedPresentation.notecards = notecards;
            importedPresentation.type = service;
            //Capitalize first letter of "service" type
            importedPresentation.description = [NSString stringWithFormat:@"%@ imported from %@",name,
                                                         [service stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                          withString:[[service substringToIndex:1] capitalizedString]]];

            [self performSegueWithIdentifier:@"createImportedCards" sender:self];

 //       }
 //       else if ([extension isEqualToString:@".txt"] || [extension isEqualToString:@".rtf"]) {
 //
 //           NSString *dataString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
 //           // Do some other stuff with the file string
 //     }
    } else {
        NSLog(@"no datas");
    }
}

// Takes a tag where <p> tag would be NSString "p"
- (NSMutableArray *)getTextFromXML:(NSString *)xml BetweenTag:(NSString *)tag {
    
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

-(NSArray *)listFilesAtPath:(NSString *)path {
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    for (int count = 0; count < (int)[directoryContent count]; count++) {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"createImportedCards"]) {
        CreateCardsViewController *controller = (CreateCardsViewController *)[segue destinationViewController];
        controller.presentation = importedPresentation;
        // This should be changed at some point.
        controller.presentationTitle = importedPresentation.title;
        controller.presentationDescription = importedPresentation.description;
    }
    else if ([segue.identifier isEqualToString:@"driveFiles"]) {
        
        UINavigationController *driveNav = (UINavigationController *)[segue destinationViewController];
        DriveFilesListViewController *controller = (DriveFilesListViewController *)[driveNav viewControllers][0];
        controller.delegate = self;
    }
}

- (void)pushCreateCardsView:(id)sender {
    
    [self performSegueWithIdentifier:@"createCards" sender:sender];
}

- (IBAction)showDebugging:(id)sender {

    //[self dropBoxCoreAuthentication];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    UITextView *debugView = [[UITextView alloc] init];
    debugView.text = [[LibraryAPI sharedInstance] debuggingResults];
    debugView.frame = CGRectMake(0, 0, 200, 368);
    debugView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;

    UIScrollView *scrollView = [[UIScrollView alloc]
                                initWithFrame:CGRectMake(0, 0, 200, 368)];
    [scrollView addSubview:debugView];
    [viewController.view addSubview:scrollView];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:viewController];
    
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromBottom;
    formSheet.cornerRadius = 8.0;
    formSheet.portraitTopInset = 6.0;
    formSheet.landscapeTopInset = 6.0;
    formSheet.presentedFormSheetSize = CGSizeMake(200, 400);
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
}

- (void)returnToRoot {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


