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

@interface ChooseCardsViewController ()
{
    NSMutableArray *presentations;
    Presentation *chosenPresentation;
    __weak IBOutlet UIBarButtonItem *editButton;
    
    DesignManager *designManager;
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
    
    [self.navigationController.navigationBar setHidden:NO];
    self.view.backgroundColor = [UIColor cloudsColor];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"startPresentation"]) {
        PresentationViewController *controller =
                                    (PresentationViewController *)[segue destinationViewController];
        controller.presentation = chosenPresentation;
    }
    else if ([segue.identifier isEqualToString:@"openPresentationEditor"]) {
        
        CreateCardsViewController *controller = (CreateCardsViewController *)[segue destinationViewController];
        controller.presentation = chosenPresentation;
        // This should be changed at some point.
        controller.presentationTitle = chosenPresentation.title;
        controller.presentationDescription = chosenPresentation.description;
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

- (void) popToRoot {
    
    UINavigationController *nav = (UINavigationController*) self.view.window.rootViewController;
    ViewController *root = [nav.viewControllers objectAtIndex:0];
    [root returnToRoot];
}

- (IBAction)chooseButtonPressed:(id)sender {
    
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
    if ([self.chooserType isEqualToString:@"present"]) {
        [self performSegueWithIdentifier:@"startPresentation" sender:self];
    }
    else if ([self.chooserType isEqualToString:@"edit"]) {
        [self performSegueWithIdentifier:@"openPresentationEditor" sender:self];
    }
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
        [presentations removeObjectAtIndex:indexPath.row];
      //  [[LibraryAPI sharedInstance] deletePresentationAtIndex:indexPath.row];
        [[LibraryAPI sharedInstance] savePresentations];

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
