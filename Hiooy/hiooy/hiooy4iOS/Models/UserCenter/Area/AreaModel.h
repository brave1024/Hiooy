//
//  AreaModel.h
//  hiooy
//
//  Created by retain on 14-5-6.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  区域实体

#import <Foundation/Foundation.h>

@protocol AreaModel <NSObject>

@end

@interface AreaModel : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;

@end
