//
//  CommentModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  总的评论实体<用于商品详情>

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "CommentDetailModel.h"

@protocol CommentModel <NSObject>

@end


@interface CommentModel : JSONModel

@property (nonatomic, strong) NSArray<CommentDetailModel> *list;
@property (nonatomic, copy) NSString<Optional> *count;

@end
