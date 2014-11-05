//
//  CommentGoodsInfoModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  评价商品接口返回的总的数据实体

#import <Foundation/Foundation.h>
#import "CommentTypeModel.h"
#import "GoodsInfoModel.h"

@interface CommentGoodsInfoModel : JSONModel

@property (nonatomic, strong) GoodsInfoModel<Optional> *goods_info;
@property (nonatomic, strong) NSArray<CommentTypeModel, Optional> *comment_goods_type;

@end
