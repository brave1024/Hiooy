//
//  ProductCatListModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-9.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品分类接口返回<总的>数据实体

#import "JSONModel.h"
#import "ProductCatItemModel.h"

@interface ProductCatListModel : JSONModel

@property (nonatomic, copy) NSString *title;    // 类别标题
@property (nonatomic, copy) NSString *url;      // 下一页链接
@property (nonatomic, strong) NSArray<ProductCatItemModel, Optional> *cat_lists;    // 子类别数组

@end
