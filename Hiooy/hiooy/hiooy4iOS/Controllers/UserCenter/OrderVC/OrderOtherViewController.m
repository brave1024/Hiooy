//
//  OrderOtherViewController.m
//  hiooy
//
//  Created by retain on 14-5-7.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "OrderOtherViewController.h"
#import "OrderHeadView.h"
#import "ProductModel.h"
#import "ProductDetailViewController.h"
#import "OrderUnpayResModel.h"
#import "PayViewController.h"

@interface OrderOtherViewController ()

@end

@implementation OrderOtherViewController

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
    
    //self.navigationItem.title = @"全部订单";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableview.tag = 2; // 无刷新
    
    self.viewNoData.hidden = YES;
    
    // 请求订单
    [self requestOrderType:self.tag];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configWithData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dicForWeb = (NSDictionary *)data;
        //NSString *navTitle = [dicForWeb objectForKey:@"navTitle"];
        //NSString *webUrl = [dicForWeb objectForKey:@"webUrl"];
        NSString *vcId = [dicForWeb objectForKey:@"vcId"];
        int tag = [vcId intValue];
        self.tag = tag;
        if (tag == 0)
        {
            self.navigationItem.title = @"待付款订单";
        }
        else if (tag == 1)
        {
            self.navigationItem.title = @"待发货订单";
        }
        else if (tag == 2)
        {
            self.navigationItem.title = @"待收货订单";
        }
//        else if (tag == 3)
//        {
//            self.navigationItem.title = @"待评价商品";
//        }
    }
}

// 请求订单
- (void)requestOrderType:(int)tag
{
    if (tag > 2 || tag < 0)
    {
        return;
    }
    
    [self startLoading:kLoading];
    
    switch (tag) {
        case 0: // 待付款
        {
            [InterfaceManager getOrderForUnpay:@"1" completion:^(BOOL isSucceed, NSString *message, id data) {
                [self stopLoading];
                if (isSucceed)
                {
                    NSLog(@"获取待付款订单成功");
                    NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                    NSError *error = nil;
                    self.orderList = [[OrderInfoModel alloc] initWithDictionary:dataDic error:&error];
                    if (error != nil)
                    {
                        NSLog(@"json解析失败:%@", error);
                        return;
                    }
                    else
                    {
                        NSLog(@"order count:%d", self.orderList.list.count);
                        self.arrayData = [NSMutableArray arrayWithArray:self.orderList.list];   // 订单数据源
                        [self.tableview reloadData];
                        
                        // TEST
//                        self.orderList.list = nil;
//                        self.arrayData = nil;
//                        [self.tableview reloadData];
                        
                        if (self.orderList.list == nil || self.orderList.list.count == 0)
                        {
                            self.viewNoData.hidden = NO;
                        }
                    }
                }
                else
                {
                    NSLog(@"%@", message);
                    [self toast:@"获取待付款订单失败"];
                    self.orderList = nil;
                    self.arrayData = nil;
                    self.viewNoData.hidden = NO;
                }
            }];
            break;
        }
        case 1: // 待发货
        {
            [InterfaceManager getOrderForUnship:@"1" completion:^(BOOL isSucceed, NSString *message, id data) {
                [self stopLoading];
                if (isSucceed)
                {
                    NSLog(@"获取待发货订单成功");
                    NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                    NSError *error = nil;
                    self.orderList = [[OrderInfoModel alloc] initWithDictionary:dataDic error:&error];
                    if (error != nil)
                    {
                        NSLog(@"json解析失败:%@", error);
                        return;
                    }
                    else
                    {
                        NSLog(@"order count:%d", self.orderList.list.count);
                        self.arrayData = [NSMutableArray arrayWithArray:self.orderList.list];   // 订单数据源
                        [self.tableview reloadData];
                        
                        if (self.orderList.list == nil || self.orderList.list.count == 0)
                        {
                            self.viewNoData.hidden = NO;
                        }
                    }
                }
                else
                {
                    NSLog(@"%@", message);
                    [self toast:@"获取待发货订单失败"];
                    self.orderList = nil;
                    self.arrayData = nil;
                    self.viewNoData.hidden = NO;
                }
            }];
            break;
        }
        case 2: // 待收货
        {
            [InterfaceManager getOrderForUnsign:@"1" completion:^(BOOL isSucceed, NSString *message, id data) {
                [self stopLoading];
                if (isSucceed)
                {
                    NSLog(@"获取待收货订单成功");
                    NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                    NSError *error = nil;
                    self.orderList = [[OrderInfoModel alloc] initWithDictionary:dataDic error:&error];
                    if (error != nil)
                    {
                        NSLog(@"json解析失败:%@", error);
                        return;
                    }
                    else
                    {
                        NSLog(@"order count:%d", self.orderList.list.count);
                        self.arrayData = [NSMutableArray arrayWithArray:self.orderList.list];   // 订单数据源
                        [self.tableview reloadData];
                        
                        if (self.orderList.list == nil || self.orderList.list.count == 0)
                        {
                            self.viewNoData.hidden = NO;
                        }
                    }
                }
                else
                {
                    NSLog(@"%@", message);
                    [self toast:@"获取待收货订单失败"];
                    self.orderList = nil;
                    self.arrayData = nil;
                    self.viewNoData.hidden = NO;
                }
            }];
            break;
        }
//        case 3: // 待评价
//        {
//            [InterfaceManager getOrderForUnComment:@"1" completion:^(BOOL isSucceed, NSString *message, id data) {
//                [self stopLoading];
//                if (isSucceed)
//                {
//                    NSLog(@"获取待评价商品成功");
//                    NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
//                    NSError *error = nil;
//                    self.commentList = [[OrderCommentModel alloc] initWithDictionary:dataDic error:&error];
//                    if (error != nil)
//                    {
//                        NSLog(@"json解析失败:%@", error);
//                        return;
//                    }
//                    else
//                    {
//                        NSLog(@"order count:%d", self.commentList.list.count);
//                        self.arrayData = [NSMutableArray arrayWithArray:self.commentList.list];   // 订单数据源
//                        [self.tableview reloadData];
//                        
//                        if (self.commentList.list == nil || self.commentList.list.count == 0)
//                        {
//                            self.viewNoData.hidden = NO;
//                        }
//                    }
//                }
//                else
//                {
//                    NSLog(@"%@", message);
//                    [self toast:@"获取待评价商品失败"];
//                    self.orderList = nil;
//                    self.arrayData = nil;
//                    self.viewNoData.hidden = NO;
//                }
//            }];
//            break;
//        }
        default:
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //OrderItemModel *item = [self.orderList.list objectAtIndex:section];
    OrderItemModel *item = [self.arrayData objectAtIndex:section];
    return item.goods.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"OrderInfo";
    OrderListCell *cell = (OrderListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [OrderListCell cellFromNib];
    }
    
    // Configure the cell...
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    OrderItemModel *item = [self.arrayData objectAtIndex:indexPath.section];
    OrderGoodsModel *goods = [item.goods objectAtIndex:indexPath.row];
    [cell settingCell:goods];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 78.0;
    }
    return 68.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //OrderItemModel *item = [self.orderList.list objectAtIndex:section];
    OrderItemModel *item = [self.arrayData objectAtIndex:section];
    
    if (section == 0)
    {
        UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 78)];
        viewBG.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 68)];
        view.backgroundColor = [UIColor clearColor];
        
        OrderHeadView *headerView = [OrderHeadView viewFromNib];
        headerView.frame = CGRectMake(0, 0, 320, 68);
        [headerView settingView:item];
        
        [view addSubview:headerView];
        [viewBG addSubview:view];
        return viewBG;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 68)];
    view.backgroundColor = [UIColor clearColor];
    
    OrderHeadView *headerView = [OrderHeadView viewFromNib];
    headerView.frame = CGRectMake(0, 0, 320, 68);
    [headerView settingView:item];
    
    [view addSubview:headerView];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 68.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //OrderItemModel *item = [self.orderList.list objectAtIndex:section];
    OrderItemModel *item = [self.arrayData objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    view.backgroundColor = [UIColor clearColor];
    
    OrderFootView *footView = [OrderFootView viewFromNib];
    footView.delegate = self;
    footView.tag = section;
    footView.frame = CGRectMake(0, 0, 320, 58);
    [footView settingView:item];
    
    [view addSubview:footView];
    return view;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 进入商品详情界面
    OrderItemModel *item = [self.arrayData objectAtIndex:indexPath.section];
    OrderGoodsModel *goods = [item.goods objectAtIndex:indexPath.row];
    ProductModel *product = [[ProductModel alloc] init];
    product.goods_id = goods.goods_id; // 只需要传goods_id就行
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    detailVC.productModel = product;
    detailVC.fromCart = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - OrderFootViewDelegate

- (void)confirmReceiveProducts:(id)view
{
    OrderFootView *footview = (OrderFootView *)view;
    int tag = footview.tag;
    NSLog(@"section:%d", tag);
    
    if (self.tag == 0)
    {
        // 结算
        [self startLoading:kLoading];
        OrderItemModel *item = [self.arrayData objectAtIndex:tag];
        [InterfaceManager finishUnpayOrder:item.order_id completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            if (isSucceed)
            {
                NSLog(@"%@", message);
                NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                NSError *error = nil;
                OrderUnpayResModel *result = [[OrderUnpayResModel alloc] initWithDictionary:dataDic error:&error];
                if (error != nil)
                {
                    NSLog(@"json解析失败:%@", error);
                    return;
                }
                PayViewController *payVC = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
                payVC.type = 1; // 从待付款订单中进行支付界面
                payVC.orderDataAnother = result;
                payVC.orderData = nil;
                [self.navigationController pushViewController:payVC animated:YES];
            }
            else
            {
                [self toast:message];
            }
        }];
    }
    else if (self.tag == 1)
    {
        // 提醒商家发货
        // 无此接口功能
    }
    else if (self.tag == 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否签收?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = tag;
        [alert show];
    }
}

- (void)refreshData:(int)tag
{
    // 删除当前tag索引处的订单元素
    [self.arrayData removeObjectAtIndex:tag];
    [self.tableview reloadData];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //
    }
    else
    {
        int tag = alertView.tag;
        // 签收
        [self startLoading:kLoading];
        OrderItemModel *item = [self.arrayData objectAtIndex:tag];
        [InterfaceManager userReceiveOrder:item.order_id completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            if (isSucceed)
            {
                NSLog(@"签收成功");
                [self toast:message];
                // 刷新tableview
                [self refreshData:tag];
                // 刷新个人中心数据
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserCenter object:nil];
            }
            else
            {
                NSLog(@"签收失败");
                [self toast:message];
            }
        }];
    }
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
    
    int currentPage = [self.orderList.pager.current intValue];
    int totalpage = [self.orderList.pager.total intValue];
    
    if (currentPage == totalpage)
    {
        [self toast:kLoadOver];
        [self stopLoading];
        self.tableview.pullTableIsLoadingMore = NO;
    }
    else
    {
        switch (self.tag) {
            case 0: // 待付款
            {
                [InterfaceManager getOrderForUnpay:[NSString stringWithFormat:@"%d", currentPage+1] completion:^(BOOL isSucceed, NSString *message, id data) {
                    [self stopLoading];
                    self.tableview.pullTableIsLoadingMore = NO;
                    if (isSucceed)
                    {
                        NSLog(@"获取待付款订单成功");
                        NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                        NSError *error = nil;
                        self.orderList = [[OrderInfoModel alloc] initWithDictionary:dataDic error:&error];
                        if (error != nil)
                        {
                            NSLog(@"json解析失败:%@", error);
                            return;
                        }
                        else
                        {
                            NSLog(@"order count:%d", self.orderList.list.count);
                            //self.arrayData = [NSMutableArray arrayWithArray:self.orderList.list];   // 订单数据源
                            [self.arrayData addObjectsFromArray:self.orderList.list];
                            [self.tableview reloadData];
                        }
                    }
                    else
                    {
                        NSLog(@"%@", message);
                        [self toast:@"获取待付款订单失败"];
                    }
                }];
                break;
            }
            case 1: // 待发货
            {
                [InterfaceManager getOrderForUnship:[NSString stringWithFormat:@"%d", currentPage+1] completion:^(BOOL isSucceed, NSString *message, id data) {
                    [self stopLoading];
                    self.tableview.pullTableIsLoadingMore = NO;
                    if (isSucceed)
                    {
                        NSLog(@"获取待发货订单成功");
                        NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                        NSError *error = nil;
                        self.orderList = [[OrderInfoModel alloc] initWithDictionary:dataDic error:&error];
                        if (error != nil)
                        {
                            NSLog(@"json解析失败:%@", error);
                            return;
                        }
                        else
                        {
                            NSLog(@"order count:%d", self.orderList.list.count);
                            //self.arrayData = [NSMutableArray arrayWithArray:self.orderList.list];   // 订单数据源
                            [self.arrayData addObjectsFromArray:self.orderList.list];
                            [self.tableview reloadData];
                        }
                    }
                    else
                    {
                        NSLog(@"%@", message);
                        [self toast:@"获取待发货订单失败"];
                    }
                }];
                break;
            }
            case 2: // 待收货
            {
                [InterfaceManager getOrderForUnsign:[NSString stringWithFormat:@"%d", currentPage+1] completion:^(BOOL isSucceed, NSString *message, id data) {
                    [self stopLoading];
                    self.tableview.pullTableIsLoadingMore = NO;
                    if (isSucceed)
                    {
                        NSLog(@"获取待收货订单成功");
                        NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                        NSError *error = nil;
                        self.orderList = [[OrderInfoModel alloc] initWithDictionary:dataDic error:&error];
                        if (error != nil)
                        {
                            NSLog(@"json解析失败:%@", error);
                            return;
                        }
                        else
                        {
                            NSLog(@"order count:%d", self.orderList.list.count);
                            //self.arrayData = [NSMutableArray arrayWithArray:self.orderList.list];   // 订单数据源
                            [self.arrayData addObjectsFromArray:self.orderList.list];
                            [self.tableview reloadData];
                        }
                    }
                    else
                    {
                        NSLog(@"%@", message);
                        [self toast:@"获取待收货订单失败"];
                    }
                }];
                break;
            }
//            case 3: // 待评价
//            {
//                [InterfaceManager getOrderForUnpay:[NSString stringWithFormat:@"%d", currentPage+1] completion:^(BOOL isSucceed, NSString *message, id data) {
//                    [self stopLoading];
//                    self.tableview.pullTableIsLoadingMore = NO;
//                    if (isSucceed)
//                    {
//                        NSLog(@"获取待评价订单成功");
//                        NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
//                        NSError *error = nil;
//                        self.orderList = [[OrderInfoModel alloc] initWithDictionary:dataDic error:&error];
//                        if (error != nil)
//                        {
//                            NSLog(@"json解析失败:%@", error);
//                            return;
//                        }
//                        else
//                        {
//                            NSLog(@"order count:%d", self.orderList.list.count);
//                            //self.arrayData = [NSMutableArray arrayWithArray:self.orderList.list];   // 订单数据源
//                            [self.arrayData addObjectsFromArray:self.orderList.list];
//                            [self.tableview reloadData];
//                        }
//                    }
//                    else
//                    {
//                        NSLog(@"%@", message);
//                        [self toast:@"获取待评价订单失败"];
//                    }
//                }];
//                break;
//            }
            default:
                break;
        }
    }
    
    /*
    if (_reviewList.count >= _curTotal)
    {
        if (_reviewList.count == 0)
        {
            //
        }
        else
        {
            [self toast:kLoadOver];
        }
        _tableView.pullTableIsLoadingMore = NO;
        return;
    }
    [InterfaceManager getUserReviewListPageNo:_curPageNo + 1
                                    pageCount:0
                                   completion:^(BOOL isSucceed, NSString *message, id data)
     {
         if (isSucceed)
         {
             ReviewListModel *aReviewList = (ReviewListModel *)data;
             [self setUserAddr:aReviewList.userAddress];
             [_reviewList addObjectsFromArray:aReviewList.reviews];
             _curPageNo++;
             [_tableView reloadData];
             if (_reviewList.count > 0)
             {
                 [_viewNoData setHidden:YES];
             }
             else
             {
                 [_viewNoData setHidden:NO];
             }
         }
         else
         {
             //            [_viewNoData setHidden:YES];
             if (_reviewList.count > 0)
             {
                 [_viewNoData setHidden:YES];
             }
             else
             {
                 [_viewNoData setHidden:NO];
             }
             [self toast:message];
         }
         _tableView.pullTableIsLoadingMore = NO;
     }];
     */
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
