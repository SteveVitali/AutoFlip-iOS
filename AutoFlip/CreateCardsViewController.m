//
//  CreateCardsViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "CreateCardsViewController.h"

@interface CreateCardsViewController ()

@end

@implementation CreateCardsViewController {
    NSInteger cardIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self registerForNotifications];
    [self.textArea setDelegate:self];
    [self.textArea setText:@"\u2022 "];
}

- (IBAction)nextCard:(id)sender {
    [super nextCard:sender];
    //if this card is the last one in the deck so far
    if (self.cardIndex == [self.presentation.notecards count] - 1) {
        self.cardIndex++;
        [self.presentation addCardAtIndex:self.cardIndex];
        [self reloadCard];
    }
}

- (IBAction)previousCard:(id)sender {
    [super previousCard:sender];
    
}

- (void)reloadCard {
    [super reloadCard];
    
}

- (IBAction)saveCards:(id)sender {
    [self.textArea resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                           selector:@selector (textAreaEdited)
                               name:UITextViewTextDidChangeNotification
                             object:self.textArea];
}

- (void)textAreaEdited
{
    NSRange cursorPosition = [self.textArea selectedRange];
    NSMutableString *textAreaContent = [[NSMutableString alloc] initWithString:[self.textArea text]];
    
    if ([textAreaContent characterAtIndex:cursorPosition.location-1] == '\n') {
        [textAreaContent setString:[self.textArea.text stringByAppendingString:@"\u2022 "]];
        [self.textArea setText:textAreaContent];
        cursorPosition.location++;
        NSLog(@"yeeeee");
    }
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{

}

- (void)textViewDidBeginEditing:(UITextField *)textField
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}



@end
