//
//  AddrInfoModel.m
//  hiooy
//
//  Created by 黄磊 on 14-3-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "AddrInfoModel.h"

@implementation AddrInfoModel

- (AddrInfoModel *)copeAddr
{
    AddrInfoModel *newAddr = [[AddrInfoModel alloc] init];
    if (newAddr) {
        newAddr.name = _name;
        newAddr.tel = _tel;
        newAddr.zipcode = _zipcode;
        newAddr.region = _region;
        newAddr.addr = _addr;
        newAddr.addrId = _addrId;
        newAddr.isDefault = _isDefault;
    }
    return  newAddr;
}

@end
