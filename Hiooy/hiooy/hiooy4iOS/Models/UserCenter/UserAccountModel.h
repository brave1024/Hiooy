//
//  UserAccountModel.h
//  hiooy
//
//  Created by retain on 14-4-29.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserAccountModel <NSObject>

@end

@interface UserAccountModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, copy) NSString<Optional> *freeze;

@end
