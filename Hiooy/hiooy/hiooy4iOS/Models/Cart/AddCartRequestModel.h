//
//  AddCartRequestModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-18.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  加入购物车时的请求参数实体

#import "JSONModel.h"

@interface AddCartRequestModel : JSONModel

@property (nonatomic, copy) NSString *goods_id;     // 商品id
@property (nonatomic, copy) NSString *product_id;   // 货品id
@property (nonatomic, copy) NSString *num;          // 商品数量
@property (nonatomic, copy) NSString *type;         // 商品类型
@property (nonatomic, copy) NSString *member_id;    // 登录会员id

@end
