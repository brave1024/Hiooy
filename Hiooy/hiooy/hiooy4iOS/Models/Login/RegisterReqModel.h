//
//  RegisterReqModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-26.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  注册请求实体

#import <Foundation/Foundation.h>

@interface RegisterReqModel : NSObject

@property (nonatomic, strong) NSString *license;
// 账号信息
@property (nonatomic, strong) NSString *login_name;
@property (nonatomic, strong) NSString *login_password;
@property (nonatomic, strong) NSString *psw_confirm;
// 联系人信息
@property (nonatomic, strong) NSString *mobile; // 不使用
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;   // 不使用

@end
