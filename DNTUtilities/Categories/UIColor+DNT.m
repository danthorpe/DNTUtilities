//
//  UIColor+DNT.m
//  You Owe Me Too
//
//  Created by Daniel Thorpe on 13/04/2013.
//  Copyright (c) 2013 Blinding Skies. All rights reserved.
//

#import "UIColor+DNT.h"

inline UIColor * DNTUIColorFromRGB(NSInteger rgbValue) {
    return [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

@implementation UIColor (DNT)

+ (UIColor *)colorForObject:(id<NSObject>)object {
    return [UIColor colorWithRed: (((int)object) & 0xFF) / 255.0
                           green: (((int)object >> 8) & 0xFF) / 255.0
                            blue: (((int)object >> 16) & 0xFF) / 255.0
                           alpha: 1.0];
}

@end

@implementation NSObject (UIColorAdditions)

- (UIColor *)dnt_color {
    return [UIColor colorForObject:self];
}

@end


