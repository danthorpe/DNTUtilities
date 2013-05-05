//
//  UIDevice+DNT.h
//  Daniel Thorpe
//
//  Created by Daniel Thorpe on 02/05/2013.
//  Copyright (c) 2013 Badoo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (DNT)

/// @return a NSString instance containing the device name.
- (NSString *)deviceName;

/// @return a NSString instance containing the pretty device name.
- (NSString *)prettyDeviceName;

@end
