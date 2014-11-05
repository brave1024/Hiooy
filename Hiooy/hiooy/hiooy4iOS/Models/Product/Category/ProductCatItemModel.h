//
//  ProductCatItemModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-9.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  <单条>具体商品类别数据实体...<顶级分类><子分类>

#import "JSONModel.h"

@protocol ProductCatItemModel <NSObject>

@end


@interface ProductCatItemModel : JSONModel

@property (nonatomic, copy) NSString *cat_id;                                   // 分类id
@property (nonatomic, copy) NSString *cat_name;                                 // 分类名称
@property (nonatomic, copy) NSString<Optional> *child_count;                    // 子分类个数
@property (nonatomic, copy) NSString<Optional> *haschild;                       // 分类icon地址
@property (nonatomic, copy) NSString<Optional> *image_url;                      // 是否存在子分类
@property (nonatomic, copy) NSString<Optional> *url;                            // 分类地址
@property (nonatomic, copy) NSString<Optional> *next_url;                       // 新增<子类>...~!@
@property (nonatomic, strong) NSArray<ProductCatItemModel, Optional> *sub;      // 子分类数组

@end
