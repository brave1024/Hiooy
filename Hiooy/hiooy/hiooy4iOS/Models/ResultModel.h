//
//  ResultModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  网络请求返回数据的body部分...<不再使用>

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ResultModel : JSONModel

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) id data;

@end
