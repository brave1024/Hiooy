//
//  ProductBuyRequestModel.h
//  hiooy
//
//  Created by retain on 14-5-7.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  立即购买商品时传的参数实体

#import "JSONModel.h"

@interface ProductBuyRequestModel : JSONModel

@property (nonatomic, copy) NSString *member_id;    // 会员id
@property (nonatomic, copy) NSString *goods_id;     // 商品id
@property (nonatomic, copy) NSString *product_id;   // 货品id
@property (nonatomic, copy) NSString *num;          // 数量
@property (nonatomic, copy) NSString *is_fast;      // 快速购买标示:这里为1

@end
