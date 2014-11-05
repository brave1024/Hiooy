//
//  OrderModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品排序方式实体

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol OrderModel <NSObject>

@end

@interface OrderModel : JSONModel

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *lable;

@end
