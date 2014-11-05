//
//  XMLHelper.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-26.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  ...<未使用>

#import <Foundation/Foundation.h>
#import "RegisterReqModel.h"
#import "LoginReqModel.h"
#import "RegisterResModel.h"
#import "LoginResModel.h"
#import "AddressItemModel.h"

@interface XMLHelper : NSObject

// test
+ (void)xmlParserTest;
+ (void)createXMLTest;

// 注册
+ (NSString *)getRegisterXML:(RegisterReqModel *)reqData;   // 封装注册请求数据
+ (void)parseRegisterXML:(RegisterResModel *)resData;       // 解析注册返回数据

// 登录
+ (NSString *)getLoginXML:(LoginReqModel *)reqData;         // 封装登录请求数据
+ (void)parseLoginXML:(LoginResModel *)resData;             // 解析登录返回数据

// 收货地址
+ (NSString *)getAddressXML:(AddressItemModel *)reqData;    


@end
