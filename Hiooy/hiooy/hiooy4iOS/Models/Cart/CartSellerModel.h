//
//  CartSellerModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-18.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  加入购物车中商品所在的卖家<商户>实体

#import "JSONModel.h"

@protocol CartSellerModel <NSObject>

@end

@interface CartSellerModel : JSONModel

@property (nonatomic, copy) NSString *seller_id;
@property (nonatomic, copy) NSString *seller_name;
@property (nonatomic, copy) NSString *selected;     // 默认选中状态 YES:表示只少一件商品被选中 NO:表示没有商品被选中

@property (nonatomic, copy) NSString<Optional> *selectAll;   // <非接口返回数据> YES:表示所有商品均被选中   

@end
