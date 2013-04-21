//
//  UIView+DNT.m
//  You Owe Me Too
//
//  Created by Daniel Thorpe on 21/04/2013.
//  Copyright (c) 2013 Blinding Skies. All rights reserved.
//

#import "UIView+DNT.h"
#import "CALayer+DNT.h"

@implementation UIView (DNT)

- (void)maskRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    // To round all corners, we can just set the radius on the layer
    if ( corners == UIRectCornerAllCorners ) {
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES;
    } else {
        // If we want to choose which corners we want to mask then
        // it is necessary to create a mask layer.
        self.layer.mask = [CALayer maskLayerWithCorners:corners radii:CGSizeMake(radius, radius) frame:self.bounds];
    }
}

- (void)removeRoundCornersMask {
    self.layer.cornerRadius = 0.f;
    self.layer.mask = nil;
}

// SMFrame Additions
- (CGPoint)dnt_origin {
    return self.frame.origin;
}

- (void)setDnt_origin:(CGPoint)origin {
    self.frame = (CGRect){ .origin=origin, .size=self.frame.size };
}

- (CGFloat)dnt_x {
    return self.frame.origin.x;
}

- (void)setDnt_x:(CGFloat)x {
    self.frame = (CGRect){ .origin.x=x, .origin.y=self.frame.origin.y, .size=self.frame.size };
}

- (CGFloat)dnt_y {
    return self.frame.origin.y;
}

- (void)setDnt_y:(CGFloat)y {
    self.frame = (CGRect){ .origin.x=self.frame.origin.x, .origin.y=y, .size=self.frame.size };
}

- (CGSize)dnt_size {
    return self.frame.size;
}

- (void)setDnt_size:(CGSize)size {
    self.frame = (CGRect){ .origin=self.frame.origin, .size=size };
}

- (CGFloat)dnt_width {
    return self.frame.size.width;
}

- (void)setDnt_width:(CGFloat)width {
    self.frame = (CGRect){ .origin=self.frame.origin, .size.width=width, .size.height=self.frame.size.height };
}

- (CGFloat)dnt_height {
    return self.frame.size.height;
}

- (void)setDnt_height:(CGFloat)height {
    self.frame = (CGRect){ .origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=height };
}

- (CGFloat)dnt_left {
    return self.frame.origin.x;
}

- (void)setDnt_left:(CGFloat)left {
    self.frame = (CGRect){ .origin.x=left, .origin.y=self.frame.origin.y, .size.width=fmaxf(self.frame.origin.x+self.frame.size.width-left,0), .size.height=self.frame.size.height };
}

- (CGFloat)dnt_top {
    return self.frame.origin.y;
}

- (void)setDnt_top:(CGFloat)top {
    self.frame = (CGRect){ .origin.x=self.frame.origin.x, .origin.y=top, .size.width=self.frame.size.width, .size.height=fmaxf(self.frame.origin.y+self.frame.size.height-top,0) };
}

- (CGFloat)dnt_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setDnt_right:(CGFloat)right {
    self.frame = (CGRect){ .origin=self.frame.origin, .size.width=fmaxf(right-self.frame.origin.x,0), .size.height=self.frame.size.height };
}

- (CGFloat)dnt_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setDnt_bottom:(CGFloat)bottom {
    self.frame = (CGRect){ .origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=fmaxf(bottom-self.frame.origin.y,0) };
}


@end
