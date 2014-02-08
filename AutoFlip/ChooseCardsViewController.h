//
//  ChoosePresentationViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDeckTableCell.h"
#import <DropboxSDK/DropboxSDK.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "SSZipArchive.h"
#import "DriveFilesListViewController.h"
#import "FMMoveTableView.h"

@interface ChooseCardsViewController : UITableViewController
                                        <UITableViewDataSource,
                                         UITableViewDelegate,
                                         UISearchBarDelegate,
                                         UISearchDisplayDelegate,
                                         DBRestClientDelegate,
                                         SSZipArchiveDelegate,
                                         DriveFilePickerDelegate,
                                         FMMoveTableViewDelegate, FMMoveTableViewDataSource,
                                         UIGestureRecognizerDelegate>

@property (strong,nonatomic) NSMutableArray *searchResults;
@property IBOutlet UISearchBar *searchBar;

// Either "edit" or "present"
//@property NSString *chooserType;

- (IBAction)toggleEditing;
- (IBAction)addButtonPressed:(id)sender;

- (void)driveFileDidDownloadWithData:(NSData *)data andName:(NSString *)name andMimeType:(NSString *)mimeType;

// For the sidebar
- (IBAction)showMenu;
- (void)returnToRoot;

@end
