//
//  ProductModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品简介实体<用于商品列表> 及 商品评价接口中返回的商品信息 及 关键字搜索

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ProductModel <NSObject>

@end

@interface ProductModel : JSONModel

@property (nonatomic, copy) NSString *goods_id;                 // 商品id
@property (nonatomic, copy) NSString<Optional> *name;           // 商品名称
@property (nonatomic, copy) NSString<Optional> *price;          // 商品销售价格
@property (nonatomic, copy) NSString<Optional> *store;          //
@property (nonatomic, copy) NSString<Optional> *mktprice;       // 商品市场价
@property (nonatomic, copy) NSString<Optional> *image_url;      //
@property (nonatomic, copy) NSString<Optional> *url;            //

@property (nonatomic, copy) NSString<Optional> *product_id;     // 用于商品评价...<搜索数据中无此字段>

/*
"goods_info": {
    "goods_id": "26",
    "name": "2013新款 HIM汉崇正品 英伦格子立体修身风尚男士便西501054BL",
    "product_id": "30",
    "image_url": "http://linux.hiooy.com/ecstore/public/images/2b/7f/c5/bccfc3d640e5260cfd18ef53bb448897.jpg?1395994758#h"
}
*/

@end
