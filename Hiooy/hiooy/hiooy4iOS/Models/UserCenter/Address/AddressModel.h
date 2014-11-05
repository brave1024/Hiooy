//
//  AddressModel.h
//  hiooy
//
//  Created by retain on 14-5-8.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  收货地址列表接口返回的单个地址实体

#import <Foundation/Foundation.h>
#import "PhoneModel.h"

//@protocol phoneModel <NSObject>
//
//@end
//
//@interface phoneModel : JSONModel
//
//@property (nonatomic, copy) NSString<Optional> *tel;
//@property (nonatomic, copy) NSString<Optional> *mobile;
//
//@end


@protocol AddressModel <NSObject>

@end

@interface AddressModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *addr_id;        // 地址id
@property (nonatomic, copy) NSString<Optional> *area;           // 区域
@property (nonatomic, copy) NSString *area_id;                  // 区域id
@property (nonatomic, copy) NSString *addr;                     // 地址详情
@property (nonatomic, copy) NSString *name;                     // 用户姓名
@property (nonatomic, copy) NSString<Optional> *is_default;     // 是否为默认
@property (nonatomic, copy) NSString<Optional> *zip;            // 邮编
@property (nonatomic, strong) PhoneModel *phone;                // 电话

@property (nonatomic, copy) NSString<Optional> *member_id;   // 用户id

@end
