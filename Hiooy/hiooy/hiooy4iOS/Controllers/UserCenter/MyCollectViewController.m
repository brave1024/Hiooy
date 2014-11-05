//
//  MyCollectViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "MyCollectViewController.h"
#import "FavoriteModel.h"
#import "ProductDetailViewController.h"
#import "ProductModel.h"

@interface MyCollectViewController ()

@end

@implementation MyCollectViewController

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
    
    self.navigationItem.title = @"我的收藏";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.viewNoData.hidden = YES;
    
    [self requestMyCollect];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestMyCollect
{
    [self startLoading:kLoading];
    
    [InterfaceManager getMyCollect:@"1" completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSLog(@"%@", data);
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
            NSError *error = nil;
            self.favoriteList = [[FavoriteListModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                self.favoriteList = nil;
                self.arrayData = nil;
                self.viewNoData.hidden = NO;
                return;
                return;
            }
            NSLog(@"favorite number:%d", self.favoriteList.favorite.count);
            self.arrayData = [NSMutableArray arrayWithArray:self.favoriteList.favorite];
            [self.tableview reloadData];
            
            if (self.favoriteList.favorite == nil || self.favoriteList.favorite.count == 0)
            {
                self.viewNoData.hidden = NO;
            }
            else
            {
                self.viewNoData.hidden =  YES;
            }
        }
        else
        {
            NSLog(@"%@", message);
            [self toast:kGetDataFailed];
            self.favoriteList = nil;
            self.arrayData = nil;
            self.viewNoData.hidden = NO;
        }
    }];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    
    NSString *identifier = @"collectCell";
    CollectListCell *cell = (CollectListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [CollectListCell cellFromNib];
    }
    
    // Configure the cell...
    FavoriteModel *item = [self.arrayData objectAtIndex:indexPath.row];
    cell.lblTitle.text = item.name;
    //cell.lblPriceMarket.text = [NSString stringWithFormat:@"¥ %@", item.mktprice];
    cell.lblPrice.text = [NSString stringWithFormat:@"¥ %.2f", [item.price floatValue]];
    [cell.imgview setImageWithURL:[NSURL URLWithString:item.thumbnail_pic] placeholderImage:nil];
    if ([item.marketable isEqualToString:@"true"])
    {
        cell.lblMarket.text = @"已上架";
    }
    else
    {
        cell.lblMarket.text = @"未上架";
    }
    cell.lblCollect.text = [NSString stringWithFormat:@"%d 人收藏", [item.fav_count intValue]];
    cell.lblStore.text = [NSString stringWithFormat:@"%d", [item.store intValue]];
    
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
    
    // 进入商品详情界面
    FavoriteModel *item = [self.arrayData objectAtIndex:indexPath.row];
    ProductModel *product = [[ProductModel alloc] init];
    product.goods_id = item.goods_id; // 只需要传goods_id就行
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    detailVC.productModel = product;
    detailVC.fromCart = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - Refresh and load more methods

- (void)refreshTable
{
    /*
     Code to actually refresh goes here.
     */
    //self.tableview.pullTableIsRefreshing = NO;
    
    [self startLoading:kLoading];
    
    [InterfaceManager getMyCollect:@"1" completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        self.tableview.pullTableIsRefreshing = NO;
        if (isSucceed)
        {
            NSLog(@"%@", data);
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
            NSError *error = nil;
            self.favoriteList = [[FavoriteListModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            NSLog(@"favorite number:%d", self.favoriteList.favorite.count);
            self.arrayData = [NSMutableArray arrayWithArray:self.favoriteList.favorite];
            [self.tableview reloadData];
            
            if (self.favoriteList.favorite == nil || self.favoriteList.favorite.count == 0)
            {
                self.viewNoData.hidden = NO;
            }
            else
            {
                self.viewNoData.hidden =  YES;
            }
        }
        else
        {
            NSLog(@"%@", message);
            [self toast:kGetDataFailed];
        }
    }];
}

- (void)loadMoreDataToTable
{
    [self startLoading:kLoading];
    
    int currentPage = [self.favoriteList.pager.current intValue];
    int totalpage = [self.favoriteList.pager.total intValue];
    
    if (currentPage == totalpage)
    {
        [self toast:kLoadOver];
        [self stopLoading];
        self.tableview.pullTableIsLoadingMore = NO;
    }
    else
    {
        [InterfaceManager getMyCollect:[NSString stringWithFormat:@"%d", currentPage+1] completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            self.tableview.pullTableIsLoadingMore = NO;
            if (isSucceed)
            {
                NSLog(@"获取待评价商品成功");
                NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                NSError *error = nil;
                self.favoriteList = [[FavoriteListModel alloc] initWithDictionary:dataDic error:&error];
                if (error != nil)
                {
                    NSLog(@"json解析失败:%@", error);
                    return;
                }
                else
                {
                    NSLog(@"order count:%d", self.favoriteList.favorite.count);
                    [self.arrayData addObjectsFromArray:self.favoriteList.favorite];
                    [self.tableview reloadData];
                }
            }
            else
            {
                NSLog(@"%@", message);
                [self toast:@"获取待评价商品失败"];
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
