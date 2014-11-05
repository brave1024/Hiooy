//
//  OrderCommentModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  待评价商品列表接口返回的数据实体

#import <Foundation/Foundation.h>
#import "ProductCommentModel.h"
#import "PagerModel.h"

@interface OrderCommentModel : JSONModel

@property (nonatomic, strong) NSArray<ProductCommentModel, Optional> *list;
@property (nonatomic, strong) PagerModel<Optional> *pager;

@end
