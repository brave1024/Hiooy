//
//  ProductUncommentViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  待评价商品列表界面

#import <UIKit/UIKit.h>
#import "OrderCommentModel.h"
#import "OrderListCell.h"
#import "OrderFootView.h"

@interface ProductUncommentViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, OrderFootViewDelegate, PullTableViewDelegate>

@property (nonatomic, strong) IBOutlet PullTableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) OrderCommentModel *commentList;
@property (nonatomic, strong) IBOutlet UIView *viewNoData;

@end
