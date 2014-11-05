//
//  OrderGoodsModel.h
//  hiooy
//
//  Created by retain on 14-5-6.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  订单中的单个商品实体

#import <Foundation/Foundation.h>

@protocol OrderGoodsModel <NSObject>

@end

@interface OrderGoodsModel : JSONModel

@property (nonatomic, copy) NSString *name;                 // 商品名称
@property (nonatomic, copy) NSString *goods_id;             // 商品id
@property (nonatomic, copy) NSString *product_id;           // 货品id
@property (nonatomic, copy) NSString<Optional> *price;      // 商品单价
@property (nonatomic, copy) NSString<Optional> *nums;       // 商品数量
@property (nonatomic, copy) NSString<Optional> *amount;     // 商品小计<金额>
@property (nonatomic, copy) NSString<Optional> *image_url;  // 商品图片地址
@property (nonatomic, copy) NSString<Optional> *discuss;    // true表示已经评论，false表示没有评论...<0,1>

@end
