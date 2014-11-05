//
//  LoginResModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-26.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  登录响应实体

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface LoginResModel : JSONModel

/*
{
    "status": "success",
    "msg": "登陆成功",
    "data": {
        "member_id": "163516",
        "pam_account": {
            "login_name": "cookov"
        },
        "order_num": 0,
        "experience": "0",
        "point": null,
        "advance": {
            "total": "0.000",
            "freeze": "0.000"
        },
        "fav_num": 0
    }
}
*/

@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSDictionary *pam_account;
@property (nonatomic, assign) int order_num;
@property (nonatomic, strong) NSString *experience;
@property (nonatomic, strong) NSString<Optional> *point;
@property (nonatomic, strong) NSDictionary *advance;
@property (nonatomic, assign) int fav_num;

@end

