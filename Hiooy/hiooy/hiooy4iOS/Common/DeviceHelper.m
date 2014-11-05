//
//  DeviceHelper.m
//  KKMYForU
//
//  Created by Xia Zhiyong on 13-11-27.
//  Copyright (c) 2013年 cookov. All rights reserved.
//

#import "DeviceHelper.h"

@implementation DeviceHelper


//+ (NSString *)getOpenUDID
//{
//    NSString *openUDIDStr = [OpenUDID value];
//    return openUDIDStr;
//}

+ (NSString *)getMacAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (NSString *)getCurrentIOSVersion
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return [NSString stringWithFormat:@"iPhone OS %.1f",version];
}

+ (NSString *)getDeviceVersion
{
    NSString* platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (China, no WiFi possibly)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (AT+T)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (Other carrier)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (Other carrier)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod2,2"])   return @"iPod Touch 2.5G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G WiFi";
    if ([platform isEqualToString:@"iPad1,2"])   return @"iPad 1G 3G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 2G";
    
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    return platform;
}

+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

//+ (NSString *)getCurrentIpAddress
//{
//    InitAddresses();
//    GetIPAddresses();
//    GetHWAddresses();
//    return [NSString stringWithFormat:@"%s", ip_names[1]];
//}


/***************************************************/


+ (NSString *)getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

+ (NSString *)modelIdentifier
{
    return [self getSysInfoByName:"hw.machine"];
}

+ (NSString *)modelName
{
    NSString *platform = [self modelIdentifier];
    
    // iPhone http://theiphonewiki.com/wiki/IPhone
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev A)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (Global)";
    
    if ([platform hasPrefix:@"iPhone"])             return @"Unknown iPhone";
    
    // iPad http://theiphonewiki.com/wiki/IPad
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (Rev A)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (Gloabl)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (Gloabl)";
    
    // iPad Mini http://theiphonewiki.com/wiki/IPad_mini
    
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad mini 1G (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad mini 1G (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad mini 1G (Global)";
    
    if ([platform hasPrefix:@"iPad"])               return @"Unknown iPad";
    
    // iPod http://theiphonewiki.com/wiki/IPod
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod touch 5G";
    
    if ([platform hasPrefix:@"iPod"])               return @"Unknown iPod";
    
    // Simulator
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = ([[UIScreen mainScreen] bounds].size.width < 768.0);
        return (smallerScreen ? @"iPhone Simulator" : @"iPad Simulator");
    }
    
    return @"Unknown Device";
}

+ (enum UIDeviceFamily)deviceFamily
{
    NSString *platform = [self modelIdentifier];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    return UIDeviceFamilyUnknown;
}


/******************************************************************/


+ (NSString *)getDeviceID {

    if (__CUR_IOS_VERSION >= __IPHONE_7_0) {
        NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
        return [uuid UUIDString];
    }else {
        return [self getMacAddress];
    }
    
}


+ (BOOL)deviceCanCallOrNot {

    NSString *deviceType = [UIDevice currentDevice].model;
    NSLog(@"DeviceModel:%@", deviceType);
//    NSString *deviceType = [UIDevice currentDevice].modellocalizedModel;
    
    if([deviceType isEqualToString:@"iPod touch"]
       ||[deviceType isEqualToString:@"iPad"]
       ||[deviceType isEqualToString:@"iPhone Simulator"]) {
    
        return NO;
        
    }else {
    
        return YES;
        
    }
    
}



@end
