//
//  UserInfoModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-21.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  个人中心返回的数据实体

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "UserAccountModel.h"

@interface UserInfoModel : JSONModel

/*
{
    "status": "success",
    "msg": "",
    "data": {
        "login_name": "cookov",
        "levelname": "注册会员",
        "name": null,
        "un_pay_orders": 0,
        "point": null,
        "type": "pc平台用户",
        "order_url": "/ecstore/index.php/wap/member-orders.html",
        "couponcount": "0",
        "couponurl": "/ecstore/index.php/wap/member-coupon.html",
        "favcount": "0",
        "favurl": "/ecstore/index.php/wap/member-favorite.html",
        "receiver_url": "/ecstore/index.php/wap/member-receiver.html"
    }
}
*/

// 最新返回数据
/*
{
    "status": "success",
    "msg": "",
    "data": {
        "login_name": "cookov",
        "levelname": "注册会员",
        "name": null,
        "un_pay_orders": 0,
        "un_ship_orders": 0,
        "un_sign_orders": 0,
        "nodiscuss_orders": "0"
    }
}
*/

/*
{
    "status": "success",
    "msg": "",
    "data": {
        "login_name": "13661512157",
        "levelname": "注册会员",
        "name": null,
        "advance": {
            "total": "87534.800",
            "freeze": "0.000"
        },
        "un_pay_orders": 90,
        "un_ship_orders": 1,
        "un_sign_orders": 1,
        "nodiscuss_orders": "0",
        "nodiscuss_goods": 2,
        "favcount": "15",
        "order_count": "93"
    }
}
*/

//@property (nonatomic, copy) NSString *login_name;
//@property (nonatomic, copy) NSString *levelname;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *un_pay_orders;
//@property (nonatomic, copy) NSString *point;
//@property (nonatomic, copy) NSString *type;
//@property (nonatomic, copy) NSString *order_url;
//@property (nonatomic, copy) NSString *couponcount;
//@property (nonatomic, copy) NSString *counponurl;
//@property (nonatomic, copy) NSString *favcount;
//@property (nonatomic, copy) NSString *favurl;
//@property (nonatomic, copy) NSString *rereceiver_url;

@property (nonatomic, copy) NSString *login_name;                   // 用户名
@property (nonatomic, copy) NSString<Optional> *levelname;          // 等级
@property (nonatomic, copy) NSString<Optional> *name;               // 昵称
@property (nonatomic, copy) NSString<Optional> *un_pay_orders;      // 未付款订单数
@property (nonatomic, copy) NSString<Optional> *un_ship_orders;     // 未发货订单数
@property (nonatomic, copy) NSString<Optional> *un_sign_orders;     // 未收货订单数
@property (nonatomic, copy) NSString<Optional> *nodiscuss_orders;   // 未评价订单数...<已无效>
@property (nonatomic, copy) NSString<Optional> *nodiscuss_goods;    // 未评价商品数
@property (nonatomic, copy) NSString<Optional> *favcount;           // 收藏数
@property (nonatomic, copy) NSString<Optional> *order_count;        // 订单总数
@property (nonatomic, strong) UserAccountModel<Optional> *advance;  // 账户相关

@end






