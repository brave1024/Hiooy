//
//  AliPayModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-23.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  后台支付接口返回数据实体...<现在只用于通联支付>

#import <Foundation/Foundation.h>
#import "AliPayPostModel.h"

@interface AliPayModel : JSONModel

@property (nonatomic, strong) AliPayPostModel<Optional> *post;
@property (nonatomic, strong) NSString<Optional> *url;          // 通联支付时,只返回一个url

@end
