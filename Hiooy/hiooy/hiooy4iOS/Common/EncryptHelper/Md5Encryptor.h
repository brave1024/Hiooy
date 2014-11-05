//
//  Md5Encryptor.h
//  Lottery
//
//  Created by Lad on 12-11-6.
//  Copyright (c) 2012年 archermind. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	@brief	Md5加密类
 */
@interface Md5Encryptor : NSObject
/**
 *	@brief	将字符串作md5值加密，如果传入的原文为空字符串“”或者nil则返回的密文为空字符串“”
 *
 *	@param 	str 	原文
 *
 *	@return	密文
 */
+ (NSString *)md5:(NSString *)str;

@end
