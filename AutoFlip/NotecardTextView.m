//
//  NotecardTextView.m
//  AutoFlip
//
//  Created by Steve John Vitali on 3/6/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "NotecardTextView.h"
#import "LibraryAPI.h"

@implementation NotecardTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithText:(NSString *)text {
    
    self = [super init];
    
    if (self) {
        self.backgroundColor =[[[LibraryAPI sharedInstance] designManager] cardDeckTextViewBGColor];
        self.textColor = [[[LibraryAPI sharedInstance] designManager] textAreaFontColor];
        self.editable = NO;
        [self.layer setCornerRadius:2.0f];
        [self.layer setMasksToBounds:YES];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.text = text;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
