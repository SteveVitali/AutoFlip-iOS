//
//  DriveFilesListViewController.h
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrEditFileEditDelegate.h"

@protocol DriveFilePickerDelegate;

@interface DriveFilesListViewController : UITableViewController <DrEditFileEditDelegate,
                                                                    UISearchBarDelegate,
                                                                UISearchDisplayDelegate>

@property (weak) id<DriveFilePickerDelegate> delegate;

@property (strong,nonatomic) NSMutableArray *searchResults;
@property IBOutlet UISearchBar *searchBar;

- (IBAction)didPressCancel:(id)sender;

- (void)uploadFileToGoogleDrive:(NSString*)filePath;

@end

@protocol DriveFilePickerDelegate <NSObject>

@required

- (void)driveFileDidDownloadWithData:(NSData *)data andName:(NSString *)name;
- (void)didCancelDriveFileChooser:(id)sender;

@end
