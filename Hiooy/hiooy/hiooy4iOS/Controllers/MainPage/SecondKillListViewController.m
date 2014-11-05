//
//  SecondKillListViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-3.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "SecondKillListViewController.h"
#import "SecondKillTableViewCell.h"
#import "SecondKillDetailViewController.h"
#import "GrouponDetailViewController.h"

@interface SecondKillListViewController ()

@end

@implementation SecondKillListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"秒杀";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //[self.navController showBackButtonWith:self];
    
    // 返回
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 6, 48, 32);
    //[btnBack setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    //[btnBack setImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [btnBack setImage:[UIImage imageNamed:@"back_ico_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_ico_press"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    btnBack.imageEdgeInsets = UIEdgeInsetsMake(-1, -30, 0, 0);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTime:) name:kTimePass object:nil];
    
    [self requestSecondKillList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestSecondKillList
{
    [self startLoading:kLoading];
    
    [InterfaceManager getGroupOnList:nil withType:@"1" completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSDictionary *dic = [(NSDictionary *)data objectForKey:@"data"];
            NSError *error = nil;
            self.listModel = [[ActivityListModel alloc] initWithDictionary:dic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析错误:%@", error);
            }
            else
            {
                NSLog(@"product number:%d", self.listModel.sales.count);
                self.arrayData = [[NSMutableArray alloc] initWithArray:self.listModel.sales];
                [self.tableview reloadData];
                
                self.rTime = 0;
//                self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
//                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
//                AppDelegate *appDelegate = kAppDelegate;
//                [appDelegate beginTimePassAction];
            }
        }
        else
        {
            NSLog(@"%@", message);
        }
    }];
}

- (void)timeChanged
{
    self.rTime++;
    NSLog(@"...<<<%d>>>...", self.rTime);
    
    // 刷新当前流逝的秒数
    for (int i = 0; i < self.arrayData.count; i++)
    {
        ActivityItemModel *model = [self.arrayData objectAtIndex:i];
        model.passTime = [NSString stringWithFormat:@"%d", self.rTime];
    }
    [self.tableview reloadData];
}

//- (void)refreshTime:(NSNotification *)notification
//{
//    NSNumber *number = [notification.userInfo objectForKey:@"time"];
//    
//    // 刷新当前流逝的秒数
//    for (int i = 0; i < self.arrayData.count; i++)
//    {
//        ActivityItemModel *model = [self.arrayData objectAtIndex:i];
//        model.passTime = [NSString stringWithFormat:@"%d", [number intValue]];
//    }
//    [self.tableview reloadData];
//}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"categoryInfo";
    SecondKillTableViewCell *cell = (SecondKillTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [SecondKillTableViewCell cellFromNib];
    }
    
    // Configure the cell...
    ActivityItemModel *model = [self.arrayData objectAtIndex:indexPath.row];
    [cell settingCell:model];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GrouponDetailViewController *DetailVC = [[GrouponDetailViewController alloc] initWithNibName:@"GrouponDetailViewController" bundle:nil];
    DetailVC.activityItem = [self.arrayData objectAtIndex:indexPath.row];
    //[self.tabBarController.navigationController pushViewController:DetailVC animated:YES];
    [self.navigationController pushViewController:DetailVC animated:YES];
}



@end
