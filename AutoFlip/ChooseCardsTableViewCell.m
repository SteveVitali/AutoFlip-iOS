//
//  ChooseCardsTableViewCell.m
//  AutoFlip
//
//  Created by Steve John Vitali on 2/5/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "ChooseCardsTableViewCell.h"
#import "LibraryAPI.h"
#import "FlatUIKit.h"

@implementation ChooseCardsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        DesignManager *designManager = [[LibraryAPI sharedInstance] designManager];
        // Configure cell design
        // Text colors
        [self.textLabel setTextColor:[designManager tableCellTextColor]];
        [self.detailTextLabel setTextColor:[designManager tableCellDetailColor]];
        // Background colors
        [self.contentView setBackgroundColor:[designManager tableCellBGColorNormal]];
        [self.backgroundView setBackgroundColor:[designManager tableCellBGColorNormal]];
        [self setBackgroundColor:[designManager tableCellBGColorNormal]];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    float inset = 8;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
