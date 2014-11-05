//
//  CartResponseItemModel.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  提交购物车接口返回数据中的单个cart实体...<响应>

#import "JSONModel.h"
#import "CartGoodsModel.h"
#import "CartSellerModel.h"
#import "CartResponseShippingModel.h"

@protocol CartResponseItemModel <NSObject>

@end

@interface CartResponseItemModel : JSONModel

@property (nonatomic, copy) NSString *items_quantity;                                   // 数量
@property (nonatomic, copy) NSString *subtotal;                                         // 总价
@property (nonatomic, strong) NSArray<CartGoodsModel> *goods;                           // 商品列表
@property (nonatomic, strong) NSArray<CartResponseShippingModel, Optional> *shipping;   // 配送列表
@property (nonatomic, strong) CartSellerModel *seller_info;                             // 商户信息

@end
