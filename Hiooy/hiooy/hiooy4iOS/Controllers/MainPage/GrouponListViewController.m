//
//  GrouponListViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-3.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "GrouponListViewController.h"
#import "GrouponTableViewCell.h"
#import "GrouponDetailViewController.h"

@interface GrouponListViewController ()

@end

@implementation GrouponListViewController

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
    
    self.navigationItem.title = @"团购";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navController showBackButtonWith:self];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    [self requestGrouponList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestGrouponList
{
    [self startLoading:kLoading];
    
    [InterfaceManager getGroupOnList:nil withType:@"0" completion:^(BOOL isSucceed, NSString *message, id data) {
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
            }
        }
        else
        {
            NSLog(@"%@", message);
        }
    }];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
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
    GrouponTableViewCell *cell = (GrouponTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [GrouponTableViewCell cellFromNib];
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
