//
//  NSString+Utils.h
//  KKMYForU
//
//  Created by 黄磊 on 13-10-31.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utils)

// 检查电话号
- (BOOL)checkPhoneNum;
// 检查手机号
- (BOOL)checkMobileNum;
// 检查邮箱号
- (BOOL)checkMailAddress;
// 转换成带星星的电话号
- (NSString *)convertToCoverTel;
// 计算以小时为单位的时间
+ (NSString *)getHourWithMinute:(float)minute;
// 计算字符串高度
- (float)heightWithFont:(UIFont *)font andWidth:(float)width;
- (float)calculateHeightWithFont:(UIFont *)font andWidth:(float)width;  // 已无地方调用
// 版本号检查
- (BOOL)isNewThanVersion:(NSString *)oldVersion;
// 时间戳转换
- (NSString *)convertToTimeString;

+ (NSString *)generateUniqueId;
+ (NSString *)getDocumentLocation;
+ (NSString *)getTempLocation;
+ (NSString *)getImageLocation;
/*
+ (NSString *)getAvatarLocation;
+ (NSString *)getAudioLocation;
+ (NSString*)getLaunchImage;
*/
+ (NSString *)timestampConvertString:(long long)time;
+ (NSString *)timeStringConvert:(NSString *)time;
+ (NSString *)halfHourAfterCurrentTime;
+ (NSString *)oneDayAfterCurrentTime;
+ (NSString *)oneDayBeforeCurrentTime;
+ (NSString *)timestampConvertString:(long long)time dataFormat:(NSString *)dataFormat;


@end
