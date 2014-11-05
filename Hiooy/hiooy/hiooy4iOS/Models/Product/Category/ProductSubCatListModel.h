//
//  ProductSubCatListModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-10.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  子分类接口返回的数据实体

#import "JSONModel.h"
#import "ProductCatItemModel.h"

@interface ProductSubCatListModel : JSONModel

//@property (nonatomic, strong) NSArray<ProductCatItemModel, Optional> *cat_info;
@property (nonatomic, strong) ProductCatItemModel<Optional> *cat_info;

@end
