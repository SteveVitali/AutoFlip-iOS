//
//  UITextView+AutoResizeFont.h
//  AutoFlip
//
//  Created by Steve John Vitali on 2/1/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (AutoResizeFont)

- (BOOL)sizeFontToFitText:(NSString*)text minFontSize:(float)minFontSize maxFontSize:(float)maxFontSize verticalPadding:(float)padY;
@end
