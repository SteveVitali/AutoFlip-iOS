//
//  UITextView+AutoResizeFont.h
//  AutoFlip
//
//  Created by Steve John Vitali on 2/1/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (AutoResizeFont)

- (BOOL)sizeFontToFit:(NSString*)aString minSize:(float)aMinFontSize maxSize:(float)aMaxFontSize;

@end
