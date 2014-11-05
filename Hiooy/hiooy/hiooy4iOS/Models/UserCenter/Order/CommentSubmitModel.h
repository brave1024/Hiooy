//
//  CommentSubmitModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  用户提交的商品评价数据

#import <Foundation/Foundation.h>

@interface CommentSubmitModel : JSONModel

@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString<Optional> *hidden_name;    // 必填：否(匿名则填写YES，不匿名则传空)
@property (nonatomic, copy) NSString *point_type;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString<Optional> *contact;        // 必填：否

@end
