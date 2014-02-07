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
#import "ChooseCardsTableViewCell.h"
#import "REFrostedViewController.h"

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
    [self.tableView setSeparatorColor:[designManager tableCellSeparatorColor]];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    
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

// For the sidebar
- (IBAction)showMenu {
    
    [self.frostedViewController presentMenuViewController];
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
    NSString *name = [result.name stringByDeletingPathExtension];
    
    // Download the data of the file w/ the URL
    NSURL *url = result.link;
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    if ([extension isEqualToString:@".pptx"]) {
        
        importedPresentation = [Presentation getPresentationFromPPTXData:urlData withName:name fromService:@"dropbox"];
    }
    else if ([extension isEqualToString:@".txt"]) {
        
        importedPresentation = [Presentation getPresentationFromTextFileData:urlData andName:name fromService:@"dropbox"];
    }
    
    else {
        [DrEditUtilities showErrorMessageWithTitle:@"Unsupported File Type"
                                           message:@"Try importing a .pptx file instead."
                                          delegate:self];
        return;
    }
    [self performSegueWithIdentifier:@"createImportedCards" sender:self];
}

- (void)driveFileDidDownloadWithData:(NSData *)data andName:(NSString *)name andMimeType:(NSString *)mimeType {
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        if ([mimeType isEqualToString:@"application/vnd.google-apps.presentation"]) {
            
            importedPresentation = [Presentation getPresentationFromPPTXData:data withName:name fromService:@"drive"];
        }
        else if ([mimeType isEqualToString:@"text/plain"]) {
            NSLog(@"kinda made it");
            importedPresentation = [Presentation getPresentationFromTextFileData:data andName:name fromService:@"drive"];
        }
        else {
            return;
        }
        [self performSegueWithIdentifier:@"createImportedCards" sender:self];
    }];
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

    ChooseCardsTableViewCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ChooseCardsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier];
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
        Presentation *deletedPresentation;
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            deletedPresentation = [self.searchResults objectAtIndex:indexPath.row];
        } else {
            deletedPresentation = [presentations objectAtIndex:indexPath.row];
        }
        [[LibraryAPI sharedInstance] deletePresentationAtIndex:deletedPresentation.arrayIndex.intValue];
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
