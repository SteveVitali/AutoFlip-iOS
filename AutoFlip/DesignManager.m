//
//  ColorManager.m
//  AutoFlip
//
//  Created by Steve John Vitali on 1/26/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "DesignManager.h"
#import "UIColor+FlatUI.h"
#import "FUIButton.h"
#import "UIFont+FlatUI.h"

@implementation DesignManager

- (id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)styleFlatUIButton:(FUIButton *)button {
    
    button.buttonColor = [self buttonBGColor];
    button.shadowColor = [self buttonShadowColor];//[UIColor greenSeaColor];
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[self buttonTextColorNormal] forState:UIControlStateNormal];
    [button setTitleColor:[self buttonTextColorHighlighted] forState:UIControlStateHighlighted];
}

@end
