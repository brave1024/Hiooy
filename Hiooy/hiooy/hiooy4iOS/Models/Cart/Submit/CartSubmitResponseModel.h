//
//  CartSubmitResponseModel.h
//  hiooy
//
//  Created by retain on 14-4-28.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  订单提交接口返回的数据实体

#import <Foundation/Foundation.h>
#import "CartResponsePaymentModel.h"
#import "PayProductModel.h"

@interface CartSubmitResponseModel : JSONModel

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *pay_money;
@property (nonatomic, strong) NSArray<CartResponsePaymentModel> *payments;
@property (nonatomic, strong) NSArray<PayProductModel> *goodslist;

@end


/*
{
    "status": "success",
    "msg": "订单生成成功！",
    "data": {
        "order_id": "201404281884088",
        "payments": [
                     {
                         "app_name": "手机支付宝",
                         "app_id": "malipay",
                         "choosed": "true"
                     },
                     {
                         "app_name": "预存款支付",
                         "app_id": "deposit",
                         "choosed": "false"
                     },
                     {
                         "app_name": "线下支付",
                         "app_id": "offline",
                         "choosed": "false"
                     }
                     ],
        "goodslist": [
                      {
                          "name": "HIM汉崇 2014春装新款 同步男士衬衫极简条纹修身蓝色401362BL",
                          "nums": "10",
                          "price": "150.000",
                          "amount": "1500.000"
                      },
                      {
                          "name": "【三星专卖店】Samsung/三星 GALAXY Note3",
                          "nums": "1",
                          "price": "4000.000",
                          "amount": "4000.000"
                      },
                      {
                          "name": "【三星专卖店】Samsung/三星 SM-G7109",
                          "nums": "1",
                          "price": "2468.000",
                          "amount": "2468.000"
                      },
                      {
                          "name": "【三星专卖店】SAMSUNG/三星G7108",
                          "nums": "1",
                          "price": "2188.000",
                          "amount": "2188.000"
                      }
                      ],
        "pay_money": "10156.00"
    }
}
*/



