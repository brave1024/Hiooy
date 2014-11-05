//
//  CartSubmitViewController.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  购物车提交界面

#import <UIKit/UIKit.h>
#import "CartSubmitRequestModel.h"
#import "CartResponseModel.h"
#import "AddressView.h"
#import "PayAndMemoView.h"

@interface CartSubmitViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, AddressViewDelegate, PayAndMemoViewDelegate>
{

//    NSMutableArray *arrayEdit;      //存放视图中可编辑的控件
//    KeyBoardTopBar *keyboardbar;    //
    
}

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet UIView *viewBottom;
@property (nonatomic, weak) IBOutlet UILabel *lblCount;
@property (nonatomic, weak) IBOutlet UILabel *lblMoney;
@property (nonatomic, weak) IBOutlet UIButton *btnSubmit;

@property (nonatomic, strong) CartSubmitRequestModel *cartSubmitReq;    // 购物车提交时的传参实体
@property (nonatomic, strong) CartResponseModel *cartSubmitRes;         // 购物车提交返回的数据实体
@property (nonatomic, strong) NSMutableArray *arrayCart;

@property (nonatomic, strong) PayAndMemoView *footview; // tableview下方的footview
@property (nonatomic, copy) NSString *strMemo;          // 备注

@property int type; // 0:立即购买 1:购物车购买 2:团购秒杀的立即购买

- (IBAction)submitBtnTouched:(id)sender;
- (void)requestCartSubmit;

@end
