//
//  TestCreateCardsViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "CreateCardsViewController.h"
#import "SaveAsViewController.h"
#import "ChooseCardsViewController.h"
#import "Notecard.h"
#import "LibraryAPI.h"
#import "DesignManager.h"
#import "MZFormSheetController.h"
#import "KxMenu.h"
#import "UITextView+AutoResizeFont.h"

@interface CreateCardsViewController () {
    
    float kbHeight;
    // For the saving as
    MZFormSheetController *saveAsFormSheet;
    SaveAsViewController  *saveAsViewController;

    UIToolbar *toolbar;
}
- (void)saveAndExit;
- (void)saveAs;
- (void)exportCards;
@end

@implementation CreateCardsViewController {
    
    NSArray *kxSaveMenuItems;
    NSArray *kxExportMenuItems;
    NSArray *kxActionsMenuItems;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
	// Do any additional setup after loading the view.
    
    // If it's not an imported presentation
    if (!self.presentation) {
        self.presentation = [[Presentation alloc] init];
        [self.presentation insertCardAtIndex:0];
        [self.presentation setType:@"custom"];
        [self.textArea setText:@"\u2022 "];
        // Set presentation title and description from stuff passed through segue
        // I understand this code looks hilarious, but it works, damnit.
        self.presentation.title = self.presentationTitle;
        self.presentation.description = self.presentationDescription;
    }
    self.presentationTitleNavBar.title = self.presentationTitle;
    
    [self registerForNotifications];
    [self.textArea setDelegate:self];
    
    self.navigationItem.hidesBackButton = YES;
    
    //self.textArea.backgroundColor = [UIColor blueColor];
    //self.scrollView.backgroundColor = [UIColor redColor];
    // Hide navigation bar w/ screen tap
    UITapGestureRecognizer *tapText = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapText.numberOfTapsRequired = 2;
    [self.textArea addGestureRecognizer:tapText];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapScroll.numberOfTapsRequired = 2;
    
    self.textArea.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self initKxMenus];
    
    // I suspect this is the reason the first character wasn't getting registered
    // despite the text getting set above to a bullet and a space,
    // since the reloadCard method reloads the text to be the notecard text which is null.
    //[self reloadCard];
    [self.toolbar setHidden:YES];
}

- (void)initKxMenus {
    
    // Init save menu items
    kxSaveMenuItems =
    @[
      [KxMenuItem menuItem:@"Save and exit"
                     image:nil
                    target:self
                    action:@selector(saveAndExit)],
      
      [KxMenuItem menuItem:@"Save as..."
                     image:nil
                    target:self
                    action:@selector(saveAs)],
      
      [KxMenuItem menuItem:@"Export..."
                     image:nil
                    target:self
                    action:@selector(exportCards)],
      ];
    
    // Init export menu items
    UIImage *drive   = [UIImage imageNamed:@"drive.png"];
    UIImage *dropbox = [UIImage imageNamed:@"dropbox.png"];
    UIImage *custom  = [UIImage imageNamed:@"custom.png"];
    
    //scale 4.0 = 1/4 original image size
    //makes assumptions about original image sizes
    drive = [[LibraryAPI sharedInstance] scaleImage:drive withScale:16.0];
    dropbox=[[LibraryAPI sharedInstance] scaleImage:dropbox withScale:16.0];
    custom =[[LibraryAPI sharedInstance] scaleImage:custom withScale:8.0];
    
    kxExportMenuItems =
    @[
      
      [KxMenuItem menuItem:@"Export To..."
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"Google Drive"
                     image:drive
                    target:self
                    action:@selector(exportCardsToDestination:)],
      
      [KxMenuItem menuItem:@"Dropbox"
                     image:dropbox
                    target:self
                    action:@selector(exportCardsToDestination:)],
      ];
    
    // Init actions menu items
    kxActionsMenuItems =
    @[
      [KxMenuItem menuItem:@"Insert New Card"
                     image:nil
                    target:self
                    action:@selector(insertCard)],
      
      [KxMenuItem menuItem:@"Delete Current Card"
                     image:nil
                    target:self
                    action:@selector(deleteCard)],
      
      ];
}

- (void) hideKeyboard {
    
    [self.textArea resignFirstResponder];
}

- (void)registerForNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload {
    
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (IBAction)didPressActionsButton:(id)sender {
    
    [self.textArea resignFirstResponder];
    
    float verticalPadding = 0.0;
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        verticalPadding += 5;
    }
    // These values are completely hardcoded, which is probably bad
    // But scumbag apple didn't give UIBarButtonItems a frame or bounds property
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(self.view.frame.size.width * 7/8 - 32, self.navigationController.navigationBar.frame.size.height / 2,
                                      75, self.navigationController.navigationBar.frame.size.height + verticalPadding)
                 menuItems:kxActionsMenuItems];
}

- (IBAction)didPressActionsButtonNew:(id)sender {
    
    toolbar = [self createToolbar];
    [self.view addSubview:toolbar];
}

- (UIToolbar*)createToolbar {
    
    UIToolbar* bar = [[UIToolbar alloc] init];
    
    bar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Card" style:UIBarButtonItemStylePlain target:self action:@selector(insertCard)];
    
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithTitle:@"Remove Card" style:UIBarButtonItemStylePlain target:self action:@selector(deleteCard)];
    
    UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithTitle:@"Export Cards" style:UIBarButtonItemStylePlain target:self action:@selector(exportCards)];
    
    NSArray *buttonItems = [NSArray arrayWithObjects:addButton, removeButton, exportButton, nil];
    [bar setItems:buttonItems];
    
    return bar;
}

- (void)insertCard {
    
    if ([self.textArea.text isEqualToString:@""]) {
        // Don't do anything
    } else {
        [self saveCardTextToPresentation];
        self.cardIndex++;
        [self.presentation insertCardAtIndex:self.cardIndex];
        [self reloadCard];
        [self.textArea setText:@"\u2022 "];
    }
}

- (void)deleteCard {
    
    if (self.presentation.notecards.count > 1) {
        // self.cardIndex does not change
        [self.presentation.notecards removeObjectAtIndex:self.cardIndex];
        
        if (!(self.cardIndex < self.presentation.notecards.count)) {
            self.cardIndex--;
        }
        [self reloadCard];
    }
}

- (IBAction)nextCard:(id)sender {
    
    [self saveCardTextToPresentation];
    [super nextCard:sender];
}

- (IBAction)previousCard:(id)sender {
    
    [self saveCardTextToPresentation];
    [super previousCard:sender];
}

- (void)reloadCard {
    
    [super reloadCard];
}

- (void)saveCardTextToPresentation {
    
    [[self.presentation.notecards objectAtIndex:self.cardIndex] setText:self.textArea.text];
}

#pragma mark - save cards methods
- (IBAction)saveCards:(id)sender {
    
    [self saveCardTextToPresentation];
    
    [self.textArea resignFirstResponder];
    
    // If it hasn't been saved yet, since arrayIndex property gets set in the addPresentation:atIndex method
    if (!self.presentation.arrayIndex) {
        [[LibraryAPI sharedInstance] addPresentation:self.presentation atIndex:0];
    }
    else {
        // do nothing, the next line will save the presentation correctly.
    }
    [[LibraryAPI sharedInstance] savePresentations];
    [self showSaveMenu:sender];
}

- (void)showSaveMenu:(UIButton *)sender {
    
    float verticalPadding = 0.0;
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        verticalPadding += 5;
    }
    
    // These values are completely hardcoded, which is probably bad
    // But scumbag apple didn't give UIBarButtonItems a frame or bounds property
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(0  , self.navigationController.navigationBar.frame.size.height / 2,
                                      75, self.navigationController.navigationBar.frame.size.height + verticalPadding)
                 menuItems:kxSaveMenuItems];
}

- (void)saveAndExit {
    
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self popToRoot];
}

- (void)saveAs {
    
    /*  UIAlertView * dialog = [[UIAlertView alloc] initWithTitle:@"Save presentation as..."
     message:@" "
     delegate:self
     cancelButtonTitle:@"Cancel"
     otherButtonTitles:@"Save", nil];
     */
    //It turns out UIAlertView has been deprecated, so now using custom class from github
    // MZFormSheetController
    
    SaveAsViewController *saveAsController = [[SaveAsViewController alloc]
                                              initWithPlaceholderTextTitle:self.presentation.title
                                              description:self.presentation.description];
    
    saveAsController.delegate = self;
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:saveAsController];
    
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromBottom;
    formSheet.cornerRadius = 4.0;
    formSheet.portraitTopInset = 6.0;
    formSheet.landscapeTopInset = 0.0;
    formSheet.presentedFormSheetSize = CGSizeMake(300, 144);
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
}

#pragma mark - SaveAsViewControllerDelegate methods
- (void)saveDataAs:(SaveAsViewController *)saveAsController {
    
    [self.presentation setTitle:saveAsController.titleField.text];
    [self.presentation setDescription:saveAsController.descriptionField.text];
    // [self.presentationTitleNavBar setTitle:[self presentationTitle]];
    // For some reason, using the dot notation will make the title nav bar update
    // when the property changes, but the above notation will not.
    self.presentationTitleNavBar.title = self.presentation.title;
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

- (void)cancelSave:(SaveAsViewController *)saveasViewController {
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

- (void)exportCards {
    
    KxMenuItem *first = kxExportMenuItems[0];
    first.foreColor = [[[LibraryAPI sharedInstance] designManager] kxMenuTextColor];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:self.navigationController.navigationBar.frame
                 menuItems:kxExportMenuItems];
}

// This method is kind of useless.
- (void)exportCardsToDestination:(KxMenuItem *)sender{
    
    NSString *destination = sender.title;
    if ([destination isEqualToString:@"Google Drive"]) {
        [self exportPresentationToDrive];
    }
    else if ([destination isEqualToString:@"Dropbox"]) {
        [self exportPresentationToDropbox];
    }
}

- (void)exportPresentationToDrive {
    
    NSString *fileText = [self.presentation getPresentationInTextFormat];
    
    DriveFilesListViewController *testController = [[DriveFilesListViewController alloc] init];
    [testController uploadTextFileToGoogleDrive:fileText title:self.presentation.title];
}

- (void)exportPresentationToDropbox {
    
}

- (void) popToRoot {
    
// Code from before the sidebar was added; kind of the same as the new code.
//    UINavigationController *nav = (UINavigationController*) self.view.window.rootViewController;
//    ViewController *root = [nav.viewControllers objectAtIndex:0];
//    [root returnToRoot];
    
    ChooseCardsViewController *root = self.navigationController.viewControllers[0];
    [root returnToRoot];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification {
    
    // kbHeight gets "initialized" here because it needs the notification to get the kbHeight
    kbHeight = [self getKeyboardHeight:aNotification];
    
    CGRect frame = CGRectMake(self.textArea.frame.origin.x, self.textArea.frame.origin.y,
                              self.textArea.frame.size.width, self.textArea.frame.size.height-kbHeight);
    [self.textArea setFrame:frame];
    
    // This is so the automatic text resizing works right
    [self.navigationController setToolbarHidden:YES];
    [self resizeTextToFitScreen];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect frame = CGRectMake(self.textArea.frame.origin.x, self.textArea.frame.origin.y,
                              self.textArea.frame.size.width, self.textArea.frame.size.height+kbHeight);
    [self.textArea setFrame:frame];
    
    // This is so the automatic text resizing works right
    [self.navigationController setToolbarHidden:NO];
    [self resizeTextToFitScreen];
}

#pragma mark - rotation/orientation-related methods

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    //not sure why, but this fixes the glitch where it won't scroll after you rotate
    [self textViewDidChange:self.textArea];
}

- (float)getKeyboardHeight:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        return kbSize.width;
    }
    return kbSize.height;
    //You're probably wondering where the 25 came from. It came from fuck you, that's where.
    //You're probably wondering what 25 I'm talking about; again, fuck you, that's what.
}

#pragma mark - UITextView delegate methods and related methods

#pragma mark - methods for keyboard and textview notifications

// Whenever the text changes, the textView's size is updated (so it grows as more text
// is added), and it also scrolls to the cursor.
- (void)textViewDidChange:(UITextView *)textView {
    
    [self fixBulletFormatting];
    
    [self resizeTextToFitScreen];
    //CGRect frame = self.textArea.frame;
    // frame.size.height = self.textArea.contentSize.height+30;
    // self.textArea.frame = frame;
    
}

- (void)resizeTextToFitScreen {
    
    [super resizeTextToFitScreen];
}

// Basically this method just makes sure bullets show up when they're supposed to
- (void)fixBulletFormatting {
    
    [self.textArea setScrollEnabled:NO];
    
    NSRange cursorPosition = [self.textArea selectedRange];
    NSMutableString *textAreaContent = [[NSMutableString alloc] initWithString:[self.textArea text]];
    
    // if you love the length of your textAreaContent, return.
    // if there is only one bullet, you're not going to be able to backspace much of anything
    if (textAreaContent.length <3) {
        // then, make sure they're not deleting the original bullet
        // and don't waste time looking at the rest of this method and return
        self.textArea.text = @"\u2022 ";
        return;
    }
    
    // if the character before the cursor was a newline
    else if ([textAreaContent characterAtIndex:cursorPosition.location-1] == '\n') {
        // Then, add a bullet point AND space before cursor
        // (space is important because next conditional)
        NSMutableString *beforeCursor = [[NSMutableString alloc] initWithString:[textAreaContent substringToIndex:cursorPosition.location]];
        NSMutableString *afterCursor  = [[NSMutableString alloc] initWithString:[textAreaContent substringFromIndex:cursorPosition.location]];
        [beforeCursor setString:[beforeCursor stringByAppendingString:@"\u2022 "]];
        [self.textArea setText:[beforeCursor stringByAppendingString:afterCursor]];
        
        // Move cursor where it belongs
        [self.textArea setSelectedRange:NSMakeRange(beforeCursor.length, 0)];
    }
    // if the previous character is a bullet, then the user must have backspaced/deleted
    // the space that was added after the bullet, meaning they probably want to delete the bullet
    else if ([[textAreaContent substringWithRange:NSMakeRange(cursorPosition.location-1,1)]
              isEqualToString: @"\u2022"]) {
        // so, delete the bullet and the newline character at the same time, so
        // another bullet isn't generated.
        NSString *stringBeforeBullet = [textAreaContent substringToIndex:cursorPosition.location-2];
        NSString *stringAfterBullet  = [textAreaContent substringFromIndex:cursorPosition.location];
        self.textArea.text = [stringBeforeBullet stringByAppendingString:stringAfterBullet];
        [self.textArea setSelectedRange:NSMakeRange(stringBeforeBullet.length, 0)];
    }
    
    [self.textArea setScrollEnabled:YES];
}

- (void)textViewDidChangeSelection:(UITextView *)aTextView {
    
    //[self scrollToCursor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    //[self scrollToCursor];
}

- (void)textViewDidEndEditing:(UITextField *)textField {
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TO DO STILL:
// Allow individual cards to be deleted or inserted
// Allow existing card sets to be opened and edited
// Data validation:
// Make sure no deck name collisions; validate data in title/description fields.

@end
