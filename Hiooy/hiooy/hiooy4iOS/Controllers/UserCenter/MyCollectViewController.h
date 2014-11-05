//
//  MyCollectViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  我的收藏

#import <UIKit/UIKit.h>
#import "FavoriteListModel.h"
#import "CollectListCell.h"

@interface MyCollectViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@property (nonatomic, weak) IBOutlet PullTableView *tableview;
@property (nonatomic, strong) FavoriteListModel *favoriteList;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, weak) IBOutlet UIView *viewNoData;

@end
