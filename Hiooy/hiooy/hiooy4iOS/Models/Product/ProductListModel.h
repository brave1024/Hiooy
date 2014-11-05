//
//  ProductListModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品列表实体

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ProductModel.h"
#import "PagerModel.h"
#import "OrderModel.h"


@interface ProductListModel : JSONModel

@property (nonatomic, strong) NSArray<ProductModel, Optional> *products;
@property (nonatomic, strong) PagerModel<Optional> *pager;
@property (nonatomic, strong) NSArray<OrderModel, Optional> *orderby;

@end
