//
//  UITextView+AutoResizeFont.m
//  AutoFlip
//
//  Created by Steve John Vitali on 2/1/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import "UITextView+AutoResizeFont.h"

@implementation UITextView (AutoResizeFont)

- (BOOL)sizeFontToFit:(NSString*)aString minSize:(float)aMinFontSize maxSize:(float)aMaxFontSize
{
    float kMaxFieldHeight = 9999;
    float fudgeFactor = 16.0;
    float fontSize = aMaxFontSize;
    
    self.font = [self.font fontWithSize:fontSize];
    
    CGSize tallerSize = CGSizeMake(self.frame.size.width-fudgeFactor,kMaxFieldHeight);
    CGSize stringSize = [aString sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
    
    while (stringSize.height >= self.frame.size.height)
    {
        if (fontSize <= aMinFontSize) // it just won't fit
            return NO;
        
        fontSize -= 1.0;
        self.font = [self.font fontWithSize:fontSize];
        tallerSize = CGSizeMake(self.frame.size.width-fudgeFactor,kMaxFieldHeight);
        stringSize = [aString sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    NSLog(@"help pls; font: %f; string: %#; string height: %f", fontSize, self.text, stringSize.height);
    
    return YES; 
}

@end
