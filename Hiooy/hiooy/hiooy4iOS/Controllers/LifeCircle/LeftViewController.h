//
//  LeftViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-17.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  生活圈...<已去掉>

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayData;

- (IBAction)showCenterView:(id)sender;

@end
