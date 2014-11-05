//
//  PayOrdersModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-29.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayProductModel.h"

@protocol PayOrdersModel <NSObject>

@end

@interface PayOrdersModel : JSONModel

@property (nonatomic, strong) NSArray<PayProductModel, Optional> *products; // 商品信息
@property (nonatomic, copy) NSString<Optional> *order_id;                   // 订单号
@property (nonatomic, copy) NSString<Optional> *cost_freight;               // 运费
@property (nonatomic, copy) NSString<Optional> *final_amount;               // 订单总价

@end
