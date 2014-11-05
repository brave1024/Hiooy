//
//  ProductCommentViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  评价列表界面

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

@interface ProductCommentViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) ProductDetailModel *product;
@property (nonatomic, strong) NSMutableArray *arrayComment;

@end
