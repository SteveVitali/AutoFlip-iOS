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
#import "ChooseCardsViewController.h"
#import "DesignManager.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    UIImage *drive;
    UIImage *dropbox;
    UIImage *custom;
    UIImage *edit;
    UIImage *present;
    
    DesignManager *designManager;
    
    Presentation *importedPresentation;
}

@synthesize restClient = _restClient;

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    designManager = [[LibraryAPI sharedInstance] designManager];
    
    drive   = [UIImage imageNamed:@"drive.png"];
    dropbox = [UIImage imageNamed:@"dropbox.png"];
    custom  = [UIImage imageNamed:@"custom.png"];
    edit    = [UIImage imageNamed:@"edit.png"];
    present = [UIImage imageNamed:@"present.png"];
    
    //scale 4.0 = 1/4 original image size
    //makes assumptions on image sizes, which is bad but this is just to test the menu thing.
    drive = [self scaleImage:drive withScale:8.0];
    dropbox=[self scaleImage:dropbox withScale:8.0];
    custom =[self scaleImage:custom withScale:4.0];
    edit   =[self scaleImage:edit withScale:4.0];
    present=[self scaleImage:present withScale:4.0];
    
    self.logoLabel.font = [UIFont flatFontOfSize:36];
    self.logoLabel.textColor = [UIColor midnightBlueColor];
  //  self.logoLabel.font = [UIFont systemFontOfSize:36];
    
    self.view.backgroundColor = [designManager homeScreenBGColor];
    
    [self styleFlatUIButton:self.startButton withDesignManager:designManager];
    [self styleFlatUIButton:self.createButton withDesignManager:designManager];
    [self styleFlatUIButton:self.editButton withDesignManager:designManager];
    [self styleFlatUIButton:self.importButton withDesignManager:designManager];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController setToolbarHidden:YES];
}

- (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale {
    
    return [UIImage imageWithCGImage:[image CGImage]
                              scale:(image.scale * scale)
                        orientation:(image.imageOrientation)];
}

- (void)styleFlatUIButton:(FUIButton *)button withDesignManager:(DesignManager *)manager {
    
    button.buttonColor = [manager buttonBGColor];
    button.shadowColor = [manager buttonShadowColor];//[UIColor greenSeaColor];
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[manager buttonTextColorNormal] forState:UIControlStateNormal];
    [button setTitleColor:[manager buttonTextColorHighlighted] forState:UIControlStateHighlighted];
}

- (IBAction)didPressStart:(id)sender {
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Choose Presentation Notes"
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"Present"
                     image:present
                    target:self
                    action:@selector(didPressPresent:)],
      
      [KxMenuItem menuItem:@"Edit"
                     image:edit
                    target:self
                    action:@selector(didPressEdit:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor turquoiseColor];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:self.view.frame
                 menuItems:menuItems];
}

- (void)didPressEdit:(id)sender {
    
    [self performSegueWithIdentifier:@"choosePresentationToEdit" sender:sender];
}

- (void)didPressPresent:(id)sender {
    
    [self performSegueWithIdentifier:@"choosePresentationToPresent" sender:sender];
}

- (IBAction)didPressCreate:(id)sender {
    
    [self performSegueWithIdentifier:@"newCardDeck" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"choosePresentationToPresent"]) {
        
        ChooseCardsViewController *controller = (ChooseCardsViewController *)[segue destinationViewController];
        controller.chooserType = @"present";
    }
    else if ([segue.identifier isEqualToString:@"choosePresentationToEdit"]) {
        
        ChooseCardsViewController *controller = (ChooseCardsViewController *)[segue destinationViewController];
        controller.chooserType = @"edit";
    }
    else if ([segue.identifier isEqualToString:@"newCardDeck"]) {
        
    }
    else if ([segue.identifier isEqualToString:@"driveFileChooser"]) {
        
        UINavigationController *driveNav = (UINavigationController *)[segue destinationViewController];
        DriveFilesListViewController *controller = (DriveFilesListViewController *)[driveNav viewControllers][0];
        controller.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"createImportedCards"]) {
        CreateCardsViewController *controller = (CreateCardsViewController *)[segue destinationViewController];
        controller.presentation = importedPresentation;
        // This should be changed at some point.
        controller.presentationTitle = importedPresentation.title;
        controller.presentationDescription = importedPresentation.description;
    }
}

- (IBAction)didPressImport:(id)sender {
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Import Presentation Notes"
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
    ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor turquoiseColor];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:self.view.frame
                 menuItems:menuItems];
}


- (void)pushDriveView:(id)sender {
    
    [self performSegueWithIdentifier:@"driveFileChooser" sender:sender];
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
        
        // Write the .zip file
        [data writeToFile:filePath atomically:YES];
        
        NSLog(@"documents directory");
        [[LibraryAPI sharedInstance] listFilesAtPath:documentsDirectory];
        
        NSString *zipPath = filePath;
        
        [SSZipArchive unzipFileAtPath:zipPath toDestination:directoryPath delegate:self];
        
        NSString *slidesPath = [directoryPath stringByAppendingPathComponent:@"/ppt/slides"];
        
        NSLog(@"Files in unzipped powerpoint directory");
        [[LibraryAPI sharedInstance] listFilesAtPath:directoryPath];
        NSLog(@"Files in the ppt/slides directory %@ \n", slidesPath);
        NSArray *slides = [[LibraryAPI sharedInstance] listFilesAtPath:slidesPath];
        
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
        importedPresentation.pathToUnzippedPPTX = directoryPath;
        
        NSLog(@"directoryPath: %@", importedPresentation.pathToUnzippedPPTX);
        
        // Remove the files, since they're not needed anymore.
        [[LibraryAPI sharedInstance] deleteFileAtPath:zipPath];
        
        [self performSegueWithIdentifier:@"createImportedCards" sender:self];

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

- (void)returnToRoot {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
