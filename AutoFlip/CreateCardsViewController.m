//
//  CreateCardsViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "CreateCardsViewController.h"
#import "Notecard.h"
#import "KxMenu.h"
#import "ViewController.h"

@interface CreateCardsViewController () {
    
    float kbHeight;
}
- (void)saveAndExit;
- (void)saveAs;
- (void)exportCards;
@end

@implementation CreateCardsViewController {
    
    NSInteger cardIndex;
    NSInteger heightOfNavAndButtons;
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
	// Do any additional setup after loading the view.
    self.presentation = [[Presentation alloc] init];
    [self.presentation addCardAtIndex:0];
    
    // Set presentation title and description from stuff passed through segue
    // I understand this code looks hilarious, but it works, damnit.
    self.presentation.title = self.presentationTitle;
    self.presentation.description = self.presentationDescription;
    self.presentationTitleNavBar.title = self.presentationTitle;
    
    [self registerForNotifications];
    [self.textArea setDelegate:self];
    [self.textArea setText:@"\u2022 "];
    
    [self.scrollView setDelegate:self];
    
    // hardcoding it because not sure how to get programmatically
    // for some reason self.presentationNavBar.frame.height doesn't work
    heightOfNavAndButtons = 86;
}

- (void)registerForNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
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

- (IBAction)nextCard:(id)sender {
    
    [super nextCard:sender];
    //if this card is the last one in the deck so far
    if (self.cardIndex == [self.presentation.notecards count] - 1) {
        self.cardIndex++;
        [self.presentation addCardAtIndex:self.cardIndex];
        [self reloadCard];
        [self.textArea setText:@"\u2022 "];
    }
}

- (IBAction)previousCard:(id)sender {
    
    [super previousCard:sender];
    
}

- (void)reloadCard {
    
    [super reloadCard];
}

#pragma mark - save cards methods
- (IBAction)saveCards:(id)sender {
    
    [self.textArea resignFirstResponder];
    Notecard *card = [self.presentation.notecards objectAtIndex:self.cardIndex];
    card.text = [self.textArea text];

    [self showSaveMenu:sender];
}

- (void)showSaveMenu:(UIButton *)sender {
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Save"
                     image:nil
                    target:nil
                    action:NULL],
      
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
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:self.textArea.frame//fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)saveAndExit {
    NSLog(@"asdf");
    [self popToRoot];
}

- (void)saveAs {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"Save presentation as..."
                                                    delegate:self cancelButtonTitle:@"Save"
                                           otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    UITextField * titleField = [alert textFieldAtIndex:0];
    titleField.keyboardType = UIKeyboardTypeAlphabet;
    titleField.placeholder = self.presentation.title;
    
    UITextField * descriptionField = [alert textFieldAtIndex:1];
    descriptionField.keyboardType = UIKeyboardTypeAlphabet;
    descriptionField.secureTextEntry = NO;
    descriptionField.placeholder = self.presentation.description;

    [alert show];
    [self.presentation setTitle:titleField.text];
    [self.presentation setDescription:descriptionField.text];
}

- (void)exportCards {
    
}

- (void) popToRoot {
    
    UINavigationController *nav = (UINavigationController*) self.view.window.rootViewController;
    ViewController *root = [nav.viewControllers objectAtIndex:0];
    [root returnToRoot];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    // kbHeight gets "initialized" here because it needs the notification to get the kbHeight
    kbHeight = [self getKeyboardHeight:aNotification];
    self.scrollView.frame = CGRectMake(self.view.frame.origin.x,
                                       self.view.frame.origin.y + heightOfNavAndButtons,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height-kbHeight-heightOfNavAndButtons);
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"this runs keyboard will hide");
    // Make it bigger again:
    self.scrollView.frame = CGRectMake(self.view.frame.origin.x,
                                       self.view.frame.origin.y + heightOfNavAndButtons,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height - heightOfNavAndButtons);
    
}

#pragma mark - rotation/orientation-related methods

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration {
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    self.scrollView.frame = frame;
    self.scrollView.bounds = frame;
    self.scrollView.contentSize = CGSizeMake(frame.size.width * 2, frame.size.height);
}

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

// found most of this method on stackoverflow
// should be called in textViewDidChange: and textViewDidChangeSelection:
- (void)scrollToCursor {
    
    int verticalPaddingBecauseFuckYou;
    // if there is a selection cursor
    if (self.textArea.selectedRange.location != NSNotFound) {
        
        float verticalSpace = self.view.frame.size.height - heightOfNavAndButtons - kbHeight - 10;
        if (self.textArea.contentSize.height > verticalSpace) {
            
            UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
            if (UIInterfaceOrientationIsLandscape(orient)){
                verticalPaddingBecauseFuckYou = 112;
            } else {
                verticalPaddingBecauseFuckYou = 64;
            }
            //NSLog(@"frame size height %f",self.view.frame.size.height);
            // work out how big the text view would be if the text only went up to the cursor
            NSRange range;
            range.location = self.textArea.selectedRange.location;
            range.length = self.textArea.text.length - range.location;
            NSString *string =
                      [self.textArea.text stringByReplacingCharactersInRange:range withString:@""];
            CGSize size = [string sizeWithFont:self.textArea.font
                             constrainedToSize:self.textArea.bounds.size
                                 lineBreakMode:NSLineBreakByWordWrapping];
            
            // work out where that position would be relative to the textView's frame
            CGRect viewRect = self.textArea.frame;
            int scrollHeight = viewRect.origin.y + size.height;
            //NSLog(@"scrollHeight: %d",scrollHeight);
            
            // scroll to it,
            // but not with scrollRectToVisible because it sucks and fuck you scrollRectToVisible
            // [self.scrollView scrollRectToVisible:finalRect animated:YES];
            // CGRect finalRect = CGRectMake(0, scrollHeight, 1, 32);
            
            CGPoint point = CGPointMake(1, scrollHeight - kbHeight + verticalPaddingBecauseFuckYou);
            [self.scrollView setContentOffset:point animated: YES];
        }
    }
}


// scrollview delegate method
// disallow horizontal scrolling in the textview
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if (sender.contentOffset.x != 0) {
        //CGPoint offset = sender.contentOffset;
        //offset.x = 0;
        //sender.contentOffset = offset;
    }
}

#pragma mark - UITextView delegate methods and related methods

#pragma mark - methods for keyboard and textview notifications

// Whenever the text changes, the textView's size is updated (so it grows as more text
// is added), and it also scrolls to the cursor.
- (void)textViewDidChange:(UITextView *)textView {
    
    [self fixBulletFormatting];

    float verticalHeightLeftOver = heightOfNavAndButtons + self.view.frame.size.height - kbHeight;
    if (self.textArea.contentSize.height > verticalHeightLeftOver) {
        
    self.textArea.frame = CGRectMake(self.textArea.frame.origin.x,
                                    self.textArea.frame.origin.y,
                                    self.textArea.frame.size.width,
                                    self.textArea.contentSize.height);
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,
                                             self.textArea.frame.size.height+50);
    [self scrollToCursor];
    
    
    //CGSize temp = self.textArea.frame.size;
    //NSLog(@"dimensions of textaview: %f %f", temp.width, temp.height);

}

// Basically this method just makes sure bullets show up when they're supposed to
- (void)fixBulletFormatting {
    
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
        [textAreaContent setString:[self.textArea.text stringByAppendingString:@"\u2022 "]];
        [self.textArea setText:textAreaContent];
        cursorPosition.location++;
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
    }
}

- (void)textViewDidChangeSelection:(UITextView *)aTextView {
    
    [self scrollToCursor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    [self scrollToCursor];
}

- (void)textViewDidEndEditing:(UITextField *)textField {
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* in case these come in handy later:
 NSLog(@"self.view frame: origin(%f, %f), dims(%f, %f)",
 self.view.bounds.origin.x, self.view.bounds.origin.y,
 self.view.bounds.size.width, self.view.bounds.size.height);
 
 NSLog(@"self.scrollview frame: origin(%f, %f), dims(%f, %f)",
 self.scrollView.frame.origin.x, self.scrollView.frame.origin.y,
 self.scrollView.frame.size.width, self.scrollView.frame.size.height);
 
 
 NSLog(@"self.textArea frame: origin(%f, %f), dims(%f, %f)",
 self.textArea.frame.origin.x, self.textArea.frame.origin.y,
 self.textArea.frame.size.width, self.textArea.frame.size.height);
 
 NSLog(@"self.textArea.contentSize frame: origin(%f, %f)",
 self.textArea.contentSize.width, self.textArea.contentSize.height );
 
 */


//TO DO STILL:
// allow deck title to be added for presentation deck
//   Allow deck title to be edited
// Allow individual cards to be deleted
// Allow existing card sets to be opened and edited
// Data validation:
    // Make sure no deck name collisions; validate data in title/description fields.

@end
