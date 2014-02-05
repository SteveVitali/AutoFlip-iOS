//
//  ChoosePresentationViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "ChooseCardsViewController.h"
#import "ViewController.h"
#import "PresentationViewController.h"
#import "CardDeckTableCell.h"
#import "LibraryAPI.h"
#import "Presentation.h"
#import "UITableViewCell+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIBarButtonItem+FlatUI.h"
#import "CreateCardsViewController.h"
#import "DesignManager.h"
#import "KxMenu.h"
#import "DrEditUtilities.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "DriveFilesListViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import <DBChooser/DBChooser.h>
#import "SSZipArchive.h"
#import "Notecard.h"


@interface ChooseCardsViewController ()
{
    NSMutableArray *presentations;
    Presentation *chosenPresentation;
    __weak IBOutlet UIBarButtonItem *editButton;
    
    DesignManager *designManager;
    Presentation *importedPresentation;
    
    UIImage *drive;
    UIImage *custom;
    UIImage *dropbox;
    UIImage *present;
    UIImage *edit;
}
@end

@implementation ChooseCardsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    designManager = [[LibraryAPI sharedInstance] designManager];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    presentations = [[LibraryAPI sharedInstance] getPresentations];
    self.searchResults = [NSMutableArray arrayWithCapacity:[presentations count]];
    
    //Set table colors
    self.tableView.separatorColor = [designManager tableCellSeparatorColor];
    
    [self.view setBackgroundColor:[[[LibraryAPI sharedInstance] designManager] homeScreenBGColor]];
    
    self.navigationItem.title = @"Choose a Presentation";
    
    //scale 4.0 = 1/4 original image size
    drive = [designManager scaleImage:[UIImage imageNamed:@"drive.png"] withScale:8.0];
    dropbox=[designManager scaleImage:[UIImage imageNamed:@"dropbox.png"] withScale:8.0];
    custom =[designManager scaleImage:[UIImage imageNamed:@"custom.png"] withScale:4.0];
    present=[designManager scaleImage:[UIImage imageNamed:@"present.png"] withScale:4.0];
    edit   =[designManager scaleImage:[UIImage imageNamed:@"edit.png"] withScale:4.0];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"startPresentation"]) {
        
        PresentationViewController *controller = (PresentationViewController *)[segue destinationViewController];
        controller.presentation = chosenPresentation;
    }
    else if ([segue.identifier isEqualToString:@"editPresentation"]) {
        
        CreateCardsViewController *controller = (CreateCardsViewController *)[segue destinationViewController];
        controller.presentation = chosenPresentation;
        // This should be changed at some point.
        controller.presentationTitle = chosenPresentation.title;
        controller.presentationDescription = chosenPresentation.description;
    }
    else if ([segue.identifier isEqualToString:@"newCardDeck"]) {
        
    }
    else if ([segue.identifier isEqualToString:@"driveFileChooser"]) {
        
        UINavigationController *driveNav = (UINavigationController *)[segue destinationViewController];
        DriveFilesListViewController *controller = (DriveFilesListViewController *)[driveNav viewControllers][0];
        controller.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"createImportedCards"]) {
        
        CreateCardsViewController *controller = (CreateCardsViewController *)[segue destinationViewController];
        controller.presentation = importedPresentation;
        // This should be changed at some point.
        controller.presentationTitle = importedPresentation.title;
        controller.presentationDescription = importedPresentation.description;
    }
}

- (void)toggleEditing {
    
    if (self.tableView.editing){
        [self.tableView setEditing:NO animated:YES];
        editButton.title = @"Edit";

    } else {
        [self.tableView setEditing:YES animated:YES];
        editButton.title = @"Done";
    }
}

- (IBAction)addButtonPressed:(id)sender {
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Create Cards"
                     image:custom
                    target:self
                    action:@selector(pushCreateCardsView:)],
      
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
    first.foreColor = [[[LibraryAPI sharedInstance] designManager] kxMenuTextColor];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:self.view.frame
                 menuItems:menuItems];
}

- (void)pushCreateCardsView:(id)sender {
    
    [self performSegueWithIdentifier:@"newCardDeck" sender:sender];
}

- (void)pushDriveView:(id)sender {
    
    [self performSegueWithIdentifier:@"driveFileChooser" sender:sender];
}

- (void)didCancelDriveFileChooser:(id)sender {
    NSLog(@"dismissing drive file chooser");
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


#pragma mark - Table view data source and table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        return [presentations count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    Presentation *presentation;

    UITableViewCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier];
    }
    // Configure cell design
    [cell configureFlatCellWithColor:[UIColor cloudsColor] selectedColor:[designManager tableCellBGColorSelected]];
    
    [cell.textLabel setTextColor:[designManager tableCellTextColor]];
    
    // Both of these BGColors need to be specified because of the accessory in the UITableViewCell
    [cell.contentView setBackgroundColor:[designManager tableCellBGColorNormal]];
    [cell.backgroundView setBackgroundColor:[designManager tableCellBGColorNormal]];
    [cell.detailTextLabel setTextColor:[designManager tableCellDetailColor]];
    [cell setBackgroundColor:[designManager tableCellBGColorNormal]];
    
    [self.tableView setSeparatorColor:[designManager tableCellSeparatorColor]];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    cell.cornerRadius = 5.f; //Optional
    if (self.tableView.style == UITableViewStyleGrouped) {
        cell.separatorHeight = 2.f; //Optional
    } else {
        cell.separatorHeight = 0.;
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        presentation = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        presentation = [presentations objectAtIndex:indexPath.row];
    }
    
    //NSString *arrayIndex = [NSString stringWithFormat:@"%d",presentation.arrayIndex.integerValue];
    //cell.textLabel.text = [arrayIndex stringByAppendingString:presentation.title];
    cell.textLabel.text = presentation.title;
    cell.detailTextLabel.text = presentation.description;
    //Assuming the icon is a .png and is named the same as the "type"
    cell.imageView.image = [UIImage imageNamed:[presentation.type stringByAppendingString:@".png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //CardDeckTableCell *cell = (CardDeckTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        chosenPresentation = [self.searchResults objectAtIndex:indexPath.row];
        
    } else {
        chosenPresentation = [presentations objectAtIndex:indexPath.row];
    }
    
    NSArray *menuItems =
    @[
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
    first.foreColor = [[[LibraryAPI sharedInstance] designManager] kxMenuTextColor];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:self.view.frame
                 menuItems:menuItems];
    
    // Below: code from when the home screen was the ViewController class, which had
    // edit and present buttons, which took you to this controller but with a different "chooserType"
//    if ([self.chooserType isEqualToString:@"present"]) {
//        [self performSegueWithIdentifier:@"startPresentation" sender:self];
//    }
//    else if ([self.chooserType isEqualToString:@"edit"]) {
//        [self performSegueWithIdentifier:@"openPresentationEditor" sender:self];
//    }
}

- (void)didPressEdit:(id)sender {
    
    [self performSegueWithIdentifier:@"editPresentation" sender:sender];
}

- (void)didPressPresent:(id)sender {
    
    [self performSegueWithIdentifier:@"startPresentation" sender:sender];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"details, details, details");
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // Delete the presentation, maintaining the integrity of the arrayIndex values.
        [[LibraryAPI sharedInstance] deletePresentationAtIndex:indexPath.row];
        [[LibraryAPI sharedInstance] savePresentations];
        presentations = [[LibraryAPI sharedInstance] getPresentations];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class,
        // insert it into the array, and add a new row to the table view
    }
    [tableView reloadData];
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    
    Presentation *presentation = [presentations objectAtIndex:fromIndexPath.row];
    // This will ensure integrity of arrayIndex values.
    [[LibraryAPI sharedInstance] deletePresentationAtIndex:fromIndexPath.row];
    [[LibraryAPI sharedInstance] addPresentation:presentation atIndex:toIndexPath.row];
    [[LibraryAPI sharedInstance] savePresentations];
    
    [self.tableView reloadData];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - UISearchBarDelegate methods
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    [self.searchResults removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray:
                          [presentations filteredArrayUsingPredicate:predicate]];
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

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
