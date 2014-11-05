//
//  PayInfoModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-20.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  订单结算接口返回的 订单实体 中的 支付方式实体

#import <Foundation/Foundation.h>

@protocol PayInfoModel <NSObject>

@end


@interface PayInfoModel : JSONModel

@property (nonatomic, copy) NSString *pay_app_id;
@property (nonatomic, copy) NSString<Optional> *cost_payment;

@end
