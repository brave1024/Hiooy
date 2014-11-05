//
//  CommentTypeModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  评价商品接口返回的评价类型实体

#import <Foundation/Foundation.h>

@protocol CommentTypeModel <NSObject>

@end


@interface CommentTypeModel : JSONModel

@property (nonatomic, copy) NSString *type_id;          // 商品评价类型id
@property (nonatomic, copy) NSString *name;             // 名称
@property (nonatomic, copy) NSString *is_total_point;   // 星级

@end
