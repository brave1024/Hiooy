//
//  CategorySubViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-10.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "CategorySubViewController.h"
#import "ProductListViewController.h"

@interface CategorySubViewController ()

@end

@implementation CategorySubViewController

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
    
    self.navigationItem.title = self.categoryItem.cat_name;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    [self requestSubCategory];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestSubCategory
{
    [self startLoading:kLoading];
    
    [InterfaceManager getProductCategory:self.categoryItem.cat_id withPage:nil completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed) {
            NSLog(@"获取商品子分类成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
            NSError *error = nil;
            self.subCategory = [[ProductSubCatListModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            NSLog(@"subCategory:%d", self.subCategory.cat_info.sub.count);
            [self.tableview reloadData];
        }else {
            NSLog(@"获取商品子分类失败:%@", message);
        }
    }];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.subCategory.cat_info.sub.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"categoryInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // Configure the cell...
    ProductCatItemModel *item = [self.subCategory.cat_info.sub objectAtIndex:indexPath.row];
    cell.textLabel.text = item.cat_name;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor blackColor];
    [cell.imageView setImageWithURL:[NSURL URLWithString:item.image_url] placeholderImage:nil];
    
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
    
    ProductListViewController *listVC = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
    listVC.categoryItem = [self.subCategory.cat_info.sub objectAtIndex:indexPath.row];
    listVC.listType = 0;
    listVC.titleStr = listVC.categoryItem.cat_name;
    //[self.tabBarController.navigationController pushViewController:listVC animated:YES];
    [self.navigationController pushViewController:listVC animated:YES];
}




@end
