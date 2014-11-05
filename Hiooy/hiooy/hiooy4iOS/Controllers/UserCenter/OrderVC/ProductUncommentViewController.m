//
//  ProductUncommentViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ProductUncommentViewController.h"
#import "OrderHeadView.h"
#import "ProductModel.h"
#import "ProductDetailViewController.h"
#import "CommentProductViewController.h"

@interface ProductUncommentViewController ()

@end

@implementation ProductUncommentViewController

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
    
    self.navigationItem.title = @"待评价商品";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.viewNoData.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestProductListToComment) name:kRefreshProductComment object:nil];
    
    // 请求订单
    [self requestProductListToComment];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configWithData:(id)data
{
//    if ([data isKindOfClass:[NSDictionary class]])
//    {
//        NSDictionary *dicForWeb = (NSDictionary *)data;
//        NSString *vcId = [dicForWeb objectForKey:@"vcId"];
//        int tag = [vcId intValue];
//    }
}

// 请求待评价商品列表
- (void)requestProductListToComment
{
    [self startLoading:kLoading];
    
    [InterfaceManager getOrderForUnComment:@"1" completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSLog(@"获取待评价商品成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            self.commentList = [[OrderCommentModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            else
            {
                NSLog(@"order count:%d", self.commentList.list.count);
                self.arrayData = [NSMutableArray arrayWithArray:self.commentList.list];   // 订单数据源
                [self.tableview reloadData];
                
                if (self.commentList.list == nil || self.commentList.list.count == 0)
                {
                    self.viewNoData.hidden = NO;
                }
                else
                {
                    self.viewNoData.hidden = YES;
                }
            }
        }
        else
        {
            NSLog(@"%@", message);
            [self toast:@"获取待评价商品失败"];
            self.commentList = nil;
            self.arrayData = nil;
            self.viewNoData.hidden = NO;
        }
    }];
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
    return 1;
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
    
    ProductCommentModel *item = [self.arrayData objectAtIndex:indexPath.section];
    [cell settingCell:item];
    
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
    ProductCommentModel *item = [self.arrayData objectAtIndex:section];
    
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
    ProductCommentModel *item = [self.arrayData objectAtIndex:section];
    
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
    ProductCommentModel *item = [self.arrayData objectAtIndex:indexPath.section];
    ProductModel *product = [[ProductModel alloc] init];
    product.goods_id = item.goods_id; // 只需要传goods_id就行
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
 
    ProductCommentModel *item = [self.arrayData objectAtIndex:tag];
    CommentProductViewController *commentVC = [[CommentProductViewController alloc] initWithNibName:@"CommentProductViewController" bundle:nil];
    commentVC.product = item;
    [self.navigationController pushViewController:commentVC animated:YES];
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
    
    int currentPage = [self.commentList.pager.current intValue];
    int totalpage = [self.commentList.pager.total intValue];
    
    if (currentPage == totalpage)
    {
        [self toast:kLoadOver];
        [self stopLoading];
        self.tableview.pullTableIsLoadingMore = NO;
    }
    else
    {
        [InterfaceManager getOrderForUnComment:[NSString stringWithFormat:@"%d", currentPage+1] completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            self.tableview.pullTableIsLoadingMore = NO;
            if (isSucceed)
            {
                NSLog(@"获取待评价商品成功");
                NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                NSError *error = nil;
                self.commentList = [[OrderCommentModel alloc] initWithDictionary:dataDic error:&error];
                if (error != nil)
                {
                    NSLog(@"json解析失败:%@", error);
                    return;
                }
                else
                {
                    NSLog(@"order count:%d", self.commentList.list.count);
                    //self.arrayData = [NSMutableArray arrayWithArray:self.orderList.list];   // 订单数据源
                    [self.arrayData addObjectsFromArray:self.commentList.list];
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

