//
//  CartSellerGoodsModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-18.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  购物车中,一个卖家包含的所有商品实体<包括卖家信息、所有商品信息>

#import "JSONModel.h"
#import "CartGoodsModel.h"
#import "CartSellerModel.h"

@protocol CartSellerGoodsModel <NSObject>

@end


@interface CartSellerGoodsModel : JSONModel

@property (nonatomic, strong) NSArray<CartGoodsModel> *goods;
@property (nonatomic, strong) CartSellerModel *seller_info;
@property (nonatomic, copy) NSString *items_quantity;
@property (nonatomic, copy) NSString *subtotal;

@property (nonatomic, copy) NSString<Optional> *isEditting; // 表示当前商家是否为编辑状态...<与接口返回数据无关>

@end
