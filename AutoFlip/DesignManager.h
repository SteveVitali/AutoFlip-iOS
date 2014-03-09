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
@property (strong, nonatomic) UIColor *buttonBGColor;
@property (strong, nonatomic) UIColor *buttonShadowColor;
@property (strong, nonatomic) UIColor *buttonTextColorNormal;
@property (strong, nonatomic) UIColor *buttonTextColorHighlighted;
@property (nonatomic) float buttonShadowHeight;
@property (nonatomic) float buttonCornerRadius;
@property (nonatomic) float buttonFontSize;
// Other colors
@property (strong, nonatomic) UIColor *viewControllerBGColor;
@property (strong, nonatomic) UIColor *kxMenuTextColor;
@property (strong, nonatomic) UIColor *navigationBarTintColor;
// CardDeckViewController styling
@property (strong, nonatomic) UIColor *cardDeckViewControllerBGColor;
@property (strong, nonatomic) UIColor *cardDeckTextViewBGColor;
@property (strong, nonatomic) UIColor *textAreaFontColor;
// Table colors
@property (strong, nonatomic) UIColor *tableViewBGColor;
@property (strong, nonatomic) UIColor *tableCellBGColorNormal;
@property (strong, nonatomic) UIColor *tableCellBGColorSelected;
@property (strong, nonatomic) UIColor *tableCellTextColor;
@property (strong, nonatomic) UIColor *tableCellSeparatorColor;
@property (strong, nonatomic) UIColor *tableCellDetailColor;

// Text Sizes
@property (strong, nonatomic) NSNumber *maxNotecardFontSize;
@property (strong, nonatomic) NSNumber *minNotecardFontSize;

- (void)styleFlatUIButton:(FUIButton *)button;
- (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale;

@end
