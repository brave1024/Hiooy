//
//  SettingViewController.m
//  hiooy
//
//  Created by 黄磊 on 14-3-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "SettingBtnCell.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "CountryModel.h"
#import "OrderInfoModel.h"
#import "DocHelper.h"
#import "JSONKit.h"

#define SectionHeaderHeight 44
#define DefaultCellHeight 48.0
#define ReviewContentWidth 226

@interface SettingViewController ()

@property (nonatomic, strong) NSArray *arrItems;
@property (nonatomic, strong) NSDictionary *dicNumStr;
@property (nonatomic, strong) NSDictionary *dicNumPath;
@property (nonatomic, strong) NSMutableDictionary *dicNumDisplay;

@end

@implementation SettingViewController

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
    
    self.navigationItem.title = @"设置";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    UIImage *img = [UIImage imageNamed:@"btn_red"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];

    [self.btnLogout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnLogout setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.btnLogout setBackgroundImage:img forState:UIControlStateNormal];
    
    [self dataConfig];
    
    // TEST
    //[self requestAllArea];
    //[self requestAllOrder];
    //[self requestMessageCode];
}

// 请求所有地区信息
- (void)requestAllArea
{
    // 先检查本地doc下是否有已经保存的地区数据
    NSString *localPath = [DocHelper getFilePathInDocDir:kAreaData];
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    if ([fileHandler fileExistsAtPath:localPath] == YES)
    {
        // 直接读取本地doc下保存的地区数据
        //NSArray *arrArea = [[NSArray alloc] initWithContentsOfFile:localPath];
        NSStringEncoding encoding = NSUTF8StringEncoding;
        NSString *strArea = [[NSString alloc] initWithContentsOfFile:localPath usedEncoding:&encoding error:nil];
        NSLog(@"doc中已有保存的地区数据,直接读取");
        //NSLog(@"%@", strArea);
        NSData *respondData = [strArea dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *respondDic = (NSDictionary *)[respondData objectFromJSONData];
        NSLog(@"%@", respondDic);
        return;
    }
    
    [InterfaceManager getAllArea:^(BOOL isSucceed, NSString *message, id data) {
        if (isSucceed)
        {
            NSLog(@"获取地区信息成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            //NSLog(@"area dic:%@", dataDic);
            CountryModel *country = [[CountryModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            else
            {
                //NSArray *arrArea = country.provinces;
                ProvinceModel *province = [country.provinces objectAtIndex:7];
                NSLog(@"province name:%@, city count:%d", province.name, province.cities.count);
                // 写文件到doc目录下
                NSString *localPath = [DocHelper getFilePathInDocDir:kAreaData];
                NSFileManager *fileHandler = [NSFileManager defaultManager];
                if ([fileHandler fileExistsAtPath:localPath] == NO)
                {
                    //BOOL isOK = [arrArea writeToFile:localPath atomically:YES];
                    NSString *strArea = [dataDic JSONString];
                    NSLog(@"\n~~~~~~~~~~~~~~~~~~~~~\n%@\n~~~~~~~~~~~~~~~~\n", strArea);
                    BOOL isOK = [strArea writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    if (isOK == NO)
                    {
                        NSLog(@"保存地区数据到本地doc失败");
                        [fileHandler removeItemAtPath:localPath error:nil];
                    }
                    else
                    {
                        NSLog(@"保存地区数据到本地doc成功~!@");
                    }
                }
            }
        }
        else
        {
            NSLog(@"%@", message);
            [self toast:@"获取地区信息失败"];
        }
    }];
}

// 请求全部订单
- (void)requestAllOrder
{
    [InterfaceManager getAllOrder:@"1" completion:^(BOOL isSucceed, NSString *message, id data) {
        if (isSucceed)
        {
            NSLog(@"获取全部订单成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            OrderInfoModel *orderList = [[OrderInfoModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            else
            {
                NSLog(@"order count:%d", orderList.list.count);
                
                /*
                // 第一页...
                pager =     {
                    "cur_page" = "http://linux.hiooy.com/ecstore/index.php/wap/member-orders-1.html";
                    current = 1;
                    "next_page" = "http://linux.hiooy.com/ecstore/index.php/wap/member-orders-2.html";
                    total = 17;
                }
                
                // 最后一页...
                pager =     {
                    "cur_page" = "http://linux.hiooy.com/ecstore/index.php/wap/member-orders-17.html";
                    current = 17;
                    total = 17;
                }
                */
            }
        }
        else
        {
            NSLog(@"%@", message);
            [self toast:@"获取全部订单失败"];
        }
    }];
}

// 测试短信验证码接口
- (void)requestMessageCode
{
    [[UserManager shareInstant] userGetVerifyCode:@"18507103285" withType:@"0" completion:^(BOOL isSucceed, NSString *message) {
        if (isSucceed)
        {
            NSLog(@"success:%@", message);
        }
        else
        {
            NSLog(@"failed:%@", message);
        }
    }];
}

#pragma mark -Subjoin

- (void)dataConfig
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"setting.plist"];
    _arrItems = [[NSArray alloc] initWithContentsOfFile:filePath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (void)addAddr
{
    
}

// 退出登录
- (IBAction)logoutAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要退出登录吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    actionSheet.tag = 99;
    [actionSheet showInView:self.view];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //return SectionHeaderHeight;
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    NSDictionary *aDic = [_arrItems objectAtIndex:section];
//    NSString *sectionTitle = [aDic objectForKey:@"groupTitle"];
//    float aHeight = SectionHeaderHeight;
//    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    //    viewHeader.backgroundColor = [UIColor colorFromHexRGB:@"d1d1d1"];   // add by xzy
//    if (sectionTitle && aHeight)
//    {
//        // Create label with section title
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(17, 0, 320, aHeight);
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor blackColor];
//        // label.shadowColor = [UIColor clearColor];
//        // label.shadowOffset = CGSizeMake(0.0, 1.0);
//        label.font = [UIFont systemFontOfSize:16];
//        label.text = sectionTitle;
//        // Create header view and add label as a subview
//        [viewHeader setFrame:CGRectMake(0, 0, 320, aHeight)];
//        [viewHeader addSubview:label];
//    }
//    return viewHeader;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[[_arrItems objectAtIndex:indexPath.section] objectForKey:@"itemList"] objectAtIndex:indexPath.row];
    CGFloat aHeight = [[dic objectForKey:@"cellHeight"] floatValue];
    return aHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_arrItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[_arrItems objectAtIndex:section] objectForKey:@"itemList"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self dicForIndexPath:indexPath];   //  当前cell对应的内容dic
    NSString *identifier = [dic objectForKey:@"cellIdentifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        NSString *cellClass = [dic objectForKey:@"cellClass"];
        cell = [[NSClassFromString(cellClass) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // Configure the cell...
    NSMutableDictionary *dicForCell = [[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"cellInfo"]];  // 内容
    
    if ([cell respondsToSelector:@selector(setDelegate:)])
    {
        [cell setDelegate:self];
    }
    
    [cell configWithData:dicForCell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == _arrItems.count - 1)
//    {
//        return 70;
//    }
//    else
//    {
//        return 1;
//    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
//    if (section == _arrItems.count - 1)
//    {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
//        //view.backgroundColor = [UIColor lightGrayColor];
//        
//        UIImage *img = [UIImage imageNamed:@"btn_red"];
//        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
//        
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 20, 220, 40)];
//        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        //[btn setBackgroundColor:[UIColor redColor]];
//        [btn setBackgroundImage:img forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(logoutAcion) forControlEvents:UIControlEventTouchUpInside];
//        
//        [view addSubview:btn];
//        return view;
//    }
//    else
//    {
//        return nil;
//    }
}


- (NSDictionary *)dicForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[[_arrItems objectAtIndex:indexPath.section] objectForKey:@"itemList"] objectAtIndex:indexPath.row];
    return dic;
}

- (NSDictionary *)cellForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[[[_arrItems objectAtIndex:indexPath.section] objectForKey:@"itemList"] objectAtIndex:indexPath.row] objectForKey:@"cellInfo"];
    return dic;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *aDic = [[[_arrItems objectAtIndex:indexPath.section] objectForKey:@"itemList"] objectAtIndex:indexPath.row];
    NSString *pushClass = [aDic objectForKey:@"pushClass"];
    //    NSString *keyForCell = [aDic objectForKey:@"keyForCell"];
    if (pushClass && pushClass.length > 0)
    {
        UIViewController *pushVC = [[NSClassFromString(pushClass) alloc] initWithNibName:pushClass bundle:nil];
        
        id data = [aDic objectForKey:@"pushData"];
        if (data)
        {
            [pushVC configWithData:data];
        }
        LogTrace(@" Click at index:{%d, %d}, push VC: %@ ", indexPath.section, indexPath.row, pushVC);
        // Push the view controller.
        UINavigationController *theNavVC = self.tabBarController.navigationController;
        theNavVC = self.navigationController;
        [theNavVC pushViewController:pushVC animated:YES];
    } else if ([[aDic objectForKey:@"cellIdentifier"] isEqualToString:@"SettingBtn"]) {
        [self clickCellWithKey:[aDic objectForKey:@"keyForCell"]];
    }
}


#pragma mark - SettingBtnDelegate

- (void)clickCellWithKey:(NSString *)keyForCell
{
    if ([keyForCell isEqualToString:@"clearCache"]) {
        [self alertMsg:@"清除缓存成功"];
    } else if ([keyForCell isEqualToString:@"noticeReceiveTime"]) {
        
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 99)
    {
        if (buttonIndex == 0)
        {
            [self startLoading:@"加载中..."];
            
            [[UserManager shareInstant] userLogout:nil withPassword:nil completion:^(BOOL isSucceed, NSString *message) {
                [self stopLoading];
                if (isSucceed)
                {
                    [self toast:@"已退出登录"];
                    // 注销成功后,需弹出登录框;若点击取消,则直接跳转到首页...<暂时直接跳转到首页>
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    appDelegate.willSelectedIndex = 0;
                    appDelegate.tabVC.selectedIndex = 0;
                }
                else
                {
                    [self toast:message];
                }
            }];
        }
    }
}


@end
