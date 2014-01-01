//
//  CreateCardsViewController.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/31/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "CreateCardsViewController.h"
#import "Notecard.h"

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
    self.presentation = [[Presentation alloc] init];
    [self.presentation addCardAtIndex:0];
    self.textArea.text = @"";
    
    [self registerForNotifications];
    if (self.presentation.notecards) NSLog(@"self presentation notecards");
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
        [self.textArea setText:@"\u2022 "];
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
    Notecard *card = [self.presentation.notecards objectAtIndex:self.cardIndex];
    card.text = [self.textArea text];
    if (card) {
        NSLog(@"not null %@", self.textArea.text);
    }
    NSLog(@"above^ %d", self.cardIndex);
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

//TO DO STILL:
//allow backspacing the bullet points
//allow deck title to be added for presentation deck
//get progress bar working

@end
