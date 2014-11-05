//
//  PhoneModel.h
//  hiooy
//
//  Created by retain on 14-5-8.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  地址中的电话实体

#import <Foundation/Foundation.h>

@protocol PhoneModel <NSObject>

@end


@interface PhoneModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *tel;    // 座机号
@property (nonatomic, copy) NSString<Optional> *mobile; // 手机号

@end
