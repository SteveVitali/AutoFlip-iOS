//
//  ColorManager.h
//  AutoFlip
//
//  Created by Steve John Vitali on 1/26/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+FlatUI.h"

@interface DesignManager : NSObject

// Button and text colors
@property UIColor *buttonBGColor;
@property UIColor *buttonShadowColor;
@property UIColor *buttonTextColorNormal;
@property UIColor *buttonTextColorHighlighted;
// Other colors
@property UIColor *homeScreenBGColor;
@property UIColor *kxMenuTextColor;
// Table colors
@property UIColor *tableCellBGColorNormal;
@property UIColor *tableCellBGColorSelected;
@property UIColor *tableCellTextColor;
@property UIColor *tableCellSeparatorColor;
@property UIColor *tableCellDetailColor;

// Text Sizes
@property NSNumber *presentTextSize;
@property NSNumber *editorTextSize;

@end
