//
//  CartResponsePaymentModel.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  提交购物车接口返回数据中的支付方式实体...<响应>

#import "JSONModel.h"

@protocol CartResponsePaymentModel <NSObject>

@end

@interface CartResponsePaymentModel : JSONModel

@property (nonatomic, copy) NSString *app_id;                       // 支付方式id
@property (nonatomic, copy) NSString<Optional> *app_display_name;   // 支付方式名称
@property (nonatomic, copy) NSString<Optional> *choosed;            // 是否选中

@property (nonatomic, copy) NSString<Optional> *app_name;           // 支付方式名称...<补:兼容两个接口返回的同一个实体中字段不一致 app_display_name / app_name>

@end
