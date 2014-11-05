//
//  AddrInfoModel.h
//  hiooy
//
//  Created by 黄磊 on 14-3-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  暂未用到

#import "JSONModel.h"

@interface AddrInfoModel : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *addr;

@property (nonatomic, strong) NSNumber<Optional> *addrId;
@property (nonatomic, strong) NSNumber<Optional> *isDefault;

- (AddrInfoModel *)copeAddr;

@end
