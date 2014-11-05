//
//  AddrListViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  收货地址列表

#import <UIKit/UIKit.h>
#import "AddrInfoCell.h"
#import "AddressListModel.h"

@interface AddrListViewController : BaseViewController <AddrInfoCellDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AddressListModel *addressList;

@end
