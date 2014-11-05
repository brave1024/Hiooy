//
//  OrderUnpayModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-20.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  订单结算接口返回的订单数据实体

#import <Foundation/Foundation.h>
#import "PayInfoModel.h"
#import "PayProductModel.h"

@protocol OrderUnpayModel <NSObject>

@end


@interface OrderUnpayModel : JSONModel

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString<Optional> *seller_id;
@property (nonatomic, copy) NSString<Optional> *total_amount;
@property (nonatomic, copy) NSString<Optional> *seller_name;
@property (nonatomic, strong) PayInfoModel<Optional> *payinfo;
@property (nonatomic, strong) NSArray<PayProductModel, Optional> *goodlist;

@end
