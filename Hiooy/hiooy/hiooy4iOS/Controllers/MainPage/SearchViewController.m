//
//  SearchViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-31.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "SearchViewController.h"
#import "ProductDetailViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

#define kCellHeight 44

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
    
    self.navigationItem.title = @"搜索";
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //[self.navController showBackButtonWith:self andAction:@selector(backAction)];

    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)235/255 blue:(CGFloat)232/255 alpha:1];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"请输入商品关键字";
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if ([_searchBar respondsToSelector:@selector(barTintColor)])
//    {
//        float iosversion7_1 = 7.1 ;
//        if (version >= iosversion7_1)
//        {
//            // iOS7.1
//            [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
//            [_searchBar setBackgroundColor:[UIColor clearColor]];
//        }
//        else
//        {
//            // iOS7.0
//            [_searchBar setBarTintColor:[UIColor clearColor]];
//            [_searchBar setBackgroundColor:[UIColor clearColor]];
//        }
//    }
//    else
//    {
//        //iOS7.0 以下
//        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
//        [_searchBar setBackgroundColor:[UIColor clearColor]];
//    }
    
    UIImage *img = [UIImage imageNamed:@"search_bg"];
    //img = [img stretchableImageWithLeftCapWidth:6 topCapHeight:3];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(3, 6, 3, 6)];
    _searchBar.backgroundImage = img;
    
    self.navigationItem.titleView = _searchBar;
    
    // 导航左边取消按钮
    UIButton *cancelBack = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBack.frame = CGRectMake(0, 6, 42, 32);
    //[cancelBack setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBack.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [cancelBack setImage:[UIImage imageNamed:@"back_ico_normal"] forState:UIControlStateNormal];
    [cancelBack setImage:[UIImage imageNamed:@"back_ico_press"] forState:UIControlStateHighlighted];
    [cancelBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    cancelBack = UIEdgeInsetsMake(-1, -30, 0, 0);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBack];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self.searchBar becomeFirstResponder];
    
    self.viewNoData.hidden = YES;
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //[self.searchBar resignFirstResponder];
    //
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchBar.text == nil || [self.searchBar.text isEqualToString:@""] == YES)
    {
        //
    }
}

// 开始搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //
    [self.searchBar resignFirstResponder];
    
    if ([TextVerifyHelper checkContent:self.searchBar.text] == NO)
    {
        [self toast:@"搜索关键字不能为空"];
        return;
    }
    
    [self startLoading:kLoading];
    
    [InterfaceManager searchProductWithKeyword:self.searchBar.text completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSLog(@"关键字搜索成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            self.productList = [[ProductListModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            
            if (self.productList.products == nil || self.productList.products.count == 0)
            {
                self.arrayData = nil;
                self.viewNoData.hidden = NO;
            }
            else
            {
                self.arrayData = [[NSMutableArray alloc] initWithArray:self.productList.products];
                self.viewNoData.hidden = YES;
                
            }
            [self.tableview reloadData];
        }
        else
        {
            NSLog(@"搜索失败");
            [self toast:message];
        }
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //_searchBar.text = @"";
}


//#pragma mark - Table view data source
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return kCellHeight;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return 10;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    NSString *identifier = @"cellIdentifier";
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    // Configure the cell...
//    // 添加右边条数更新
//    
//    cell.imageView.image = [UIImage imageNamed:@"btn_default_selected"];
//    cell.textLabel.text = @"搜索结果";
//    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    
//    return cell;
//}
//
//
//#pragma mark - Table view delegate
//
//// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here, for example:
//    // Create the next view controller.
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


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
    detailVC.fromCart = NO;     // 不是从购物车界面跳转
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}



@end


