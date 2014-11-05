//
//  CartListModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-18.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  购物车接口返回数据实体

#import "JSONModel.h"
#import "CartSellerGoodsModel.h"
#import "CartPromotionModel.h"

@interface CartListModel : JSONModel

@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) NSArray<CartSellerGoodsModel> *seller;
@property (nonatomic, strong) NSArray<CartPromotionModel, Optional> *promotion;

@end
