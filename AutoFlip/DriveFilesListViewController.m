/* Copyright (c) 2012 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  DrEditFilesListViewController.m
//

#import "DriveFilesListViewController.h"
#import "GTLDrive.h"
#import "GTMOAuth2ViewControllerTouch.h"
//#import "DrEditFileEditViewController.h"
#import "DrEditUtilities.h"
#import "ViewController.h"
#import <MobileCoreServices/UTType.h>
#import "LibraryAPI.h"
#import "UITableViewCell+FlatUI.h"
#import "MBProgressHUD.h"
#import <iAd/iAd.h>

// Constants used for OAuth 2.0 authorization.
static NSString *const kKeychainItemName = @"iOSDriveSample: Google Drive";
static NSString *const kClientId = @"226204493879-7fedavakjro1dn5jgg2hj8vt11bhhhb3.apps.googleusercontent.com";
static NSString *const kClientSecret = @"1aXd3lyDt8LR-MXInEmN5777";

UIAlertView *loadingAlert;

@interface DriveFilesListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *authButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;


@property (weak, readonly) GTLServiceDrive *driveService;
@property (retain) NSMutableArray *driveFiles;
@property BOOL isAuthorized;

- (IBAction)authButtonClicked:(id)sender;
- (IBAction)refreshButtonClicked:(id)sender;

- (void)toggleActionButtons:(BOOL)enabled;
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;
- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth;
- (void)loadDriveFiles;

@end


@implementation DriveFilesListViewController {
    
    DesignManager *designManager;
}
@synthesize addButton = _addButton;
@synthesize authButton = _authButton;
@synthesize refreshButton = _refreshButton;
@synthesize driveFiles = _driveFiles;
@synthesize isAuthorized = _isAuthorized;


- (void)awakeFromNib {
    
  [super awakeFromNib];
}

- (id)init {
    
    self = [super init];
    if (self) {
        [self checkAuthentication];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.tintColor = [[[LibraryAPI sharedInstance] designManager] primaryAccentColor];
    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.navigationBar.barTintColor = [[[LibraryAPI sharedInstance] designManager] navigationBarTintColor];
    //self.navigationController.toolbar.barTintColor = [[[LibraryAPI sharedInstance] designManager] navigationBarTintColor];
    //self.navigationController.toolbar.tintColor = [[[LibraryAPI sharedInstance] designManager] primaryAccentColor];
    
    designManager = [[LibraryAPI sharedInstance] designManager];

    //Set table colors
    [self.view setBackgroundColor:[designManager viewControllerBGColor]];

    // Moving to viewDidAppear
    [self checkAuthentication];
//    [self loadDriveFiles];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    //[self.tableView addSubview:refreshControl];
    
    [self.tableView setSeparatorColor:[designManager tableCellSeparatorColor]];
    
    self.canDisplayBannerAds = YES;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    //[refreshControl endRefreshing];
}

- (void)viewDidUnload {
    
  [self setAddButton:nil];
  [self setRefreshButton:nil];
  [self setAuthButton:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    
  [super viewDidAppear:animated];
    
    if (self.isAuthorized) {
        
//        // Sort Drive Files by modified date (descending order).
//        [self.driveFiles sortUsingComparator:^NSComparisonResult(GTLDriveFile *lhs,
//                                                               GTLDriveFile *rhs) {
//          return [rhs.modifiedDate.date compare:lhs.modifiedDate.date];
//        }];
//        [self.tableView reloadData];
        
        // Just going to call loadDriveFiles instead
        [self loadDriveFiles];
    }
    else {
        [self authButtonClicked:nil];
    }
}

- (void)checkAuthentication {
    
    // Check for authorization.
    GTMOAuth2Authentication *auth =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientId
                                                      clientSecret:kClientSecret];
    if ([auth canAuthorize]) {
        [self isAuthorizedWithAuthentication:auth];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        return [self.driveFiles count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DriveCell"];
    }
    
    GTLDriveFile *file;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        file = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        file = [self.driveFiles objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = file.title;
    
    // I have no idea why this works with the [UIColor cloudsColor] set that way, but it does
    [cell configureFlatCellWithColor:[UIColor cloudsColor] selectedColor:[designManager tableCellBGColorSelected]];
    
    [cell.textLabel setTextColor:[designManager tableCellTextColor]];
    [cell setBackgroundColor:[designManager tableCellBGColorNormal]];
    [cell.backgroundView setBackgroundColor:[designManager tableCellBGColorNormal]];
    [cell.contentView setBackgroundColor:[designManager tableCellBGColorNormal]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.cornerRadius = 5.f; //Optional
    if (self.tableView.style == UITableViewStyleGrouped) {
        cell.separatorHeight = 2.f; //Optional
    } else {
        cell.separatorHeight = 0.;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchBar resignFirstResponder];
    
    GTLDriveFile *file = [self.driveFiles objectAtIndex:indexPath.row];
    
    //loadingAlert = [DrEditUtilities showLoadingMessageWithTitle:@"Importing presentation..." delegate:self];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Importing presentation...";
    
    [self downloadFileContent:file];
}

- (void)printFileMetadataWithService:(GTLServiceDrive *)service
                              fileId:(NSString *)fileId {
    GTLQuery *query = [GTLQueryDrive queryForFilesGetWithFileId:fileId];
    
    // queryTicket can be used to track the status of the request.
    GTLServiceTicket *queryTicket =
    [service executeQuery:query
        completionHandler:^(GTLServiceTicket *ticket, GTLDriveFile *file,
                            NSError *error) {
            if (error == nil) {
                NSLog(@"Title: %@", file.title);
                NSLog(@"Description: %@", file.descriptionProperty);
                NSLog(@"MIME type: %@", file.mimeType);
            } else {
                NSLog(@"An error occurred: %@", error);
            }
        }];
    NSLog(@"Logging the queryTicket variable to get rid of the 'unused variable' 'error' %@", queryTicket);
}

- (void)downloadFileContent:(GTLDriveFile *)file {
    
    //NSString *exportFormat = @"text/plain";
    // As it turns out, if you use the above MIME type, Google Docs will actually export it for you
    // But then I'd have to parse through that and write new Presentation creation code, even if it
    // Technically runs 2 seconds faster (maybe more), so I'm going to export as pptx, then unzip and extract text
    // The same way I do for the Dropbox download.
    // We should probably change this at some point, but I really don't feel like doing it now.
    
    // ****UPDATE REGARDING THE ABOVE COMMENTS****
    // The time has come to change it, so that is what will happen, probably, at some point.

    NSString *exportFormat;
    NSString *exportURLStr;
    NSString *extn;
    
    if ([file.mimeType isEqualToString:@"application/vnd.google-apps.presentation"]) {
        
        exportFormat = @"application/vnd.openxmlformats-officedocument.presentationml.presentation";
        exportURLStr = [file.exportLinks JSONValueForKey:exportFormat];
    }
    else if ([file.mimeType isEqualToString:@"text/plain"]) {
        
        exportFormat = @"text/plain";
        exportURLStr = file.downloadUrl;
    }
    
    extn = [self extensionForMIMEType:exportFormat];

    // Use a GTMHTTPFetcher object to download the file with authorization.
    NSURL *url = [NSURL URLWithString:exportURLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    
    // Requests of user data from Google services must be authorized.
    fetcher.authorizer = self.driveService.authorizer;
    
    fetcher.receivedDataBlock = ^(NSData *receivedData) {
        // The fetcher will call the received data block periodically.
        // When a download path has been specified, the received data
        // parameter will be nil.
        //NSNumber *length = [NSNumber numberWithInteger:receivedData.length];
        //int kilobytes = [length floatValue]/1024;
        //NSString *loadingString = [[NSString alloc] initWithFormat:@"Importing presentation... %d KB", kilobytes];
        
        //loadingAlert = [DrEditUtilities showLoadingMessageWithTitle:loadingString delegate:self];
    };
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        // Callback
        if (error) {
            [self displayAlert:@"Error Downloading File"
                        format:@"%@", error];
        } else {
            NSLog(@"%@ downloaded successfully!", file.title);
            //[loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self driveFileDidDownloadWithData:data andName:file.title andMimeType:file.mimeType];
        }
    }];
}

- (NSString *)extensionForMIMEType:(NSString *)mimeType {
    NSString *result = nil;
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,
                                                            (__bridge CFStringRef)mimeType, NULL);
    if (uti) {
        CFStringRef cfExtn = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassFilenameExtension);
        if (cfExtn) {
            result = CFBridgingRelease(cfExtn);
        }
        CFRelease(uti);
    }
    return result;
}

- (void)driveFileDidDownloadWithData:(NSData *)data andName:(NSString *)name andMimeType:(NSString *)mimeType {

    [self.delegate driveFileDidDownloadWithData:data andName:name andMimeType:mimeType];
}

- (void)displayAlert:(NSString *)title format:(NSString *)format, ... {
    NSString *result = format;
    if (format) {
        va_list argList;
        va_start(argList, format);
        result = [[NSString alloc] initWithFormat:format
                                        arguments:argList];
        va_end(argList);
    }
    NSLog(@"%@",result);
}

- (void)uploadTextFileToGoogleDrive:(NSString*)fileText title:(NSString *)title fromController:(UIViewController *)controller {
    
    GTLDriveFile *driveFile = [[GTLDriveFile alloc] init];
    
    NSData *fileContent = [fileText dataUsingEncoding:NSUTF8StringEncoding];
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:fileContent
                                                                                 MIMEType:@"text/plain"];
    driveFile.title = title;
    
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:driveFile
                                                       uploadParameters:uploadParameters];
    
    //UIAlertView *alert = [DrEditUtilities showLoadingMessageWithTitle:@"Saving file to Drive..."
    //                                                         delegate:self];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading to Drive..";
    
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket, GTLDriveFile *updatedFile, NSError *error) {
        //[alert dismissWithClickedButtonIndex:0 animated:YES];
        [MBProgressHUD hideHUDForView:controller.view animated:YES];

        if (error == nil) {
            NSLog(@"File uploaded successfully!");
            [DrEditUtilities showErrorMessageWithTitle:[NSString stringWithFormat:@"'%@' successfully uploaded to Drive!",driveFile.title] message:nil delegate:self];
        } else {
            NSLog(@"Upload Failed: %@", error);
            [DrEditUtilities showErrorMessageWithTitle:@"Upload failed :(" message:nil delegate:self];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
  /*DrEditFileEditViewController *viewController = [segue destinationViewController];
  NSString *segueIdentifier = segue.identifier;
  viewController.driveService = [self driveService];
  viewController.delegate = self;
  
  if ([segueIdentifier isEqualToString:@"editFile"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    GTLDriveFile *file = [self.driveFiles objectAtIndex:indexPath.row];
    viewController.driveFile = file;
    viewController.fileIndex = indexPath.row;
  } else if ([segueIdentifier isEqualToString:@"addFile"]) {
    viewController.driveFile = [GTLDriveFile object];
    viewController.fileIndex = -1;
  }
   */
}

- (NSInteger)didUpdateFileWithIndex:(NSInteger)index
                          driveFile:(GTLDriveFile *)driveFile {
    
  if (index == -1) {
    if (driveFile != nil) {
      // New file inserted.
      [self.driveFiles insertObject:driveFile atIndex:0];
      index = 0;
    }
  } else {
    if (driveFile != nil) {
      // File has been updated.
      [self.driveFiles replaceObjectAtIndex:index withObject:driveFile];
    } else {
      // File has been deleted.
      [self.driveFiles removeObjectAtIndex:index];
      index = -1;
    }
  }
  return index;  
}

- (GTLServiceDrive *)driveService {
    
  static GTLServiceDrive *service = nil;
  
  if (!service) {
    service = [[GTLServiceDrive alloc] init];
    
    // Have the service object set tickets to fetch consecutive pages
    // of the feed so we do not need to manually fetch them.
    service.shouldFetchNextPages = YES;
    
    // Have the service object set tickets to retry temporary error conditions
    // automatically.
    service.retryEnabled = YES;
  }
  return service;
}

- (IBAction)authButtonClicked:(id)sender {
    
  if (!self.isAuthorized) {
    // Sign in.
    SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
    GTMOAuth2ViewControllerTouch *authViewController = 
      [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDrive
                                                 clientID:kClientId
                                             clientSecret:kClientSecret
                                         keychainItemName:kKeychainItemName
                                                 delegate:self
                                         finishedSelector:finishedSelector];
    [self presentModalViewController:authViewController
                            animated:YES];
  } else {
    // Sign out
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
    [[self driveService] setAuthorizer:nil];
    self.authButton.title = @"Sign in";
    self.isAuthorized = NO;
    [self toggleActionButtons:NO];
    [self.driveFiles removeAllObjects];
    [self.tableView reloadData];
  }  
}

- (IBAction)refreshButtonClicked:(id)sender {
    
  [self loadDriveFiles];
}

- (void)toggleActionButtons:(BOOL)enabled {
    
  self.addButton.enabled = enabled;
  self.refreshButton.enabled = enabled;
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    
  [self dismissModalViewControllerAnimated:YES];
  if (error == nil) {
      [self isAuthorizedWithAuthentication:auth];
      [self loadDriveFiles];
  }
}

- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth {
    
  [[self driveService] setAuthorizer:auth];
  self.authButton.title = @"Sign out";
  self.isAuthorized = YES;
  [self toggleActionButtons:YES];
}

- (void)loadDriveFiles {
    
    // Not sure how to tell the query I want to download two MIME types, so I'm just executing it twice for now
    GTLQueryDrive *query1 = [GTLQueryDrive queryForFilesList];
    query1.q = @"mimeType = 'text/plain'";
    
    //UIAlertView *alert1 = [DrEditUtilities showLoadingMessageWithTitle:@"Loading text documents" delegate:self];
    // Replace with MBProgressHUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading text files...";
    
    [self.driveService executeQuery:query1 completionHandler:^(GTLServiceTicket *ticket,
                                                               GTLDriveFileList *files,
                                                               NSError *error) {
        //[alert1 dismissWithClickedButtonIndex:0 animated:YES];
        hud.labelText = @"Loading presentations...";
        
        if (error == nil) {
            [self.driveFiles addObjectsFromArray:files.items];
            [self.tableView reloadData];
            NSLog(@"num items: %d",self.driveFiles.count);
        } else {
            NSLog(@"An error occurred: %@", error);
            [DrEditUtilities showErrorMessageWithTitle:@"Unable to load files"
                                               message:[error description]
                                              delegate:self];
        }
    }];
    
    GTLQueryDrive *query2 = [GTLQueryDrive queryForFilesList];
    //query.q = @"mimeType = 'text/plain'";
    query2.q = @"mimeType = 'application/vnd.google-apps.presentation'";
    
//    UIAlertView *alert = [DrEditUtilities showLoadingMessageWithTitle:@"Loading presentations..."
//                                                             delegate:self];
    
    if (self.driveFiles == nil) {
        self.driveFiles = [[NSMutableArray alloc] init];
    }
    [self.driveFiles removeAllObjects];
    
    [self.driveService executeQuery:query2 completionHandler:^(GTLServiceTicket *ticket,
                                                              GTLDriveFileList *files,
                                                              NSError *error) {
        //[alert dismissWithClickedButtonIndex:0 animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error == nil) {
            [self.driveFiles addObjectsFromArray:files.items];
            [self.tableView reloadData];
            NSLog(@"num items: %d",self.driveFiles.count);
        } else {
            NSLog(@"An error occurred: %@", error);
            [DrEditUtilities showErrorMessageWithTitle:@"Unable to load files"
                                               message:[error description]
                                              delegate:self];
        }
    }];
    

}

- (IBAction)didPressCancel:(id)sender {
    
    [self.delegate didCancelDriveFileChooser:self];
}

- (IBAction)popToRoot:(id)sender {
    
    UINavigationController *nav = (UINavigationController*) self.view.window.rootViewController;
    ViewController *root = [nav.viewControllers objectAtIndex:0];
    [root returnToRoot];
}

#pragma mark - UISearchBarDelegate methods
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    [self.searchResults removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray:
                          [self.driveFiles filteredArrayUsingPredicate:predicate]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self handleSearch:searchBar];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [self handleSearch:searchBar];
}

- (void)handleSearch:(UISearchBar *)searchBar {
    
    NSLog(@"User searched for %@", searchBar.text);
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
