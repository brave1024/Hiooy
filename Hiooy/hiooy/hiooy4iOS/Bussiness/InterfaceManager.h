//
//  InterfaceManager.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-1.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  接口类

#import <Foundation/Foundation.h>
#import "WebService.h"
#import "AddCartRequestModel.h"
#import "CartSubmitRequestModel.h"
#import "ProductBuyRequestModel.h"
#import "AddressItemModel.h"
#import "AddressModel.h"
#import "CommentSubmitModel.h"

typedef void (^interfaceManagerBlock)(BOOL isSucceed, NSString *message, id data);

@interface InterfaceManager : NSObject

// 我的收藏
+ (void)getMyCollect:(NSString *)page completion:(interfaceManagerBlock)completion;

// 商品分类<包括顶级分类和子分类>
+ (void)getProductCategory:(NSString *)pid withPage:(NSString *)page completion:(interfaceManagerBlock)completion;

// 商品列表
+ (void)getProductList:(NSString *)pid withPage:(NSString *)page completion:(interfaceManagerBlock)completion;

// 精品频道
+ (void)getGoodProductList:(int)index completion:(interfaceManagerBlock)completion;

// 商品详情
+ (void)getProductDetail:(NSString *)pid completion:(interfaceManagerBlock)completion;

// 加入购物车
+ (void)addProductToShoppingCart:(AddCartRequestModel *)requestData completion:(interfaceManagerBlock)completion;

// 购物车列表
+ (void)getProductListInShoppingCart:(interfaceManagerBlock)completion;

// 购物车提交
+ (void)submitShoppingCart:(CartSubmitRequestModel *)cart completion:(interfaceManagerBlock)completion;

// 订单提交
//+ (void)submitOrder:(CartSubmitRequestModel *)cart completion:(interfaceManagerBlock)completion;
+ (void)submitOrder:(NSDictionary *)cart completion:(interfaceManagerBlock)completion;

// 订单支付
+ (void)payOrder:(NSString *)orderId withPayType:(NSString *)payId completion:(interfaceManagerBlock)completion;

// 删除购物项
+ (void)deleteProductInCart:(NSArray *)productArr completion:(interfaceManagerBlock)completion;

// 全部订单
+ (void)getAllOrder:(NSString *)page completion:(interfaceManagerBlock)completion;

// 待付款订单
+ (void)getOrderForUnpay:(NSString *)page completion:(interfaceManagerBlock)completion;

// 待发货订单
+ (void)getOrderForUnship:(NSString *)page completion:(interfaceManagerBlock)completion;

// 待收货订单
+ (void)getOrderForUnsign:(NSString *)page completion:(interfaceManagerBlock)completion;

// 待评价商品列表
+ (void)getOrderForUnComment:(NSString *)page completion:(interfaceManagerBlock)completion;

// 地区信息
+ (void)getAllArea:(interfaceManagerBlock)completion;

// 立即购买
+ (void)buyProductNow:(ProductBuyRequestModel *)goods completion:(interfaceManagerBlock)completion;

// 添加/修改收货地址
+ (void)addAddress:(AddressItemModel *)addrItem completion:(interfaceManagerBlock)completion;

// 收货地址列表
+ (void)getAddressList:(interfaceManagerBlock)completion;

// 删除收货地址
+ (void)deleteAddress:(AddressModel *)addr completion:(interfaceManagerBlock)completion;

// 设置默认收货地址
+ (void)settingDefaultAddress:(AddressModel *)addr completion:(interfaceManagerBlock)completion;

// 商品规格
+ (void)getProductParameters:(NSString *)goods_id completion:(interfaceManagerBlock)completion;

// 加入收藏
+ (void)addProductCollection:(NSString *)goods_id completion:(interfaceManagerBlock)completion;

// 取消收藏
+ (void)cancelProductCollection:(NSString *)goods_id completion:(interfaceManagerBlock)completion;

// 签收订单
+ (void)userReceiveOrder:(NSString *)orderId completion:(interfaceManagerBlock)completion;

// 商品评价
+ (void)userCommentProduct:(NSString *)productId withOrder:(NSString *)orderId completion:(interfaceManagerBlock)completion;

// 提交商品评论
+ (void)submitProductComment:(CommentSubmitModel *)comment completion:(interfaceManagerBlock)completion;

// 搜索
+ (void)searchProductWithKeyword:(NSString *)keyword completion:(interfaceManagerBlock)completion;

// 订单结算
+ (void)finishUnpayOrder:(NSString *)orderId completion:(interfaceManagerBlock)completion;

// 首页广告
+ (void)getAdsInHomepage:(interfaceManagerBlock)completion;

// 预付款消费记录
+ (void)getPayMoneyRecord:(NSString *)page completion:(interfaceManagerBlock)completion;

// 预存款充值方式
+ (void)getRechargeMethods:(interfaceManagerBlock)completion;

// 预存款充值提交
+ (void)RechargeAccount:(NSString *)money andPayType:(NSString *)pay completion:(interfaceManagerBlock)completion;

// 团购、秒杀列表
// 0团购 1秒杀
+ (void)getGroupOnList:(NSString *)page withType:(NSString *)type completion:(interfaceManagerBlock)completion;

// 团购、秒杀详情
+ (void)getGroupOnDetail:(NSString *)activityID completion:(interfaceManagerBlock)completion;

// 团购、秒杀之商品购买
+ (void)buyGrouponProduct:(NSString *)goods_id withProductId:(NSString *)product_id andNumber:(NSString *)number completion:(interfaceManagerBlock)completion;



@end
