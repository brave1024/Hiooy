//
//  SellerInfoModel.h
//  ;
//
//  Created by Xia Zhiyong on 14-4-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商家<卖家>实体...<用于商品详情>

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol SellerInfoModel <NSObject>

@end


@interface SellerInfoModel : JSONModel

@property (nonatomic, copy) NSString *seller_id;    // 商户id
@property (nonatomic, copy) NSString *logo;         // 商户logo地址
@property (nonatomic, copy) NSString *name;         // 商户名称
@property (nonatomic, copy) NSString *url;          // 商户店铺地址

@end
