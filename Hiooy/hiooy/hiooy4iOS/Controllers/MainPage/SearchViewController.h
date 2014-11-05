//
//  SearchViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-31.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  搜索

#import <UIKit/UIKit.h>
#import "ProductListModel.h"
#import "ProductListCell.h"

@interface SearchViewController : BaseViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) ProductListModel *productList;
@property (nonatomic, strong) IBOutlet UIView *viewNoData;

@end
