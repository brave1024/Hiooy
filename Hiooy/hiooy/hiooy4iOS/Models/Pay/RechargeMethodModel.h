//
//  RechargeMethodModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-27.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  预存款充值接口返回的支付方式

#import <Foundation/Foundation.h>
#import "CartResponsePaymentModel.h"

@interface RechargeMethodModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, copy) NSArray<CartResponsePaymentModel, Optional> *payments;

@end
