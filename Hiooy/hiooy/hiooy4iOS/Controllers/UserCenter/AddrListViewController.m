//
//  AddrListViewController.m
//  hiooy
//
//  Created by 黄磊 on 14-3-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "AddrListViewController.h"
#import "EditAddrViewController.h"
#import "AddrInfoModel.h"

#define DefaultCellHeight 125
//#define ReviewContentWidth 226

@interface AddrListViewController ()

@property (nonatomic, strong) NSMutableArray *arrItems;
@property (nonatomic, assign) NSInteger curDefaultIndex;

@end

@implementation AddrListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _arrItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"收货地址";
    [self.navController showBackButtonWith:self];
    
    // 导航右边添加按钮
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(0, 6, 42, 32);
    [btnAdd setImage:[UIImage imageNamed:@"address_add"] forState:UIControlStateNormal];
//    [btnBack setImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [btnAdd addTarget:self action:@selector(addAddr) forControlEvents:UIControlEventTouchUpInside];
//    settingBack.imageEdgeInsets = UIEdgeInsetsMake(-1, -30, 0, 0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnAdd];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [self dataConfig];
    
    // 添加、编辑地址成功后需刷新地址列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAddressList) name:kRefreshAddressList object:nil];
    
    // 获取地址列表
    [self requestAddressList];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 不再使用
- (void)dataConfig
{
    _arrItems = [[NSMutableArray alloc] init];
    NSMutableArray *saveArr = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserAddrList] mutableCopy];
    for (int i = 0, len = saveArr.count; i < len; i++) {
        NSDictionary *aDic = [saveArr objectAtIndex:i];
        AddrInfoModel *aAddr = [[AddrInfoModel alloc] initWithDictionary:aDic error:nil];;
        [_arrItems addObject:aAddr];
    }
    
    _curDefaultIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultAddr] integerValue];
    if (_arrItems.count > 0) {
        [_tableView reloadData];
    } else {
        // TODO:需要注掉
        AddrInfoModel *addrInfo = [[AddrInfoModel alloc] init];
        addrInfo.name = @"张三";
        addrInfo.tel = @"13812345678";
        addrInfo.zipcode = @"430000";
        addrInfo.region = @"湖北省武汉市洪山区";
        addrInfo.addr = @"湖北省武汉市洪山区关山大道光谷软件园C6栋302室";
        addrInfo.isDefault = [NSNumber numberWithBool:YES];
        addrInfo.addrId = [NSNumber numberWithInt:1];
        [_arrItems addObject:[addrInfo copeAddr]];
        addrInfo.isDefault = [NSNumber numberWithBool:NO];
        addrInfo.addrId = [NSNumber numberWithInt:2];
        [_arrItems addObject:[addrInfo copeAddr]];
        addrInfo.addrId = [NSNumber numberWithInt:3];
        [_arrItems addObject:[addrInfo copeAddr]];
        addrInfo.addrId = [NSNumber numberWithInt:4];
        [_arrItems addObject:[addrInfo copeAddr]];
        addrInfo.addrId = [NSNumber numberWithInt:4];
        [_arrItems addObject:[addrInfo copeAddr]];
        _curDefaultIndex = 0;
        [_tableView reloadData];
    }
}

// 请求收货地址列表
- (void)requestAddressList
{
    [self startLoading:kLoading];
    
    [InterfaceManager getAddressList:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSLog(@"获取收货地址成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            //NSLog(@"area dic:%@", dataDic);
             self.addressList = [[AddressListModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            else
            {
                NSLog(@"收货地址数据解析成功...");
                self.arrItems = [NSMutableArray arrayWithArray:self.addressList.receivers];
                [self.tableView reloadData];
            }
        }
        else
        {
            NSLog(@"%@", message);
            [self toast:@"获取收货地址失败"];
        }
    }];
}


#pragma mark - Action

// 增加收货地址
- (void)addAddr
{
    if (self.arrItems.count >= 10)
    {
        [self toast:@"已添加10个收货地址"];
        return;
    }
    
    EditAddrViewController *addAddrVC = [[EditAddrViewController alloc] initWithNibName:@"EditAddrViewController" bundle:nil];
    addAddrVC.curAddrInfo = nil;    // 添加
    [self.navigationController pushViewController:addAddrVC animated:YES];
}


#pragma mark - Private

//- (void)saveData
//{
//    NSMutableArray *saveArr = [[NSMutableArray alloc] init];
//    for (int i = 0, len = _arrItems.count; i < len; i++) {
//        AddrInfoModel *aAddr = [_arrItems objectAtIndex:i];
//        NSDictionary *aDic = [aAddr toDictionary];
//        [saveArr addObject:aDic];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:saveArr forKey:kUserAddrList];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_curDefaultIndex] forKey:kDefaultAddr];
//}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DefaultCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_arrItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *identifier = @"AddrInfo";
    AddrInfoCell *cell = (AddrInfoCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[AddrInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setDelegate:self];
    }
    
    // Configure the cell...
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    [cell configWithData:(AddressModel *)[_arrItems objectAtIndex:indexPath.row]];
    [cell setCellIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
    
}


#pragma mark - AddrInfoCellDelegate

// 设为默认收货地址
- (void)setDefaultCellAtIndex:(NSUInteger)index
{
    [self startLoading:kLoading];
    
    AddressModel *curAddr = [_arrItems objectAtIndex:index];
    [InterfaceManager settingDefaultAddress:curAddr completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSLog(@"设置默认收货地址成功");
            // 刷新列表
            for (AddressModel *addr in _arrItems)
            {
                addr.is_default = @"0";
            }
            curAddr.is_default = @"1";
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"%@", message);
            [self toast:@"设置默认收货地址失败"];
        }
    }];
    
//    AddrInfoModel *preDefault = [_arrItems objectAtIndex:_curDefaultIndex];
//    preDefault.isDefault = [NSNumber numberWithBool:NO];
//    AddrInfoModel *curDefault = [_arrItems objectAtIndex:index];
//    curDefault.isDefault = [NSNumber numberWithBool:YES];
//    _curDefaultIndex = index;
//    [self saveData];
//    [_tableView reloadData];
}

// 编辑收货地址
- (void)editCellAtIndex:(NSUInteger)index
{
    EditAddrViewController *editVC = [[EditAddrViewController alloc] initWithNibName:@"EditAddrViewController" bundle:nil];
    [editVC setCurAddrInfo:(AddressModel *)[_arrItems objectAtIndex:index]];    // 编辑
    [editVC setEditIndex:index];
    [self.navigationController pushViewController:editVC animated:YES];
}

// 删除收货地址
- (void)deleteCellAtIndex:(NSUInteger)index
{
    //AddressModel *curAddr = [_arrItems objectAtIndex:index];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否要删除当前收货地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = index;
    [alert show];
    
    /*
    // 判断是否为默认收货地址
    if (curAddr.is_default && [curAddr.is_default boolValue])
    {
        //
    }
    
    NSInteger newDefaultIndex = _curDefaultIndex;
    
    if (_curDefaultIndex < index)
    {
        
    }
    else if (_curDefaultIndex == index)
    {
        // 删除的是默认地址
        newDefaultIndex = 0;
        if (index == 0 && _arrItems.count > 1) {
            newDefaultIndex = 1;
        }
        AddressModel *newDefault = [_arrItems objectAtIndex:newDefaultIndex];
        newDefault.is_default = @"1";
        newDefaultIndex = 0;
    }
    else
    {
        newDefaultIndex--;
    }
    
    [_arrItems removeObjectAtIndex:index];
    _curDefaultIndex = newDefaultIndex;
    
    [_tableView reloadData];
    */
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int tag = alertView.tag;
    if (buttonIndex == 0)
    {
        //
    }
    else
    {
        [self startLoading:kLoading];
        AddressModel *curAddr = [_arrItems objectAtIndex:tag];
        [InterfaceManager deleteAddress:curAddr completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            if (isSucceed)
            {
                NSLog(@"删除收货地址成功");
                [self toast:@"删除收货地址成功"];
                [self.arrItems removeObjectAtIndex:tag];
                [self.tableView reloadData];
            }
            else
            {
                NSLog(@"%@", message);
                [self toast:@"删除收货地址失败"];
            }
        }];
    }
}


@end
