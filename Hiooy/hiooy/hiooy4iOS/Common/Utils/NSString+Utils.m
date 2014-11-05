//
//  NSString+Utils.m
//  KKMYForU
//
//  Created by 黄磊 on 13-10-31.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//

#import "NSString+Utils.h"

#define ONE_DATE_TIME (24 * 60 * 60)

#define TWO_DATE_TIME (2 * ONE_DATE_TIME)

#define THREE_DATE_TIME (3 * ONE_DATE_TIME)

#define CUR_TIMEZONE (8 * 60 * 60)

// 本地音频存储路径
static NSString *locDocumentPath = nil;
// 本地音频存储路径
static NSString *locAudioPath = nil;
// 本地图片存储路径
static NSString *locImagePath = nil;
// 本地头像存储路径
static NSString *locAvatarPath = nil;
// 本地临时文件存储路径
static NSString *locTempPath = nil;
//  本地启动页图片
static NSString *launchImagePath = nil;

@implementation NSString (Utils)

- (BOOL)checkPhoneNum
{
    if (self.length > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)checkMobileNum
{
    if ([self length] <= 0) {
        return NO;
    }
    if ([self length] != 11) {
        return NO;
    }
    
#ifdef DEVELOPING
    return YES;
#endif
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)checkMailAddress
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

// 转换成带星星的电话号
- (NSString *)convertToCoverTel
{
    NSString *telCover = nil;
    //    if ([aTel checkPhoneNum]) {
    telCover = [NSString stringWithFormat:@"%@****%@", [self substringToIndex:3], [self substringFromIndex:7]];
    //    }
    return telCover;
}

+ (NSString *)getHourWithMinute:(float)minute
{
    if (minute < 60) {
        return @"<1";
    }
    int hour = minute / 60;
    return [NSString stringWithFormat:@"%d", hour];
}

- (float)heightWithFont:(UIFont *)font andWidth:(float)width
{
    float height = 0;
    float theHeight = 0;
    NSArray *array = [self componentsSeparatedByString:@"\n"];
    for (NSString *str in array) {
        if (str == nil || [str isEqualToString:@""] == YES) {
            CGSize size = textSizeWithFont(@"test", font);
            theHeight = size.height;
            height += theHeight;
            continue;
        }
        CGSize size = textSizeWithFont(str, font);
        theHeight = size.height;
        int count = size.width / width;
        height += theHeight * (count + 1);
    }
    height = height - theHeight;
    return height;
}

- (float)calculateHeightWithFont:(UIFont *)font andWidth:(float)width
{
    // 判断是否存在换行符
    NSRange range = [self rangeOfString:@"\n"];
    if (range.location == NSNotFound) { // 不存在
        
        CGSize size = textSizeWithFont(self, font);
        int rowNum = size.width / width;
        return (rowNum+1) * size.height;
        
    }else {                             // 存在
        
        float height = 0;
        float theHeight = 0;
        NSArray *array = [self componentsSeparatedByString:@"\n"];
        for (NSString *str in array) {
            if (str == nil || [str isEqualToString:@""] == YES) {
                CGSize size = textSizeWithFont(@"test", font);
                theHeight = size.height;
                height += theHeight;
                continue;
            }
            CGSize size = textSizeWithFont(str, font);
            theHeight = size.height;
            int count = size.width / width;
            height += theHeight * (count + 1);
        }
        return height;
    
    }
}

- (BOOL)isNewThanVersion:(NSString *)oldVersion
{
    NSArray *arrayNew = [self componentsSeparatedByString:@"."];
    NSArray *arrayOld = [oldVersion componentsSeparatedByString:@"."];
    int len = MIN(arrayNew.count, arrayOld.count);
    for (int i = 0; i < len; i++) {
        if ([[arrayNew objectAtIndex:i] intValue] > [[arrayOld objectAtIndex:i] intValue]) {
            return YES;
        } else if ([[arrayNew objectAtIndex:i] intValue] < [[arrayOld objectAtIndex:i] intValue]) {
            return NO;
        }
    }
    return NO;
}

- (NSString *)convertToTimeString
{
    long long thisTimestamp = [[self substringToIndex:10] longLongValue];
    
    long long curTimestamp = [[NSDate date] timeIntervalSince1970];
    long long todayTimestamp = curTimestamp - (curTimestamp % ONE_DATE_TIME) - CUR_TIMEZONE;
    long long dTimestamp = todayTimestamp - thisTimestamp;
    if (dTimestamp > TWO_DATE_TIME) {
        // 三天前, 使用: yyyy-MM-dd HH:mm
        return [NSString timestampConvertString:thisTimestamp dataFormat:@"yyyy-MM-dd HH:mm"];
    } else if (dTimestamp > ONE_DATE_TIME) {
        // 两天前, 使用: 前天 HH:mm
        NSString *timeStr = [NSString timestampConvertString:thisTimestamp dataFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"前天 %@", timeStr];
    } else if (dTimestamp > 0) {
        // 一天前, 使用: 昨天 HH:mm
        NSString *timeStr = [NSString timestampConvertString:thisTimestamp dataFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@", timeStr];
    } else if (thisTimestamp < todayTimestamp + ONE_DATE_TIME) {
        NSString *timeStr = [NSString timestampConvertString:thisTimestamp dataFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", timeStr];
    } else {
        // 今天以后, 使用: yyyy-MM-dd HH:mm
        return [NSString timestampConvertString:thisTimestamp dataFormat:@"yyyy-MM-dd HH:mm"];
    }
    return nil;
}

+ (NSString *)generateUniqueId
{
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    CFRelease(uuid);
    
    return (NSString *)CFBridgingRelease(uuidStr);
}

+ (NSString *)getDocumentLocation
{
    if (locDocumentPath == nil) {
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            locDocumentPath = [documentPaths objectAtIndex:0];
        }
    }
    
    return locDocumentPath;
}

+ (NSString *)getTempLocation
{
    if (locTempPath == nil) {
        NSError * error;
        NSString * docpath = nil;
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            docpath = [documentPaths objectAtIndex:0];
            if(docpath)
            {
                docpath = [docpath stringByAppendingPathComponent:TEMP_FOLDER_NAME];
                if(![[NSFileManager defaultManager] fileExistsAtPath:docpath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error];
                    if(error!=nil)
                    {
                        return nil; // Cannot create a directory
                    }
                }
                locTempPath = docpath;
            }
        }
    }
    return locTempPath;
}

+ (NSString *)getImageLocation
{
    if (locImagePath == nil) {
        NSError * error;
        NSString * docpath = nil;
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            docpath = [documentPaths objectAtIndex:0];
            if(docpath)
            {
                docpath = [docpath stringByAppendingPathComponent:IMAGE_FOLDER_NAME];
                if(![[NSFileManager defaultManager] fileExistsAtPath:docpath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error];
                    if(error!=nil)
                    {
                        return nil; // Cannot create a directory
                    }
                }
                locImagePath = docpath;
            }
        }
    }
    return locImagePath;
}
/*
+ (NSString *)getAvatarLocation
{
    if (locAvatarPath == nil) {
        NSError * error;
        NSString * docpath = nil;
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            docpath = [documentPaths objectAtIndex:0];
            if(docpath)
            {
                docpath = [docpath stringByAppendingPathComponent:kAvatarDir];
                if(![[NSFileManager defaultManager] fileExistsAtPath:docpath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error];
                    if(error!=nil)
                    {
                        return nil; // Cannot create a directory
                    }
                }
                locAvatarPath = docpath;
            }
        }
    }
    return locAvatarPath;
}


+ (NSString *)getAudioLocation
{
    if (locAudioPath == nil) {
        NSError * error;
        NSString * docpath = nil;
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            docpath = [documentPaths objectAtIndex:0];
            if(docpath)
            {
                docpath = [docpath stringByAppendingPathComponent:kAudioDir];
                if(![[NSFileManager defaultManager] fileExistsAtPath:docpath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error];
                    if(error!=nil)
                    {
                        return nil; // Cannot create a directory
                    }
                }
                locAudioPath = docpath;
            }
        }
    }
    return locAudioPath;
}

+ (NSString*)getLaunchImage
{
    if (launchImagePath == nil) {
        NSError * error;
        NSString * docpath = nil;
        NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(documentPaths.count > 0)
        {
            docpath = [documentPaths objectAtIndex:0];
            if(docpath)
            {
                docpath = [docpath stringByAppendingPathComponent:kLaunchImage];
                if(![[NSFileManager defaultManager] fileExistsAtPath:docpath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error];
                    if(error!=nil)
                    {
                        return nil; // Cannot create a directory
                    }
                }
                launchImagePath = docpath;
            }
        }
    }
    return launchImagePath;
}
*/
// 时间戳为毫秒
+ (NSString *)timestampConvertString:(long long)time {

    NSString *timeStr = [NSString timestampConvertString:time dataFormat:@"HH:mm"];
    
    return timeStr;
}

+ (NSString *)timestampConvertString:(long long)time dataFormat:(NSString *)dataFormat
{
    NSString *myStr = [NSString stringWithFormat:@"%lld", time];
    
    // 至少10位
    if (myStr.length < 10) {
        return nil;
    }
    
    NSString *myStr_s = [myStr substringToIndex:10];
    //LogInfo(@"...%@...", myStr_s);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[myStr_s longLongValue]];
    //LogInfo(@"date:%@", [date description]);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setDateFormat:dataFormat];
    
    NSString *timeStr = [formatter stringFromDate:date];
    //LogInfo(@"timeStr:%@", timeStr);
    
    return timeStr;
}

// 19:20 转为 发布 19时20分
+ (NSString *)timeStringConvert:(NSString *)time {

    NSArray *arr = [time componentsSeparatedByString:@":"];
    if (arr.count < 2) {
        return nil;
    }
    NSString *hourStr = [arr objectAtIndex:0];
    NSString *minuteStr = [arr objectAtIndex:1];
    return [NSString stringWithFormat:@"发布%@时%@分", hourStr, minuteStr];
    
}

// 获取半小时后的时间字串
+ (NSString *)halfHourAfterCurrentTime {

//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyyMMddHHmm"];  // 到分
//    
//    NSDate *date = [NSDate date];
//    NSString *timeStr = [formatter stringFromDate:date];
//    long long timeCount = [timeStr longLongValue];
//    LogInfo(@"current:%lld", timeCount);
//    timeCount += 30;
//    LogInfo(@"halfHour:%lld", timeCount);
    
    NSDate *date = [NSDate date];
    NSDate *nextDate = [date dateByAddingTimeInterval:(30*60)]; // 加半小时
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];  // 到分
    NSString *timeStr = [formatter stringFromDate:nextDate];
    LogInfo(@"half an hour time string:%@", timeStr);
    return timeStr;
    
}

// 获取24小时后的时间字串
+ (NSString *)oneDayAfterCurrentTime {
    
    NSDate *date = [NSDate date];
    NSDate *nextDate = [date dateByAddingTimeInterval:(24*3600)];   // 加一天
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];  // 到分
    NSString *timeStr = [formatter stringFromDate:nextDate];
    LogInfo(@"24 hours time string:%@", timeStr);
    return timeStr;
    
}

// 获取24小时前的时间字串
+ (NSString *)oneDayBeforeCurrentTime {

    NSDate *date = [NSDate date];
    NSDate *nextDate = [date dateByAddingTimeInterval:-(24*3600)];   // 减一天
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];  // 到分
    NSString *timeStr = [formatter stringFromDate:nextDate];
    LogInfo(@"24 hours time string:%@", timeStr);
    return timeStr;
    
}


@end
