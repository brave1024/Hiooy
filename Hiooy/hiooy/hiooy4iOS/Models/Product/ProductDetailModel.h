//
//  ProductDetailModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品详情实体

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ProductImageModel.h"
#import "SellerInfoModel.h"
#import "CommentModel.h"
#import "ProductTypeModel.h"

@interface ProductDetailModel : JSONModel

@property (nonatomic, copy) NSString *goods_id;                                 // 商品id
@property (nonatomic, copy) NSString *name;                                     // 商品名称
@property (nonatomic, copy) NSString *price;                                    // 销售价
@property (nonatomic, copy) NSString *mktprice;                                 // 市场价
@property (nonatomic, copy) NSString *add_favurl;                               // 收藏 ?
@property (nonatomic, copy) NSString *intro_url;                                // 商品详情(详细介绍)
@property (nonatomic, copy) NSString<Optional> *spec_url;                       // 商品参数选择(只针对多规格商品)...<可无>
@property (nonatomic, strong) NSArray<ProductTypeModel, Optional> *products;    // 商品型号(若是单规格,则只有一个元素;若是多规格,则有多个)
@property (nonatomic, strong) ProductImageModel<Optional> *image_default;       // 商品大图
@property (nonatomic, strong) NSArray<ProductImageModel, Optional> *images;     // 商品组图
@property (nonatomic, strong) SellerInfoModel<Optional> *seller_info;           // 商户信息
@property (nonatomic, strong) CommentModel<Optional> *comments;                 // 评论信息...<可无>
@property (nonatomic, strong) NSString<Optional> *is_fav;                       // 是否已收藏 0:未收藏 1:已收藏

@end
