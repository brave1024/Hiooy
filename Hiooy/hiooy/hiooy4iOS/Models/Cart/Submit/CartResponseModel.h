//
//  CartResponseModel.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  提交购物车接口返回的数据实体...<响应>

#import "JSONModel.h"
#import "CartResponseItemModel.h"
#import "CartResponseAddressModel.h"
#import "CartResponsePaymentModel.h"
#import "CartPromotionModel.h"

@interface CartResponseModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, strong) NSArray<CartResponseItemModel> *aCart;
@property (nonatomic, strong) NSArray<CartResponseAddressModel, Optional> *addrlist;
@property (nonatomic, strong) NSArray<CartResponsePaymentModel, Optional> *payment;
@property (nonatomic, strong) CartResponseAddressModel<Optional> *def_arr_addr;
@property (nonatomic, strong) NSArray<CartPromotionModel, Optional> *promotion;

@end
