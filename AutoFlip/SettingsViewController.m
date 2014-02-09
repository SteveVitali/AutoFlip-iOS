//
//  SettingsViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 2/7/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "SettingsViewController.h"
#import "LibraryAPI.h"
#import "RESideMenu.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController {
    
    NSMutableArray *cellViews;
    BOOL recognitionOn;
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.view setBackgroundColor:[[[LibraryAPI sharedInstance] designManager] viewControllerBGColor]];
    [self.tableView setBackgroundColor:[[[LibraryAPI sharedInstance] designManager] tableViewBGColor]];
    
    NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
    recognitionOn = [[fetchDefaults objectForKey:@"speechRecognition"] boolValue];
    
    NSNumber *constant = [fetchDefaults objectForKey:@"pointOneConstant"];
    NSLog(@"current constant: %f",[constant floatValue]);
    
    // I think this gets overridden in the table view delegate methods
    self.toggleRecognitionSwitch.on = recognitionOn;
    [self.tableView reloadData];
    
    self.transitionController = [[TransitionDelegate alloc] init];
}

// For the sidebar
- (IBAction)showMenu {
    
    [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)didToggleRecognitionSwitch:(id)sender {
    
    NSLog(@"switch toggled!");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSNumber numberWithBool:self.toggleRecognitionSwitch.on] forKey:@"speechRecognition"];
    [defaults synchronize];
    
    NSString *onOff = self.toggleRecognitionSwitch.on ? @"ON" : @"OFF";
    NSLog(@"switch was turned %@", onOff);
}

- (IBAction)didPressCalibrate:(id)sender {
    
    // Code taken from https://github.com/hightech/iOS-7-Custom-ModalViewController-Transitions
    // The TransitionDelegate stuff is in /vendor/Transition Delegate
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"calibrationViewController"];
    vc.view.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:.8];
    [vc setTransitioningDelegate:self.transitionController];
    vc.modalPresentationStyle= UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)didPressResetDefaults:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"speechRecognition"];
    [defaults setObject:[NSNumber numberWithFloat:.3] forKey:@"pointOneConstant"];
    
    [self.toggleRecognitionSwitch setOn:[[defaults objectForKey:@"speechRecognition"] boolValue] animated:YES];
    
    NSLog(@"point one constant: %f", [[defaults objectForKey:@"pointOneConstant"] floatValue]);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if ( section == 0 ) {
        return 2;
    }
    else if ( section ==1 ) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    static NSString *CellNib;
    
    // Not sure this is the right way to do this, but it works, damnit.
    if (indexPath.section == 0) {
        // This should probably get refactored at some point,
        // But I didn't know how else to do the static cells
        switch (indexPath.row) {
            case 0:
                CellIdentifier = @"Cell1";
                CellNib = @"SettingsSpeechToggleCell";
                break;
            case 1:
                CellIdentifier = @"Cell2";
                CellNib = @"SettingsCalibrationCell";
                break;
        }
    }
    
    else if (indexPath.section == 1) {
        CellIdentifier = @"Cell3";
        CellNib = @"ResetDefaultsCell";
    }

    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (UITableViewCell *)[nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    [cell.layer setCornerRadius:2.0f];
//    [cell.layer setMasksToBounds:YES];
//    [cell.layer setBorderWidth:2.0f];
//    [cell.layer setBorderColor:[UIColor clearColor].CGColor];
    
    // This seems to have fixed the issue of the switch not loading with the right value.
    self.toggleRecognitionSwitch.on = recognitionOn;

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
