//
//  CardDeckTableCell.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "CardDeckTableCell.h"
#import "UIColor+FlatUI.h"

@implementation CardDeckTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    // The code below is duplicated in the tableView cellForIndexSomethingSomething
    // method in the ChooseCardsViewController; should probably fix that;
    if (self.selected) {
        [self.chooseButton setHidden:NO];
        self.title.textColor = [UIColor turquoiseColor];
        self.chooseButton.titleLabel.textColor = [UIColor turquoiseColor];
        self.chooseButton.titleLabel.text = @">";
    } else {
        [self.chooseButton setHidden:YES];
        [self.title setTextColor:[UIColor cloudsColor]];
        [self.chooseButton.titleLabel setTextColor:[UIColor cloudsColor]];
    }
}

@end
