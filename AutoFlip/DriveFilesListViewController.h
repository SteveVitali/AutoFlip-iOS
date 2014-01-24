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

@interface DriveFilesListViewController : UITableViewController <DrEditFileEditDelegate>

@property (weak) id<DriveFilePickerDelegate> delegate;

- (void)driveFileDidDownloadWithData:(NSData *)data;

@end

@protocol DriveFilePickerDelegate <NSObject>

@required

- (void)driveFileDidDownloadWithData:(NSData *)data andName:(NSString *)name;

@end
