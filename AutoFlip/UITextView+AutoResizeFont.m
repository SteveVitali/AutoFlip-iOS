//
//  UITextView+AutoResizeFont.m
//  AutoFlip
//
//  Created by Steve John Vitali on 2/1/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "UITextView+AutoResizeFont.h"

@implementation UITextView (AutoResizeFont)

- (BOOL)sizeFontToFitText:(NSString*)text minFontSize:(float)minFontSize maxFontSize:(float)maxFontSize verticalPadding:(float)padY
{
    float kMaxFieldHeight = 9999;
    float fudgeFactorX = 16.0;
    float fudgeFactorY = padY;
    float fontSize = maxFontSize;
    
    self.font = [self.font fontWithSize:fontSize];
    
    CGSize tallerSize = CGSizeMake(self.frame.size.width-fudgeFactorX,kMaxFieldHeight);
    CGSize stringSize = [text sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
    
    while (stringSize.height >= self.frame.size.height - fudgeFactorY)
    {
        if (fontSize <= minFontSize) // it just won't fit
            return NO;
        
        fontSize -= 1.0;
        self.font = [self.font fontWithSize:fontSize];
        tallerSize = CGSizeMake(self.frame.size.width-fudgeFactorX,kMaxFieldHeight);
        stringSize = [text sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    NSLog(@"padY: %f; font: %f; string: %@; string height: %f", padY, fontSize, self.text, stringSize.height);
    
    return YES; 
}

@end
