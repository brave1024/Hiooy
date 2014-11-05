//
//  CategoryViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-10.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品分类主界面

#import <UIKit/UIKit.h>
#import "SectionInfo.h"
#import "HeaderView.h"
#import "ProductCatListModel.h"

@interface CategoryViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, HeaderViewDelegte>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayCategory;
@property (nonatomic, strong) ProductCatListModel *categoryList;    // 分类实体

@end
