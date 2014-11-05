//
//  PayProductModel.h
//  hiooy
//
//  Created by retain on 14-4-28.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  订单提交 or 订单结算 接口返回的单个商品实体

#import <Foundation/Foundation.h>

@protocol PayProductModel <NSObject>

@end

@interface PayProductModel : JSONModel

@property (nonatomic, copy) NSString *name;                 // 商品名称
@property (nonatomic, copy) NSString *nums;                 // 数量
@property (nonatomic, copy) NSString *price;                // 单价
@property (nonatomic, copy) NSString<Optional> *amount;     // 总价

// 订单结算接口返回的单个商品中多出的两个字段
@property (nonatomic, copy) NSString<Optional> *goods_id;   //
@property (nonatomic, copy) NSString<Optional> *product_id; //

@end
