//
//  PaymentViewController.h
//  hiooy
//
//  Created by retain on 14-4-25.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  支付方式选择

#import <UIKit/UIKit.h>
#import "CartResponsePaymentModel.h"
#import "CartSubmitViewController.h"

@interface PaymentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSArray *arrayData;

@property (nonatomic, assign) CartSubmitViewController *cartSubmitVC;

@end
