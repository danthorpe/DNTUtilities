//
//  UIColor+DNT.h
//  You Owe Me Too
//
//  Created by Daniel Thorpe on 13/04/2013.
//  Copyright (c) 2013 Blinding Skies. All rights reserved.
//

#import <UIKit/UIKit.h>

extern inline UIColor * DNTUIColorFromRGB(NSInteger rgbValue);

@interface UIColor (DNT)

/**
 * @abstract
 * Utility class method to get a color based on
 * an objects memory location.
 */
+ (UIColor *)colorForObject:(id<NSObject>)object;

@end

@interface NSObject (UIColorAdditions)

/**
 * @abstract
 * Get a color which represents the receiver's
 * location in memory. Very handy for debugging
 * layout of subviews.
 */
- (UIColor *)dnt_color;

@end
