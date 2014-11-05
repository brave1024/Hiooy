//
//  CommentDetailModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  买家评论详情实体

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol CommentDetailModel <NSObject>

@end


@interface CommentDetailModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *member_name;  // 会员名（有昵称显示昵称）
@property (nonatomic, copy) NSString<Optional> *avatar;       // 会员头像
@property (nonatomic, copy) NSString<Optional> *comment;      // 评论内容

@end
