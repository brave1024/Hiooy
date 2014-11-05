//
//  OrderUnpayResModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-20.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  订单结算接口返回的总的数据实体

#import <Foundation/Foundation.h>
#import "OrderUnpayModel.h"
#import "CartResponsePaymentModel.h"

@interface OrderUnpayResModel : JSONModel

@property (nonatomic, strong) OrderUnpayModel *order;
@property (nonatomic, strong) NSArray<CartResponsePaymentModel> *payment_list;

@end
