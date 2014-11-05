//
//  ProductCommentModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  待评价商品之单个商品实体

#import <Foundation/Foundation.h>

@protocol ProductCommentModel <NSObject>

@end


@interface ProductCommentModel : JSONModel

/*
{
    "status": "success",
    "msg": "",
    "data": {
        "list": [
                 {
                     "order_id": "1404291746559951",
                     "product_id": "30",
                     "goods_id": "26",
                     "product_name": "2013新款 HIM汉崇正品 英伦格子立体修身风尚男士便西501054BL",
                     "number": "1",
                     "price": "434.000",
                     "seller_id": "10",
                     "seller_name": "百丽国际",
                     "image_url": "http://linux.hiooy.com/ecstore/public/images/2b/7f/c5/bccfc3d640e5260cfd18ef53bb448897.jpg?1395994758#h"
                 }
                 ],
        "pager": {
            "current": 1,
            "total": 1,
            "cur_page": "http://linux.hiooy.com/ecstore/index.php/wap/member-nodiscuss-1.html"
        }
    }
}
*/

@property (nonatomic, copy) NSString<Optional> *order_id;
@property (nonatomic, copy) NSString<Optional> *product_id;
@property (nonatomic, copy) NSString<Optional> *goods_id;
@property (nonatomic, copy) NSString<Optional> *product_name;
@property (nonatomic, copy) NSString<Optional> *number;
@property (nonatomic, copy) NSString<Optional> *price;
@property (nonatomic, copy) NSString<Optional> *seller_id;
@property (nonatomic, copy) NSString<Optional> *seller_name;
@property (nonatomic, copy) NSString<Optional> *image_url;
@property (nonatomic, copy) NSString<Optional> *createtime;         // 创建时间

@end


