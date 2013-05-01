//
//  CALayer+DNT.m
//  You Owe Me Too
//
//  Created by Daniel Thorpe on 21/04/2013.
//  Copyright (c) 2013 Blinding Skies. All rights reserved.
//

#import "CALayer+DNT.h"

@implementation CALayer (DNT)

+ (id)maskLayerWithCorners:(UIRectCorner)corners radii:(CGSize)radii frame:(CGRect)frame {

    // Create a CAShapeLayer
    CAShapeLayer *mask = [CAShapeLayer layer];

    // Set the frame
    mask.frame = frame;

    // Set the CGPath from a UIBezierPath
    mask.path = [UIBezierPath bezierPathWithRoundedRect:mask.bounds byRoundingCorners:corners cornerRadii:radii].CGPath;

    // Set the fill color
    mask.fillColor = [UIColor whiteColor].CGColor;

    return mask;
}

@end
