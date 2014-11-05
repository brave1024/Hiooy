//
//  CartSubmitSellerModel.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  用于拼装购物车提交接口中所需参数的seller实体...<请求>

#import "JSONModel.h"
#import "CartSumbitGoodsModel.h"

@protocol CartSubmitSellerModel <NSObject>

@end

@interface CartSubmitSellerModel : JSONModel

@property (nonatomic, copy) NSString *seller_id;
@property (nonatomic, copy) NSString *shipping_id;
@property (nonatomic, strong) NSArray<CartSumbitGoodsModel> *goods;

@end
