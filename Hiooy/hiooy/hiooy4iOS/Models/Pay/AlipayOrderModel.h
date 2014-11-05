//
//  AlipayOrderModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-29.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayOrdersModel.h"

@interface AlipayOrderModel : JSONModel

@property (nonatomic, copy) NSString *payment_id;                               // 支付单号
@property (nonatomic, copy) NSString *money;                                    // 总价
@property (nonatomic, copy) NSString<Optional> *goods_name;                     // 商品名称
@property (nonatomic, copy) NSString<Optional> *goods_body;                     // 商品描述
@property (nonatomic, strong) NSArray<PayOrdersModel, Optional> *pay_orders;    // 订单信息

@end
