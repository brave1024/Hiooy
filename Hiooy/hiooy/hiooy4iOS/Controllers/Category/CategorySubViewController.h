//
//  CategorySubViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-10.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品分类子界面

#import <UIKit/UIKit.h>
#import "ProductCatItemModel.h"
#import "ProductSubCatListModel.h"

@interface CategorySubViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ProductCatItemModel *categoryItem;
@property (nonatomic, strong) ProductSubCatListModel *subCategory;

@property (nonatomic, strong) IBOutlet UITableView *tableview;

@end
