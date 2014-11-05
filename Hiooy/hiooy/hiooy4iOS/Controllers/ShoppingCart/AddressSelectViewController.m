//
//  AddressSelectViewController.m
//  hiooy
//
//  Created by retain on 14-4-25.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "AddressSelectViewController.h"
#import "AddressCell.h"

@interface AddressSelectViewController ()

@end

@implementation AddressSelectViewController

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
    
    self.navigationItem.title = @"选择收货地址";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.showsVerticalScrollIndicator = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
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
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [AddressCell cellFromNib];
    }
    
    // Configure the cell...
    int row = indexPath.row;
    CartResponseAddressModel *addr = [self.arrayData objectAtIndex:row];
    [cell settingCell:addr];
    
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
    
    int row = indexPath.row;
    CartResponseAddressModel *addr = [self.arrayData objectAtIndex:row];
    if ([addr.choosed isEqualToString:@"true"] == YES)
    {
        //
    }
    else
    {
        for (int i = 0; i < self.arrayData.count; i++)
        {
            CartResponseAddressModel *address = [self.arrayData objectAtIndex:i];
            address.choosed = @"false";
        }
        addr.choosed = @"true";
        [self.tableview reloadData];
    }
    NSLog(@"address:%@", addr.address);
    self.cartSubmitVC.cartSubmitRes.addrlist = (NSArray<CartResponseAddressModel, Optional> *)self.arrayData;
    self.cartSubmitVC.cartSubmitRes.def_arr_addr = addr;
    //[self.cartSubmitVC settingDefaultAddress];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
