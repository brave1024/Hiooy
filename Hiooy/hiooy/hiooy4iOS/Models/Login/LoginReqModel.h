//
//  LoginReqModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-26.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  登录请求实体

#import <Foundation/Foundation.h>

@interface LoginReqModel : NSObject

@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *password;

@end
