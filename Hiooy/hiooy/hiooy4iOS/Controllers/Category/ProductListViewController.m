//
//  ProductListViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductModel.h"
#import "ProductDetailViewController.h"

@interface ProductListViewController ()

@end

@implementation ProductListViewController

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
    
    //self.navigationItem.title = self.categoryItem.cat_name;
    self.navigationItem.title = self.titleStr;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    if (self.listType == 0) // 从商品分类中跳转过来
    {
        [self requestProductList];
    }
    else                    // 从首页精品频道跳转过来
    {
        [self requestGoodProductList];
    }
    
    self.segment.selectedSegmentIndex = 0;
    self.segment.selected = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 请求商品分类中的商品列表
- (void)requestProductList
{
    [self startLoading:kLoading];
    
    [InterfaceManager getProductList:self.categoryItem.cat_id withPage:nil completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed) {
            NSLog(@"获取商品列表成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
            NSError *error = nil;
            self.productList = [[ProductListModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            NSLog(@"order style number:%d", self.productList.orderby.count);
            [self.tableview reloadData];
        }else {
            NSLog(@"获取商品列表失败:%@", message);
        }
    }];
}

// 请求精品频道接品的商品列表
- (void)requestGoodProductList
{
    [self startLoading:kLoading];
    
    [InterfaceManager getGoodProductList:self.listType completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed) {
            NSLog(@"获取精品列表成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            NSLog(@"dataDic:%@", dataDic);
            self.productList = [[ProductListModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            NSLog(@"product count:%d", self.productList.products.count);
            [self.tableview reloadData];
        }else {
            NSLog(@"获取精品列表失败:%@", message);
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
    return self.productList.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"categoryInfo";
    ProductListCell *cell = (ProductListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [ProductListCell cellFromNib];
    }
    
    // Configure the cell...
    ProductModel *item = [self.productList.products objectAtIndex:indexPath.row];
    cell.lblTitle.text = item.name;
    cell.lblPriceMarket.text = [NSString stringWithFormat:@"¥ %.2f", [item.mktprice floatValue]];
    cell.lblPrice.text = [NSString stringWithFormat:@"¥ %.2f", [item.price floatValue]];
    [cell.imgview setImageWithURL:[NSURL URLWithString:item.image_url] placeholderImage:nil];
    
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
    ProductModel *item = [self.productList.products objectAtIndex:indexPath.row];
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    detailVC.productModel = item;
    detailVC.fromCart = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
