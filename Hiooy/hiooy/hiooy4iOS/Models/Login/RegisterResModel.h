//
//  RegisterResModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-26.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  注册响应实体

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface RegisterResModel : JSONModel

// old
/*
{
    "status": "success",
    "msg": "注册成功",
    "data": {
        "login_password": "123456",
        "login_name": "cookov",
        "psw_confirm": "123456",
        "email": "110381582@qq.com",
        "license": "agree",
        "pam_account": {
            "login_name": "cookov",
            "login_password": "s1869c6a80eb8630f0c99e1b8f803047",
            "psw_confirm": "123456",
            "account_type": "member",
            "createtime": 1396443198,
            "account_id": "163516"
        },
        "contact": {
            "email": "110381582@qq.com",
            "addr": ""
        },
        "member_lv": {
            "member_group_id": "1"
        },
        "currency": "CNY",
        "reg_ip": "58.254.168.99",
        "regtime": 1396443198,
        "source": "wap",
        "member_id": "163516"
    }
}
 */


// new
/*
{
    "status": "success",
    "msg": "注册成功",
    "data": {
        "login_password": "000000",
        "login_name": "18507103285",
        "code": "w6de",
        "psw_confirm": "000000",
        "license": "agree",
        "pam_account": {
            "login_name": "18507103285",
            "login_password": "s1786bc88f2b67c392f65b3010a0c8a0",
            "psw_confirm": "000000",
            "account_type": "member",
            "createtime": 1400667595,
            "account_id": "86"
        },
        "contact": {
            "email": "",
            "addr": ""
        },
        "member_lv": {
            "member_group_id": "1"
        },
        "currency": "CNY",
        "reg_ip": "10.2.2.149",
        "regtime": 1400667595,
        "source": "wap",
        "member_id": "86"
    }
}
*/


@property (nonatomic, strong) NSString *login_password;
@property (nonatomic, strong) NSString *login_name;
@property (nonatomic, strong) NSString *psw_confirm;
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) NSString<Optional> *license;
@property (nonatomic, strong) NSDictionary<Optional> *pam_account;
@property (nonatomic, strong) NSDictionary<Optional> *contact;
@property (nonatomic, strong) NSDictionary<Optional> *member_lv;
@property (nonatomic, strong) NSString<Optional> *currency;
@property (nonatomic, strong) NSString<Optional> *reg_ip;
@property (nonatomic, strong) NSString<Optional> *regtime;
@property (nonatomic, strong) NSString<Optional> *source;
@property (nonatomic, strong) NSString<Optional> *member_id;
//@property (nonatomic, strong) NSString<Optional> *point;

@end
