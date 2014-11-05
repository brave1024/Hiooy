//
//  InterfaceManager.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-1.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "InterfaceManager.h"

@implementation InterfaceManager


// 我的收藏
+ (void)getMyCollect:(NSString *)page completion:(interfaceManagerBlock)completion
{
    NSString *memberId = [[UserManager shareInstant] getMemberId];
    if (memberId == nil || [memberId isEqualToString:@""] == YES)
    {
        completion(NO, @"请先登录", nil);
        return;
    }
    NSString *urlStr;
    NSString *pageStr;
    if (page == nil)
    {
        pageStr = @"";
    }
    else
    {
        pageStr = [NSString stringWithFormat:@"-%@", page];
    }
    urlStr = [NSString stringWithFormat:@"%@%@.html", API_USER_COLLECT, pageStr];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           memberId, @"member_id",nil];
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"获取我的收藏成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
    
}

// 商品分类
/*
 http://linux.hiooy.com/ecstore/index.php/wap/category-[ID]-[page].html
 ID为分类id，可为空，默认显示顶级分类
 page为第几页，可为空，默认第一页
 */
+ (void)getProductCategory:(NSString *)pid withPage:(NSString *)page completion:(interfaceManagerBlock)completion
{
    NSString *urlStr;
    NSString *pidStr;
    NSString *pageStr;
    if (pid == nil)
    {
        pidStr = @"";
    }
    else
    {
        pidStr = [NSString stringWithFormat:@"-%@", pid];
    }
    if (page == nil)
    {
        pageStr = @"";
    }
    else
    {
        pageStr = [NSString stringWithFormat:@"-%@", page];
    }
    urlStr = [NSString stringWithFormat:@"%@%@%@.html", API_PRODUCT_CATEGORY, pidStr, pageStr];

    [WebService RequestTest2:urlStr
                       param:nil
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"获取商品分类成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
    
}

// 商品列表
/*
 http://linux.hiooy.com/ecstore/index.php/wap/gallery-[ID]-[page].html
 ID为分类id，可为空，默认显示所有商品
 page为第几页，可为空，默认第一页
 */
+ (void)getProductList:(NSString *)pid withPage:(NSString *)page completion:(interfaceManagerBlock)completion
{
    NSString *urlStr;
    NSString *pidStr;
    NSString *pageStr;
    if (pid == nil)
    {
        pidStr = @"";
    }
    else
    {
        pidStr = [NSString stringWithFormat:@"-%@", pid];
    }
    if (page == nil)
    {
        pageStr = @"";
    }
    else
    {
        pageStr = [NSString stringWithFormat:@"-%@", page];
    }
    urlStr = [NSString stringWithFormat:@"%@%@%@.html", API_PRODUCT_LIST, pidStr, pageStr];
    
    [WebService RequestTest2:urlStr
                       param:nil
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"获取商品分类成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
    
}

// 精品频道
+ (void)getGoodProductList:(int)index completion:(interfaceManagerBlock)completion
{
    NSString *urlStr = @"gallery-index---0---1.html";   // 默认
    NSString *paramStr = nil;
    switch (index) {
        case 1:
            urlStr = @"gallery-index---0---1.html";
            break;
        case 2:
            urlStr = @"gallery-index---0---2.html";
            break;
        case 3:
            urlStr = @"gallery-index---0---3.html";
            break;
        case 4:
            urlStr = @"gallery-index---0---4.html";
            break;
        case 5: {   // 会员俱乐部(会员中心)...需会员id
            urlStr = @"member.html";
            NSString *memberId = [[UserManager shareInstant] getMemberId];
            if (memberId == nil || [memberId isEqualToString:@""] == YES)
            {
                completion(NO, @"请先登录", nil);
                return;
            }
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   memberId, @"member_id",nil];
            paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
            NSLog(@"paramStr:%@", paramStr);
            break;
        }
        case 6:
            urlStr = @"gallery-index---0---5.html";
            break;
        default:
            break;
    }
    
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"获取精品列表成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 商品详情
+ (void)getProductDetail:(NSString *)pid completion:(interfaceManagerBlock)completion
{
    NSString *paramStr = nil;
    
    // 判断是否已登录
    if ([[UserManager shareInstant] isLogin] == YES)
    {
        NSString *member_id = [[UserManager shareInstant] getMemberId];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               member_id, @"member_id", nil];
        paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
        NSLog(@"paramStr:%@", paramStr);
    }
    
    /**************************************************/
    
    NSString *urlStr;
    NSString *pidStr;
    if (pid == nil)
    {
        completion(NO, @"无商品id", nil);
        return;
    }
    else
    {
        pidStr = [NSString stringWithFormat:@"-%@", pid];
    }
    urlStr = [NSString stringWithFormat:@"%@%@.html", API_PRODUCT_DETAIL, pidStr];
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"获取商品详情成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
    
}

// 加入购物车
+ (void)addProductToShoppingCart:(AddCartRequestModel *)requestData completion:(interfaceManagerBlock)completion
{
    NSDictionary *param = [requestData toDictionary];
    NSLog(@"request dic:%@", param);
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_CART_ADD_PRODUCT
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"加入购物车成功", respond); // 返回原始json转的dic <{"status":"success","msg":"已加入购物车!","data":""}>
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
    
}

// 购物车列表
+ (void)getProductListInShoppingCart:(interfaceManagerBlock)completion
{
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:member_id, @"member_id",nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_CART_PRODUCT_LIST
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"加入购物车成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 购物车提交
+ (void)submitShoppingCart:(CartSubmitRequestModel *)cart completion:(interfaceManagerBlock)completion
{
    NSDictionary *param = [cart toDictionary];
    NSLog(@"request dic:%@", param);
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_CART_PRODUCT_SUBMIT
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"提交购物车成功", respond); // 返回原始json转的dic <{"status":"success","msg":"已加入购物车!","data":""}>
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
    
}


// 订单提交
+ (void)submitOrder:(NSDictionary *)cart completion:(interfaceManagerBlock)completion
{
    //NSDictionary *param = [cart toDictionary];
    //NSLog(@"request dic:%@", param);
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [cart convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_ORDER_SUBMIT
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"提交订单成功", respond); // 返回原始json转的dic <{"status":"success","msg":"已加入购物车!","data":""}>
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 订单支付
+ (void)payOrder:(NSString *)orderId withPayType:(NSString *)payId completion:(interfaceManagerBlock)completion
{
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id",
                           orderId, @"order_id",
                           payId, @"payment_app_id", nil];
    
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
//                           @"2", @"member_id",
//                           @"201405221881368", @"order_id",
//                           @"alipay", @"payment_app_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_ORDER_PAY
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"订单支付成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 删除购物项
+ (void)deleteProductInCart:(NSArray *)productArr completion:(interfaceManagerBlock)completion
{
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id",
                           productArr, @"obj_ident", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    /*
     {
     "member_id": "2",
     "obj_ident": "goods_113_122"
     }
     */
    
    [WebService RequestTest2:API_CART_DELETE
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"删除商品成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 全部订单
+ (void)getAllOrder:(NSString *)page completion:(interfaceManagerBlock)completion
{
    NSString *urlStr;
    if (page == nil)
    {
        urlStr = [NSString stringWithFormat:@"%@.html", API_USER_ORDER_ALL];
    }
    else
    {
        NSString *pageStr = [NSString stringWithFormat:@"-%@", page];
        urlStr = [NSString stringWithFormat:@"%@%@.html", API_USER_ORDER_ALL, pageStr];
    }
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:member_id, @"member_id",nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"全部订单请求成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 待付款订单
+ (void)getOrderForUnpay:(NSString *)page completion:(interfaceManagerBlock)completion
{
    NSString *urlStr;
    if (page == nil)
    {
        urlStr = [NSString stringWithFormat:@"%@-unpay.html", API_USER_ORDER_ALL];
    }
    else
    {
        NSString *pageStr = [NSString stringWithFormat:@"-%@", page];
        urlStr = [NSString stringWithFormat:@"%@%@-unpay.html", API_USER_ORDER_ALL, pageStr];
    }
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:member_id, @"member_id",nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"待付款订单请求成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 待发货订单
+ (void)getOrderForUnship:(NSString *)page completion:(interfaceManagerBlock)completion
{
    NSString *urlStr;
    if (page == nil)
    {
        urlStr = [NSString stringWithFormat:@"%@-unship.html", API_USER_ORDER_ALL];
    }
    else
    {
        NSString *pageStr = [NSString stringWithFormat:@"-%@", page];
        urlStr = [NSString stringWithFormat:@"%@%@-unship.html", API_USER_ORDER_ALL, pageStr];
    }
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:member_id, @"member_id",nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"全部订单请求成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 待收货订单
+ (void)getOrderForUnsign:(NSString *)page completion:(interfaceManagerBlock)completion
{
    NSString *urlStr;
    if (page == nil)
    {
        urlStr = [NSString stringWithFormat:@"%@-unsign.html", API_USER_ORDER_ALL];
    }
    else
    {
        NSString *pageStr = [NSString stringWithFormat:@"-%@", page];
        urlStr = [NSString stringWithFormat:@"%@%@-unsign.html", API_USER_ORDER_ALL, pageStr];
    }
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:member_id, @"member_id",nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"全部订单请求成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 待评价商品列表
+ (void)getOrderForUnComment:(NSString *)page completion:(interfaceManagerBlock)completion
{
//    NSString *urlStr;
//    if (page == nil)
//    {
//        urlStr = [NSString stringWithFormat:@"%@-unsign.html", API_USER_ORDER_ALL];
//    }
//    else
//    {
//        NSString *pageStr = [NSString stringWithFormat:@"-%@", page];
//        urlStr = [NSString stringWithFormat:@"%@%@-unsign.html", API_USER_ORDER_ALL, pageStr];
//    }
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:member_id, @"member_id",nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_PRODUCT_UNCOMMENT
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"待评价商品列表请求成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 地区信息
+ (void)getAllArea:(interfaceManagerBlock)completion
{
//    NSString *member_id = [[UserManager shareInstant] getMemberId];
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:member_id, @"member_id",nil];
//    
//    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
//    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_ADDRESS_AREA
                       param:nil
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"获取地区信息成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 立即购买
+ (void)buyProductNow:(ProductBuyRequestModel *)goods completion:(interfaceManagerBlock)completion
{
    //NSDictionary *param = [cart toDictionary];
    //NSLog(@"request dic:%@", param);
    
    NSDictionary *dic = [goods toDictionary];   // JsonModel数据实体转为dic
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [dic convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_PRODUCT_BUY_NOW
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"立即购买成功", respond); // 返回原始json转的dic <{"status":"success","msg":"已加入购物车!","data":""}>
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 添加收货地址
+ (void)addAddress:(AddressItemModel *)addrItem completion:(interfaceManagerBlock)completion
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[addrItem toDictionary]];
    [dic setObject:[[UserManager shareInstant] getMemberId] forKey:@"member_id"];
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [dic convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_ADD_ADDRESS
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             //completion(YES, @"添加收货地址成功", respond); // 返回原始json转的dic <{"status":"success","msg":"已加入购物车!","data":""}>
             if (addrItem.addr_id == nil || [addrItem.addr_id isEqualToString:@""] == YES)
             {
                 // 添加时,无id
                 completion(YES, @"添加收货地址成功", respond);
             }
             else
             {
                 // 编辑时,有id
                 completion(YES, @"编辑收货地址成功", respond);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 收货地址列表
+ (void)getAddressList:(interfaceManagerBlock)completion
{
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_GET_ADDRESS
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"收货地址列表获取成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 删除收货地址
+ (void)deleteAddress:(AddressModel *)addr completion:(interfaceManagerBlock)completion
{
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                         member_id, @"member_id",
                         addr.addr_id, @"addr_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_DELETE_ADDRESS
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"删除收货地址成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 设置默认收货地址
+ (void)settingDefaultAddress:(AddressModel *)addr completion:(interfaceManagerBlock)completion
{
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    /*
     http://linux.hiooy.com/ecstore/index.php/wap/member-set_default-[ID]-[disabled].html
     ID为收货地址addr_id（必填），
     disabled为设置默认或取消默认，2为设置默认1为取消默认（不填则视为1取消默认）
     */
    
    // 只可能为设置默认
    NSString *urlStr = [NSString stringWithFormat:@"%@-%@-2.html", API_USER_DEFAULT_ADDRESS, addr.addr_id];
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"设置默认收货地址成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 商品规格
+ (void)getProductParameters:(NSString *)goods_id completion:(interfaceManagerBlock)completion
{
    /*
     商品规格
     http://linux.hiooy.com/ecstore/index.php/wap/product-spec-[ID].html
     ID为商品goods_id
     */
    
    // 只可能为设置默认
    NSString *urlStr = [NSString stringWithFormat:@"%@-%@.html", API_CART_PRODUCT_PARAMETERS, goods_id];
    
    [WebService RequestTest2:urlStr
                       param:nil
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"获取商品规格成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 加入收藏
+ (void)addProductCollection:(NSString *)goods_id completion:(interfaceManagerBlock)completion
{
    /*
     加入收藏
     http://linux.hiooy.com/ecstore/index.php/wap/member-add_favorite-[ID].html
     ID为商品goods_id（必填）
     参数名：member_id
     */
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@-%@.html", API_PRODUCT_ADD_COLLECT, goods_id];
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"加入收藏成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 取消收藏
+ (void)cancelProductCollection:(NSString *)goods_id completion:(interfaceManagerBlock)completion
{
    /*
    取消收藏
    http://linux.hiooy.com/ecstore/index.php/wap/member-del_fav-[ID].html
    ID为商品goods_id（必填）
    参数名：member_id
    */
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@-%@.html", API_PRODUCT_CANCEL_COLLECT, goods_id];
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"取消收藏成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 签收订单
+ (void)userReceiveOrder:(NSString *)orderId completion:(interfaceManagerBlock)completion
{
    /*
     签收订单
     http://linux.hiooy.com/ecstore/index.php/wap/member-sign_order-[ID].html
     ID为订单id必填
     参数名：member_id
     */
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@-%@.html", API_USER_RECEIVE_ORDER, orderId];
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"签收成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 商品评价
+ (void)userCommentProduct:(NSString *)productId withOrder:(NSString *)orderId completion:(interfaceManagerBlock)completion
{
    /*
     评论商品
     http://linux.hiooy.com/ecstore/index.php/wap/member-comment-[order_id]-[product_id].html
     order_id 为订单号，必填
     product_id 为商品货品号，必填
     参数名：member_id
     */
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@-%@-%@.html", API_USER_COMMENT_PRODUCT, orderId, productId];
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"评论商品成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 提交商品评论
+ (void)submitProductComment:(CommentSubmitModel *)comment completion:(interfaceManagerBlock)completion
{
    NSDictionary *dic = [comment toDictionary];   // JsonModel数据实体转为dic
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [dic convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    /*
     提交商品评论
     http://linux.hiooy.com/ecstore/index.php/wap/member-toComment.html
     */
        
    [WebService RequestTest2:API_USER_SUBMIT_COMMENT
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"提交商品评论成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 搜索
+ (void)searchProductWithKeyword:(NSString *)keyword completion:(interfaceManagerBlock)completion
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           keyword, @"keyword", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_PRODUCT_SEARCH_KEYWORD
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"商品搜索成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 订单结算
+ (void)finishUnpayOrder:(NSString *)orderId completion:(interfaceManagerBlock)completion
{
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@-%@.html", API_USER_ORDER_FINISH, orderId];
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"订单结算成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 首页广告
+ (void)getAdsInHomepage:(interfaceManagerBlock)completion
{    
    [WebService RequestTest2:API_HOMEPAGE_ADS
                       param:nil
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"请求广告成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 预付款消费记录
+ (void)getPayMoneyRecord:(NSString *)page completion:(interfaceManagerBlock)completion
{
    NSString *urlStr;
    if (page == nil)
    {
        urlStr = [NSString stringWithFormat:@"%@.html", API_USER_PAY_RECORD];
    }
    else
    {
        NSString *pageStr = [NSString stringWithFormat:@"-%@", page];
        urlStr = [NSString stringWithFormat:@"%@%@.html", API_USER_PAY_RECORD, pageStr];
    }
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:member_id, @"member_id",nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"预存款消费列表请求成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 预存款充值方式
+ (void)getRechargeMethods:(interfaceManagerBlock)completion
{
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_RECHARGE_METHODS
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"预存款充值方式获取成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 预存款充值提交
+ (void)RechargeAccount:(NSString *)money andPayType:(NSString *)pay completion:(interfaceManagerBlock)completion
{
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id",
                           pay, @"payment_app_id",
                           money, @"money", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_RECHARGE_SUBMIT
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"预存款充值成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 团购、秒杀列表
+ (void)getGroupOnList:(NSString *)page withType:(NSString *)type completion:(interfaceManagerBlock)completion
{
    int myType = [type intValue];
    assert(myType == 0 || myType == 1);
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    NSString *urlStr;
    if (page == nil)
    {
        //urlStr = [NSString stringWithFormat:@"%@.html", API_PRODUCT_GROUPON_LIST];
        if (type == nil)
        {
            urlStr = [NSString stringWithFormat:@"%@.html", API_PRODUCT_GROUPON_LIST];
        }
        else
        {
            NSString *typeStr = [NSString stringWithFormat:@"-%@", type];
            urlStr = [NSString stringWithFormat:@"%@%@.html", API_PRODUCT_GROUPON_LIST, typeStr];
        }
    }
    else
    {
        //NSString *pageStr = [NSString stringWithFormat:@"-%@", page];
        //urlStr = [NSString stringWithFormat:@"%@%@.html", API_PRODUCT_GROUPON_LIST, pageStr];
        if (type == nil)
        {
            NSString *pageStr = [NSString stringWithFormat:@"-%@", page];
            urlStr = [NSString stringWithFormat:@"%@%@.html", API_PRODUCT_GROUPON_LIST, pageStr];
        }
        else
        {
            NSString *pageStr = [NSString stringWithFormat:@"-%@", page];
            NSString *typeStr = [NSString stringWithFormat:@"-%@", type];
            urlStr = [NSString stringWithFormat:@"%@%@%@.html", API_PRODUCT_GROUPON_LIST, pageStr, typeStr];
        }
    }
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"获取列表数据成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 团购、秒杀详情
+ (void)getGroupOnDetail:(NSString *)activityID completion:(interfaceManagerBlock)completion
{
    assert(activityID != nil);
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    NSString *urlStr;
    if (activityID == nil)
    {
        urlStr = [NSString stringWithFormat:@"%@.html", API_PRODUCT_GROUPON_DETAIL];
    }
    else
    {
        NSString *activityIDStr = [NSString stringWithFormat:@"-%@", activityID];
        urlStr = [NSString stringWithFormat:@"%@%@.html", API_PRODUCT_GROUPON_DETAIL, activityIDStr];
    }
    
    [WebService RequestTest2:urlStr
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"获取商品详情成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}

// 团购、秒杀之商品购买
+ (void)buyGrouponProduct:(NSString *)goods_id withProductId:(NSString *)product_id andNumber:(NSString *)number completion:(interfaceManagerBlock)completion
{
    assert(goods_id != nil && product_id != nil);
    
    if (number == nil)
    {
        number = @"1";
    }
    
    NSString *member_id = [[UserManager shareInstant] getMemberId];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           member_id, @"member_id",
                           goods_id, @"goods_id",
                           product_id, @"product_id",
                           number, @"num",
                           @"1", @"is_fast", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_PRODUCT_GROUPON_BUY
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"], nil);
         }
         else
         {
             completion(YES, @"立即购买成功", respond); // 返回原始json转的dic
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败", nil);
     }];
}



@end
