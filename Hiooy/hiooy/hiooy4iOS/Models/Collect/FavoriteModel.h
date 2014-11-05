//
//  FavoriteModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  我的收藏之收藏的商品实体

#import <Foundation/Foundation.h>

@protocol FavoriteModel <NSObject>

@end

@interface FavoriteModel : JSONModel

@property (nonatomic, copy) NSString *thumbnail_pic;                // 商品缩略图
@property (nonatomic, copy) NSString<Optional> *image_default_id;   // 商品默认图片...<去掉>
@property (nonatomic, copy) NSString *goods_id;                     // 商品id
@property (nonatomic, copy) NSString *price;                        // 商品销售价格
@property (nonatomic, copy) NSString *name;                         // 商品名称
@property (nonatomic, copy) NSString *type_id;                      // 商品类型id
@property (nonatomic, copy) NSString *type_name;                    // 类型名称
@property (nonatomic, copy) NSString *nostore_sell;                 // 商品是否开启无库存销售
@property (nonatomic, copy) NSString *mktprice;                     // 商品市场价
@property (nonatomic, copy) NSString *cat_id;                       // 商品分类id
@property (nonatomic, copy) NSString *cat_name;                     // 分类名称
@property (nonatomic, copy) NSString *marketable;                   // 商品是否上架
@property (nonatomic, copy) NSString *store;                        // 库存
@property (nonatomic, copy) NSString *goods_url;                    // 商品链接
@property (nonatomic, copy) NSString *fav_count;                    // 收藏次数
@property (nonatomic, copy) NSString<Optional> *brief;              // 简介...<可能为空>
@property (nonatomic, copy) NSString<Optional> *udfimg;             // <去掉>

/*
{
    "goods_id": "110",
    "name": "三星 S5830i s6352 S6358 s5660手机原装电池+品牌座充",
    "price": 68,
    "mktprice": "150.000",
    "fav_count": "1",
    "image_default_id": "http://linux.hiooy.com/ecstore/public/images/07/27/fd/406637e02d96ef906f00a93a0a049b9e.jpg?1397792128#h",
    "goods_url": "/ecstore/index.php/wap/product-110.html"
}
*/

@end
