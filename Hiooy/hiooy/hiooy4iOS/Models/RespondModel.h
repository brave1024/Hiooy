//
//  RespondModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  网络请求返回数据...<未使用>

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface RespondModel : JSONModel

@property (nonatomic, strong) NSString *status; // 状态
@property (nonatomic, strong) NSString *msg;    // 错误提示
@property (nonatomic, strong) NSString *data;   // 实际返回数据

@end
