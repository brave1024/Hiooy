//
//  CartSumbitGoodsModel.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  用于拼装购物车提交接口中所需参数的goods实体...<请求>

#import "JSONModel.h"

@protocol CartSumbitGoodsModel <NSObject>

@end


@interface CartSumbitGoodsModel : JSONModel

@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *num;

@end
