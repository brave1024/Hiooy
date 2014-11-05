//
//  ProductImageModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品图片实体<用于商品详情>

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ProductImageModel <NSObject>

@end


@interface ProductImageModel : JSONModel

@property (nonatomic, copy) NSString *l;    // 大图地址
@property (nonatomic, copy) NSString *m;    // 中图地址
@property (nonatomic, copy) NSString *s;    // 小图地址

@end
