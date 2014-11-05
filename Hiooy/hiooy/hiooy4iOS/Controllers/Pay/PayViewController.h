//
//  PayViewController.h
//  hiooy
//
//  Created by retain on 14-4-28.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  支付

#import <UIKit/UIKit.h>
#import "CartSubmitResponseModel.h"
#import "PayProductView.h"
#import "OrderUnpayResModel.h"
#import "AliPayModel.h"
#import "AlipayOrderModel.h"

#import "AlixLibService.h"

@interface PayViewController : BaseViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    SEL _result;
}

@property (nonatomic,assign) SEL result;    //这里声明为属性,方便在于外部传入

@property (nonatomic, weak) IBOutlet UIScrollView *scrollview;

@property (nonatomic, weak) IBOutlet UIView *viewOrder;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewTop;

@property (nonatomic, weak) IBOutlet UIView *viewPay;
@property (nonatomic, weak) IBOutlet UITableView *tableviewPay;

@property (nonatomic, weak) IBOutlet UIView *viewBottom;
@property (nonatomic, weak) IBOutlet UILabel *lblMoney;
@property (nonatomic, weak) IBOutlet UIButton *btnPay;

@property (nonatomic, strong) CartSubmitResponseModel *orderData;   // 上个界面订单提交成功后返回的数据实体
@property (nonatomic, strong) CartResponsePaymentModel *payType;    // 当前被选中的支付方式实体

@property (nonatomic, strong) OrderUnpayResModel *orderDataAnother; // 上个界面订单结算传递过来的数据实体
@property int type; // 0:从订单提交界面跳转过来<流程依次为：购物车提交、订单生成、订单提交>  1:从待付款订单界面跳转过来

@property (nonatomic, strong) AliPayModel *alipayData;          // 通联支付时，获取到的通联支付url
@property (nonatomic, strong) AlipayOrderModel *alipayOrder;    // 支付宝快捷支付时,获取到的订单信息

- (IBAction)payAction:(id)sender;
- (void)paymentResult:(NSString *)result;

@end
