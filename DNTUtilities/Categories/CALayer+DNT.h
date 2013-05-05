//
//  CALayer+DNT.h
//  Daniel Thorpe
//
//  Created by Daniel Thorpe on 21/04/2013.
//  Copyright (c) 2013 Blinding Skies. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (DNT)

+ (id)maskLayerWithCorners:(UIRectCorner)corners radii:(CGSize)radii frame:(CGRect)frame;

@end
