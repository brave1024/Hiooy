//
//  WebService.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "JSONModel.h"
#import "RespondModel.h"
#import "ResultModel.h"


//操作成功（网络请求成功，返回值Success = true,两个条件同时成立，才会回调该方法）
typedef void (^RequestSuccessBlock)(AFHTTPRequestOperation *operation, NSDictionary *respond);
//操作失败（网络原因的失败，或者返回值Success != true则执行下面的回调）
typedef void (^RequestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);


// 下面列举所有接口后缀...

// 注册
static NSString *const API_USER_REGISTER = @"passport-create.html";

// 登录
static NSString *const API_USER_LOGIN = @"passport-post_login.html";

// 登出
static NSString *const API_USER_LOGOUT = @"passport-logout.html";

// 修改密码
static NSString *const API_USER_CHANGE_PSW = @"member-save_security.html";

// 找回密码
static NSString *const API_USER_GET_PSW = @"passport-retrive_password.html";

// 会员中心
static NSString *const API_USER_CENTER = @"member.html";

// 我的收藏
static NSString *const API_USER_COLLECT = @"member-favorite";

// 商品分类
static NSString *const API_PRODUCT_CATEGORY = @"category";  // 需要拼接

// 商品列表
static NSString *const API_PRODUCT_LIST = @"gallery";  // 需要拼接

// 商品详情
static NSString *const API_PRODUCT_DETAIL = @"product";    // 需要拼接

// 加入购物车
static NSString *const API_CART_ADD_PRODUCT = @"cart-addToCart.html";

// 购物车列表
static NSString *const API_CART_PRODUCT_LIST = @"cart.html";

// 提交购物车
static NSString *const API_CART_PRODUCT_SUBMIT = @"cart-checkout.html";

// 提交订单
static NSString *const API_ORDER_SUBMIT = @"order-create.html";

// 支付订单
static NSString *const API_ORDER_PAY = @"order-dopayment.html";

// 删除购物车项
static NSString *const API_CART_DELETE = @"cart-removecart.html";

// 全部订单 及 其它状态订单
static NSString *const API_USER_ORDER_ALL = @"member-orders";

// 待评价商品列表
static NSString *const API_USER_PRODUCT_UNCOMMENT = @"member-nodiscuss.html";

// 地区信息
static NSString *const API_USER_ADDRESS_AREA = @"circle-get_regions.html";

// 立即购买
static NSString *const API_PRODUCT_BUY_NOW = @"cart-checkout.html";

// 添加收货地址
static NSString *const API_USER_ADD_ADDRESS = @"member-save_rec.html";

// 收货地址列表
static NSString *const API_USER_GET_ADDRESS = @"member-receiver.html";

// 删除收货地址
static NSString *const API_USER_DELETE_ADDRESS = @"member-del_receiver.html";

// 设置默认收货地址
static NSString *const API_USER_DEFAULT_ADDRESS = @"member-set_default";

//  商品规格
static NSString *const API_CART_PRODUCT_PARAMETERS = @"product-spec";

// 加入收藏
static NSString *const API_PRODUCT_ADD_COLLECT = @"member-add_favorite";

// 取消收藏
static NSString *const API_PRODUCT_CANCEL_COLLECT = @"member-del_fav";

// 签收订单
static NSString *const API_USER_RECEIVE_ORDER = @"member-sign_order";

// 商品评价
static NSString *const API_USER_COMMENT_PRODUCT = @"member-comment";

// 提交商品评价
static NSString *const API_USER_SUBMIT_COMMENT = @"member-toComment.html";

// 关键字搜索
static NSString *const API_PRODUCT_SEARCH_KEYWORD = @"gallery-search.html";

// 订单结算
static NSString *const API_USER_ORDER_FINISH = @"member-paycenter";

// 获取短信验证码
static NSString *const API_USER_MESSAGE_CODE = @"passport-send_code.html";

// 首页广告
static NSString *const API_HOMEPAGE_ADS = @"circle-home_pics.html";

// 预存款消费记录列表
static NSString *const API_USER_PAY_RECORD = @"member-balance";

// 预存款充值方式列表
static NSString *const API_USER_RECHARGE_METHODS = @"member-deposit.html";

// 预存款充值提交
static NSString *const API_USER_RECHARGE_SUBMIT = @"member-recharge.html";

// 团购、秒杀列表
static NSString *const API_PRODUCT_GROUPON_LIST = @"sales-lists";

// 团购、秒杀详情
static NSString *const API_PRODUCT_GROUPON_DETAIL = @"sales";

// 团购、秒杀之立即购买
static NSString *const API_PRODUCT_GROUPON_BUY = @"sales-checkout.html";

// 版本检测
//static NSString *const API_UPDATE_VERSION = @"updateversion";



@interface WebService : NSObject

// test
+ (void)RequestTest:(NSString *)action
              param:(NSDictionary *)param
        returnClass:(Class)returnClass
            success:(RequestSuccessBlock)sblock
            failure:(RequestFailureBlock)fblock;
// test2
+ (void)RequestTest2:(NSString *)action
               param:(NSString *)param
         returnClass:(Class)returnClass
             success:(RequestSuccessBlock)sblock
             failure:(RequestFailureBlock)fblock;

+ (void)RequestTest3:(NSString *)action
               param:(NSDictionary *)param;

/************************************************/

// get
+ (void)startGetRequest:(NSString *)action
                   body:(NSString *)body
            returnClass:(Class)returnClass
                success:(RequestSuccessBlock)sblock
                failure:(RequestFailureBlock)fblock;

// post
+ (void)startRequest:(NSString *)action
                body:(NSString *)body
         returnClass:(Class)returnClass
             success:(RequestSuccessBlock)sblock
             failure:(RequestFailureBlock)fblock;

// upload file
+ (void)startRequestForUpload:(NSString *)action
                         body:(NSString *)body
                     filePath:(NSString *)path
                  returnClass:(Class)returnClass
                      success:(RequestSuccessBlock)sblock
                      failure:(RequestFailureBlock)fblock;

// download file
+ (void)startDownload:(NSString *)remotePath
         withSavePath:(NSString *)localPath
              success:(RequestSuccessBlock)sblock
              failure:(RequestFailureBlock)fblock;

//+ (void)cancelRequest:(NSString*)m;

//+ (void)cancelAllRequest;


@end
