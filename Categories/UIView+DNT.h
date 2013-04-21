//
//  UIView+DNT.h
//  You Owe Me Too
//
//  Created by Daniel Thorpe on 21/04/2013.
//  Copyright (c) 2013 Blinding Skies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DNT)

// SMFrameAdditions
// see https://gist.github.com/3412730
@property (nonatomic, assign) CGPoint dnt_origin;
@property (nonatomic, assign) CGSize dnt_size;
@property (nonatomic, assign) CGFloat dnt_x, dnt_y, dnt_width, dnt_height; // normal rect properties
@property (nonatomic, assign) CGFloat dnt_left, dnt_top, dnt_right, dnt_bottom; // these will stretch the rect

- (void)maskRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius;

- (void)removeRoundCornersMask;

@end
