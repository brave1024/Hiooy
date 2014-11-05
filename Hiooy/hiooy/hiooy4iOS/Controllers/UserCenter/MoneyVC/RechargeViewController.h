//
//  RechargeViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  预存款充值

#import <UIKit/UIKit.h>
#import "RechargeMethodModel.h"
#import "RechargeView.h"
#import "AliPayModel.h"
#import "AlipayOrderModel.h"

#import "AlixLibService.h"

@interface RechargeViewController : BaseViewController <UIActionSheetDelegate, UITextFieldDelegate, RechargeViewDelegate>
{
    SEL _result;
}

@property (nonatomic,assign) SEL result;    //这里声明为属性,方便在于外部传入

@property (nonatomic, weak) IBOutlet UIImageView *imgviewNumber;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewPay;
@property (nonatomic, weak) IBOutlet UITextField *txtfieldNumber;
//@property (nonatomic, weak) IBOutlet UITextField *txtfieldPay;
@property (nonatomic, weak) IBOutlet UIButton *btnPay;
@property (nonatomic, weak) IBOutlet UIView *viewPay;

@property (nonatomic, strong) RechargeMethodModel *rechargeList;
@property (nonatomic, strong) AliPayModel *alipayData;  // 预存款提交接口返回数据

@property (nonatomic, strong) NSMutableArray *arrayEdit;      // 存放视图中可编辑的控件
@property (nonatomic, strong) KeyBoardTopBar *keyboardbar;    //

@property (nonatomic, strong) AlipayOrderModel *alipayOrder;    // 支付宝快捷支付时,获取到的订单信息

//- (IBAction)selectPayMethod:(id)sender;
- (IBAction)btnPayAction:(id)sender;
- (void)paymentResult:(NSString *)result;

@end
