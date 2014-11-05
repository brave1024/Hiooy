//
//  AlixPayOrder.h
//  AliPay
//
//  Created by WenBi on 11-5-18.
//  Copyright 2011 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlixPayOrder : NSObject {
	NSString * _partner;                    // partnerid
    NSString * _appName;                    //
    NSString * _bizType;                    //
	NSString * _seller;                     // sellerid
	NSString * _tradeNO;                    // 订单号/交易号
	NSString * _productName;                // 商品名称
	NSString * _productDescription;         // 商品描述
	NSString * _amount;                     // 商品数量
	NSString * _notifyURL;                  // 异步通知地址
    NSString * _serviceName;                // 接口名称（固定值）：默认为@"mobile.securitypay.pay"
    NSString * _inputCharset;               // 参数编码字符集（固定值）：默认为utf-8
    NSString * _returnUrl;                  // 跳转地址
    NSString * _paymentType;                // 支付类型：默认为1-商品购买
    NSString * _itBPay;                     // 未付款交易的超时时间
    NSString * _showUrl;                    // 商品展示地址
	NSMutableDictionary * _extraParams;     // 额外信息
}

@property(nonatomic,copy) NSString *appName;
@property (nonatomic,copy) NSString *bizType;
@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller;
@property(nonatomic, copy) NSString * tradeNO;
@property(nonatomic, copy) NSString * productName;
@property(nonatomic, copy) NSString * productDescription;
@property(nonatomic, copy) NSString * amount;
@property(nonatomic, copy) NSString * notifyURL;
@property(nonatomic, copy) NSString * serviceName;
@property(nonatomic, copy) NSString * inputCharset;
@property(nonatomic, copy) NSString * returnUrl;
@property(nonatomic, copy) NSString * paymentType;
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;

@property(nonatomic, readonly) NSMutableDictionary * extraParams;

@end
