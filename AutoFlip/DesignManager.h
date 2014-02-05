//
//  ColorManager.h
//  AutoFlip
//
//  Created by Steve John Vitali on 1/26/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+FlatUI.h"
#import "FUIButton.h"

@interface DesignManager : NSObject

@property UIColor *primaryAccentColor;

// Button and text colors
@property UIColor *buttonBGColor;
@property UIColor *buttonShadowColor;
@property UIColor *buttonTextColorNormal;
@property UIColor *buttonTextColorHighlighted;
@property float buttonShadowHeight;
@property float buttonCornerRadius;
@property float buttonFontSize;
// Other colors
@property UIColor *homeScreenBGColor;
@property UIColor *cardDeckViewControllerBGColor;
@property UIColor *cardDeckTextViewBGColor;
@property UIColor *kxMenuTextColor;
@property UIColor *navigationBarTintColor;
// Table colors
@property UIColor *tableCellBGColorNormal;
@property UIColor *tableCellBGColorSelected;
@property UIColor *tableCellTextColor;
@property UIColor *tableCellSeparatorColor;
@property UIColor *tableCellDetailColor;

// Text Sizes
@property NSNumber *maxNotecardFontSize;
@property NSNumber *minNotecardFontSize;

- (void)styleFlatUIButton:(FUIButton *)button;
- (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale;

@end
