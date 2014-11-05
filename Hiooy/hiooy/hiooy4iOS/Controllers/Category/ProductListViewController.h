//
//  ProductListViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品列表

#import <UIKit/UIKit.h>
#import "ProductCatItemModel.h"
#import "ProductListModel.h"
#import "ProductListCell.h"

@interface ProductListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ProductCatItemModel *categoryItem;    // 最终的商品分类实体
@property (nonatomic, strong) ProductListModel *productList;        // 返回的商品列表实体
@property int listType;                         // 判断是从首页精品频道跳转过来 还是 从商品分类界面跳转过来
@property (nonatomic, copy) NSString *titleStr; // 当前商品列表界面的标题

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segment;

@end
