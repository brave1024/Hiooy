
//
//  Md5Encryptor.m
//  Lottery
//
//  Created by Lad on 12-11-6.
//  Copyright (c) 2012年 archermind. All rights reserved.
//
#import "Md5Encryptor.h"
#import <CommonCrypto/CommonDigest.h>


@implementation Md5Encryptor

+ (NSString *)md5:(NSString *)input
{
    if (input == nil || [input isEqualToString:@""])
    {
        return @"";
    }
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];   // md5加密字串转大写
    }
    return ret;
}

@end
