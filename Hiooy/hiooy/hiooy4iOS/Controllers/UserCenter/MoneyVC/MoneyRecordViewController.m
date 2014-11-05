//
//  MoneyRecordViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "MoneyRecordViewController.h"
#import "MoneyRecordTableViewCell.h"

@interface MoneyRecordViewController ()

@end

@implementation MoneyRecordViewController

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
    
    self.navigationItem.title = @"预存款消费记录";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    self.viewNoData.hidden = YES;
    
    // 请求数据
    [self requestRecordList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestRecordList
{
    [self startLoading:kLoading];
    
    [InterfaceManager getPayMoneyRecord:@"1" completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSLog(@"获取预存款消费记录成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            self.recordData = [[MoneyRecordModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析错误:%@", error);
                self.recordData = nil;
                self.arrayData = nil;
                self.viewNoData.hidden = NO;
                return;
            }
            self.arrayData = [NSMutableArray arrayWithArray: self.recordData.balance];
            
            if (self.recordData.balance == nil || self.recordData.balance.count == 0)
            {
                NSLog(@"当前无消费记录");
                self.viewNoData.hidden = NO;
            }
            else
            {
                NSLog(@"当前有消费记录");
                self.viewNoData.hidden = YES;
            }
            [self.tableview reloadData];
        }
        else
        {
            [self toast:message];
            self.recordData = nil;
            self.arrayData = nil;
            self.viewNoData.hidden = NO;
        }
    }];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
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
    NSString *identifier = @"recordCell";
    MoneyRecordTableViewCell *cell = (MoneyRecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [MoneyRecordTableViewCell cellFromNib];
    }
    
    // Configure the cell...
    RecordItemModel *item = [self.arrayData objectAtIndex:indexPath.row];
    [cell settingCell:item];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - Refresh and load more methods

- (void)refreshTable
{
    /*
     Code to actually refresh goes here.
     */
    self.tableview.pullTableIsRefreshing = NO;
}

- (void)loadMoreDataToTable
{
    [self startLoading:kLoading];
    
    int currentPage = [self.recordData.pager.current intValue];
    int totalpage = [self.recordData.pager.total intValue];
    
    if (currentPage == totalpage)
    {
        [self toast:kLoadOver];
        [self stopLoading];
        self.tableview.pullTableIsLoadingMore = NO;
    }
    else
    {
        [InterfaceManager getPayMoneyRecord:[NSString stringWithFormat:@"%d", currentPage+1] completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            self.tableview.pullTableIsLoadingMore = NO;
            if (isSucceed)
            {
                NSLog(@"获取预存款消费记录成功");
                NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                NSError *error = nil;
                self.recordData = [[MoneyRecordModel alloc] initWithDictionary:dataDic error:&error];
                if (error != nil)
                {
                    NSLog(@"json解析错误:%@", error);
                    return;
                }
                else
                {
                    NSLog(@"order count:%d", self.recordData.balance.count);
                    //self.arrayData = [NSMutableArray arrayWithArray:self.orderList.list];   // 订单数据源
                    [self.arrayData addObjectsFromArray:self.recordData.balance];
                    [self.tableview reloadData];
                }
            }
            else
            {
                [self toast:message];
            }
        }];
    }
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.0f];
}


@end
