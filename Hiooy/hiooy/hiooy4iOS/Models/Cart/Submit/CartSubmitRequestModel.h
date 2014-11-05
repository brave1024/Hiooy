//
//  CartSubmitRequestModel.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  购物车提交时传的参数实体...<请求>

#import "JSONModel.h"
#import "CartSubmitSellerModel.h"

@interface CartSubmitRequestModel : JSONModel

@property (nonatomic, copy) NSString *member_id;                        // 用户id
@property (nonatomic, copy) NSString *addr_id;                          // 地址id
@property (nonatomic, copy) NSString *payment_app_id;                   // 支付方式id
@property (nonatomic, strong) NSArray<CartSubmitSellerModel> *seller;   // 商品实体

@property (nonatomic, copy) NSString<Optional> *memo;                   // 用于订单提交接口中的留言字段

@end
