//
//  AliPayPostModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-23.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  

#import <Foundation/Foundation.h>

@protocol AliPayPostModel <NSObject>

@end


@interface AliPayPostModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *_input_charset;
@property (nonatomic, copy) NSString<Optional> *agent;
@property (nonatomic, copy) NSString<Optional> *body;
@property (nonatomic, copy) NSString<Optional> *buyer_msg;
@property (nonatomic, copy) NSString<Optional> *logistics_fee;
@property (nonatomic, copy) NSString<Optional> *logistics_payment;
@property (nonatomic, copy) NSString<Optional> *logistics_type;
@property (nonatomic, copy) NSString<Optional> *notify_url;
@property (nonatomic, copy) NSString<Optional> *out_trade_no;
@property (nonatomic, copy) NSString<Optional> *partner;
@property (nonatomic, copy) NSString<Optional> *payment_type;
@property (nonatomic, copy) NSString<Optional> *price;
@property (nonatomic, copy) NSString<Optional> *quantity;
@property (nonatomic, copy) NSString<Optional> *return_url;
@property (nonatomic, copy) NSString<Optional> *seller_id;
@property (nonatomic, copy) NSString<Optional> *service;
@property (nonatomic, copy) NSString<Optional> *subject;
@property (nonatomic, copy) NSString<Optional> *sign;
@property (nonatomic, copy) NSString<Optional> *sign_type;

@end
