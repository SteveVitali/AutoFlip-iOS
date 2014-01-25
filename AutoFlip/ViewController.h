//
//  ViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import <DropboxSDK/DropboxSDK.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "SSZipArchive.h"
#import "DriveFilesListViewController.h"

@interface ViewController : UIViewController <DBRestClientDelegate, SSZipArchiveDelegate, DriveFilePickerDelegate>

@property (weak, nonatomic) IBOutlet FUIButton *startButton;
@property (weak, nonatomic) IBOutlet FUIButton *importButton;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;

@property (nonatomic, readonly) DBRestClient *restClient;

- (IBAction)showMenu:(id)sender;
- (IBAction)showDebugging:(id)sender;

- (void)returnToRoot;
- (void)driveFileDidDownloadWithData:(NSData *)data andName:(NSString *)name;
- (void)didCancelDriveFileChooser:(id)sender;

@end
