//
//  GoodsInfoModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  评价商品接口返回的商品信息实体

#import <Foundation/Foundation.h>

@protocol GoodsInfoModel <NSObject>

@end


@interface GoodsInfoModel : JSONModel

@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *image_url;

@end
