//
//  PagerModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  当前商品列表页实体<分页信息>

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol PagerModel <NSObject>

@end

@interface PagerModel : JSONModel

@property (nonatomic, copy) NSString *current;                  // 当前页
@property (nonatomic, copy) NSString *total;                    // 总页数
@property (nonatomic, copy) NSString *cur_page;                 // 当前页链接
@property (nonatomic, copy) NSString<Optional> *next_page;      // 下一页链接（存在下一页才显示）

@end
