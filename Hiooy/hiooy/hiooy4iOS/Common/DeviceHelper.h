//
//  DeviceHelper.h
//  KKMYForU
//
//  Created by Xia Zhiyong on 13-11-27.
//  Copyright (c) 2013年 cookov. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "OpenUDID.h"
//#import "IPAddress.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

enum UIDeviceFamily {
    UIDeviceFamilyiPhone = 0,
    UIDeviceFamilyiPod = 1,
    UIDeviceFamilyiPad,
    UIDeviceFamilyUnknown
};


@interface DeviceHelper : NSObject

//+ (NSString *)getOpenUDID;
+ (NSString *)getMacAddress;
+ (NSString *)getCurrentIOSVersion;
+ (NSString *)getDeviceVersion;
//+ (NSString *)getCurrentIpAddress;

+ (NSString *)modelName;                // 获取设备型号(较全)
+ (enum UIDeviceFamily)deviceFamily;    //

// 2013.11.27
+ (NSString *)getDeviceID;  // 获取设备唯一标识

// 判断当前设备可否打电话
+ (BOOL)deviceCanCallOrNot;

@end
