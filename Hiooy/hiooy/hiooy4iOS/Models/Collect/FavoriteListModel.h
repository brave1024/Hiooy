//
//  FavoriteListModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  我的收藏列表实体

#import <Foundation/Foundation.h>
#import "PagerModel.h"
#import "FavoriteModel.h"

@interface FavoriteListModel : JSONModel

@property (nonatomic, strong) NSArray<FavoriteModel, Optional> *favorite;
@property (nonatomic, strong) PagerModel<Optional> *pager;
@property (nonatomic, strong) NSString<Optional> *emtpy_info;   // 类型?

@end
