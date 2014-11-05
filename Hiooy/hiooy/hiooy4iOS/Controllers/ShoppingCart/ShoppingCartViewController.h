//
//  ShoppingCartViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  购物车首界面 

#import <UIKit/UIKit.h>
#import "CartCell.h"
#import "CartListModel.h"

@interface ShoppingCartViewController : BaseViewController <CartCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableviewCart;

@property (nonatomic, weak) IBOutlet UIView *viewBottom;
@property (nonatomic, weak) IBOutlet UIButton *btnTotal;
@property (nonatomic, weak) IBOutlet UILabel *lblTotal;
@property (nonatomic, weak) IBOutlet UILabel *lblDiscount;
@property (nonatomic, weak) IBOutlet UIButton *btnPay;

@property (nonatomic, strong) IBOutlet UIView *viewNoData;
@property (nonatomic, strong) IBOutlet UIButton *btnJump;

// 三个数据源需同步更新...~!@
@property (nonatomic, strong) NSMutableArray *arrayFooter;  // 每个section下对应的footer数据源
@property (nonatomic, strong) NSMutableArray *arrayCart;    // cell数据源
@property (nonatomic, strong) CartListModel *cart;          // 总的数据源<接口请求到的原始数据>

- (void)showUserLogin;
- (void)requestShoppingCartList;
- (IBAction)selectedAllGoods;
- (IBAction)jumpToPay;
- (IBAction)jumpToMainpage:(id)sender;

@end
