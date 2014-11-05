//
//  CartGoodsModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-18.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  加入购物车中单个商品实体

#import "JSONModel.h"

@protocol CartGoodsModel <NSObject>

@end

@interface CartGoodsModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *selected;                   // 默认选中状态
@property (nonatomic, copy) NSString<Optional> *subtotal;                   // 总价 = 价格*数量
@property (nonatomic, copy) NSString<Optional> *quantity;                   // 数量
@property (nonatomic, copy) NSString<Optional> *name;                       // 名称
@property (nonatomic, copy) NSString<Optional> *goods_id;                   // 商品id
@property (nonatomic, copy) NSString<Optional> *product_id;                 // 产品id
@property (nonatomic, copy) NSString<Optional> *price;                      // 价格
@property (nonatomic, copy) NSString<Optional> *image_url;                  // 图片地址

@end
