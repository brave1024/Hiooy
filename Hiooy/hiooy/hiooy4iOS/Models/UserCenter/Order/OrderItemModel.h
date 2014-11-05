//
//  OrderItemModel.h
//  hiooy
//
//  Created by retain on 14-5-6.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  单个订单实体

#import <Foundation/Foundation.h>
#import "OrderGoodsModel.h"

@protocol OrderItemModel <NSObject>

@end

@interface OrderItemModel : JSONModel

@property (nonatomic, copy) NSString *order_id;                     // 订单ID号
@property (nonatomic, copy) NSString<Optional> *final_amount;       // 订单金额
@property (nonatomic, copy) NSString<Optional> *createtime;         // 创建时间
@property (nonatomic, copy) NSString<Optional> *orderdetail_url;    // 订单详情地址
@property (nonatomic, copy) NSString<Optional> *pay_status;         // 订单付款状态...<无效>
@property (nonatomic, copy) NSString<Optional> *ship_status;        // 订单发货状态...<无效>
@property (nonatomic, copy) NSString<Optional> *status;             // 订单状态（活动，完成，取消）
@property (nonatomic, copy) NSString<Optional> *order_type;         // 订单实际状态：0-待付款 1-待发货 2-待签收 3-已签收 4-部分发货 5-已退货 6-部分付款 7-全额退款 8-已完成 9-已取消
@property (nonatomic, copy) NSString<Optional> *seller_id;          // 商户id
@property (nonatomic, copy) NSString<Optional> *seller_name;        // 商户名称
@property (nonatomic, strong) NSArray<OrderGoodsModel> *goods;      // 商品信息<可能有多个>

/*
{
    createtime = "2014-05-13 14:28";
    "final_amount" = "399.000";
    goods =             (
                         {
                             amount = "399.000";
                             "goods_id" = 63;
                             "image_url" = "http://linux.hiooy.com/ecstore/public/images/47/f5/54/3b7cbdfcd7bdcf0b065b841a0495f49c.jpg?1397723424#h";
                             name = "EITIE\U7231\U7279\U7231B 2013\U79cb\U5b63\U65b0\U6b3e \U5973\U7f51\U7eb1\U9ad8\U9886\U767e\U642d\U9488\U7ec7\U886b\U6bdb\U88633401109 TM";
                             nums = 1;
                             price = "399.000";
                             "product_id" = 72;
                         }
                         );
    "order_id" = 1405131428678221;
    "order_type" = 0;
    "orderdetail_url" = "/ecstore/index.php/wap/member-orderdetail-1405131428678221.html";
    "seller_id" = 18;
    "seller_name" = "\U5973\U88c5\U4e13\U5356";
    status = "\U6d3b\U52a8";
}
*/

@end
