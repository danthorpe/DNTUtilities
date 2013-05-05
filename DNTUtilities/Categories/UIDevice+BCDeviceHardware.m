//
//  UIDevice+DNT.m
//  Daniel Thorpe
//
//  Created by Daniel Thorpe on 02/05/2013.
//  Copyright (c) 2013 Badoo Ltd. All rights reserved.
//

#import "UIDevice+DNT.h"

#include <sys/types.h>
#include <sys/sysctl.h>
 
@implementation UIDevice (DNT)

- (NSString *)deviceName {
    size_t size = 100;
    char *hw_machine = malloc(size);
    int name[] = {CTL_HW,HW_MACHINE};
    sysctl(name, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    return hardware;
}

- (NSString *)prettyDeviceName {
    NSString *deviceName = [self deviceName];
    return [self prettyNameForDeviceName:deviceName];
}

- (NSString *)prettyNameForDeviceName:(NSString *)deviceName {

    NSString *prettyName = @"Unknown Device";

    if ([deviceName isEqualToString:@"iPhone3,1"] ||
        [deviceName isEqualToString:@"iPhone3,2"] ||
        [deviceName isEqualToString:@"iPhone3,3"] ) {

        prettyName = @"iPhone 4";

    } else if ([deviceName isEqualToString:@"iPhone5,1"] ||
               [deviceName isEqualToString:@"iPhone5,2"]) {

        prettyName = @"iPhone 5";

    } else if ([deviceName isEqualToString:@"iPhone4,1"] ||
               [deviceName isEqualToString:@"iPhone4,2"]) {

        prettyName = @"iPhone 4S";

    } else if ([deviceName isEqualToString:@"iPhone2,1"]) {

        prettyName = @"iPhone 3GS";
        
    } else if ([deviceName isEqualToString:@"iPad3,4"] ||
               [deviceName isEqualToString:@"iPad3,5"] ||
               [deviceName isEqualToString:@"iPad3,6"]) {

        prettyName = @"iPad 4";
        
    } else if ([deviceName rangeOfString:@"iPad3"].location != NSNotFound) {

        prettyName = @"iPad 3";

    } else if ([deviceName isEqualToString:@"iPad2,5"] ||
               [deviceName isEqualToString:@"iPad2,6"]) {

        prettyName = @"iPad Mini";

    } else if ([deviceName rangeOfString:@"iPad2"].location != NSNotFound) {

        prettyName = @"iPad 2";

    } else if ([deviceName rangeOfString:@"iPad1"].location != NSNotFound) {

        prettyName = @"iPad 1";
        
    } else if ([deviceName rangeOfString:@"iPod5"].location != NSNotFound) {

        prettyName = @"iPod Touch 5";

    } else if ([deviceName rangeOfString:@"iPod4"].location != NSNotFound) {

        prettyName = @"iPod Touch 4";
        
    } else if ([deviceName isEqualToString:@"i386"] ||
               [deviceName isEqualToString:@"x86_64"]) {

        prettyName = @"Simulator";

    } else if ([deviceName isEqualToString:@"iPhone1,2"]) {

        prettyName = @"iPhone 3G";

    } else if ([deviceName isEqualToString:@"iPhone1,1"]) {

        prettyName = @"iPhone Original";

    } else if ([deviceName rangeOfString:@"iPhone"].location != NSNotFound) {

        prettyName = @"Unknown iPhone Device";
        
    } else if ([deviceName rangeOfString:@"iPad"].location != NSNotFound) {

        prettyName = @"Unknown iPad Device";

    } else if ([deviceName rangeOfString:@"iPod"].location != NSNotFound) {

        prettyName = @"Unknown iPod Device";

    }

    return prettyName;
}

@end
