//
//  ShippingSelectViewController.h
//  hiooy
//
//  Created by retain on 14-4-25.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  配送方式选择

#import <UIKit/UIKit.h>
#import "CartResponseShippingModel.h"
#import "CartResponseItemModel.h"
#import "CartSubmitViewController.h"

@interface ShippingSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSArray *arrayData;
@property int sellerIndex;

@property (nonatomic, assign) CartSubmitViewController *cartSubmitVC;

@end
