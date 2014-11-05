//
//  MyHiooyViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MyHiooyViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MyCollectViewController.h"
#import "TabBarViewController.h"
#import "AppDelegate.h"
#import "UserInfoView.h"

#define SectionHeaderHeight 10
#define DefaultCellHeight 48.0
#define ReviewContentWidth 226

@interface MyHiooyViewController ()

@property (nonatomic, strong) NSArray *arrItems;
@property (nonatomic, strong) NSDictionary *dicNumStr;
@property (nonatomic, strong) NSDictionary *dicNumPath;
@property (nonatomic, strong) NSMutableDictionary *dicNumDisplay;

@end


@implementation MyHiooyViewController

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
	// Do any additional setup after loading the view.
    
    if (__CUR_IOS_VERSION >= __IPHONE_7_0) {
        // This code will only compile on versions >= iOS 7.0
        self.edgesForExtendedLayout= UIRectEdgeNone;
        self.tabBarController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationItem.title = @"我的海印";
    [self.navigationController setNavigationBarHidden:NO];
    
    // 导航右边设置按钮
    UIButton *settingBack = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBack.frame = CGRectMake(0, 6, 42, 32);
    [settingBack setImage:[UIImage imageNamed:@"btn_setting_normal"] forState:UIControlStateNormal];
//    [btnBack setImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [settingBack addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
//    settingBack.imageEdgeInsets = UIEdgeInsetsMake(-1, -30, 0, 0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:settingBack];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    // 头像
//    _viewAvatar.layer.cornerRadius = _viewAvatar.bounds.size.width / 2;
//    _viewAvatar.layer.masksToBounds = YES;
//    _imgviewAvatar.layer.cornerRadius = _imgviewAvatar.bounds.size.width / 2;
//    _imgviewAvatar.layer.masksToBounds = YES;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    // 界面数据设置
    [self dataConfig];
    if (_arrItems.count > 0)
    {
        [_tableView reloadData];
    }
    
    BOOL isLogin = [UserManager shareInstant].isLogin;
    if (isLogin == YES)
    {
        [self requestUserCenter];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserCenter) name:kRefreshUserCenter object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    BOOL isLogin = [UserManager shareInstant].isLogin;
//    if (isLogin == YES)
//    {
//        [self requestUserCenter];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestUserCenter
{
    //[self startLoading:kLoading];
    
    UserManager *user = [UserManager shareInstant];
    [user userCenter:nil completion:^(BOOL isSucceed, NSString *message) {
        //[self stopLoading];
        if (isSucceed) {
            NSLog(@"获取会员中心信息成功");
            self.userModel = [[UserManager shareInstant] getUserCenterInfo];
//            self.lblTel.text = _userModel.login_name;
//            self.lblUserLevel.text = _userModel.levelname;
//            self.lblMoney.text = [NSString stringWithFormat:@"¥ %.2f", [_userModel.advance.total floatValue]];
            // 刷新订单数据
            [self.tableView reloadData];
        }else {
            NSLog(@"获取会员中心信息失败:%@", message);
            [self toast:message];
        }
    }];
}


#pragma mark -Subjoin

- (void)dataConfig
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"userCenter.plist"];
    _arrItems = [[NSArray alloc] initWithContentsOfFile:filePath];
}


#pragma mark - Action

- (void)showUserLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginVC.completionBlock = ^(BOOL isSucceed, NSString *message) {
        if (isSucceed) {
            [self.tabBarController setSelectedIndex:self.view.tag];
            self.navigationItem.title = @"我的海印";
        }
    };
    NavigationViewController *navVC = [[NavigationViewController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navVC animated:YES completion:^{
        
    }];
}

- (void)showSettingView
{
//    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appdelegate.tabVC.selectedIndex = 0;
//    return;
    SettingViewController *settingVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.tabBarController.navigationController pushViewController:settingVC animated:YES];
    //[self.navigationController pushViewController:settingVC animated:YES];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //return SectionHeaderHeight;
    
    if (section == 0)
    {
        return 86 + SectionHeaderHeight;
    }
    else
    {
        return SectionHeaderHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //return nil;
    
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 86 + SectionHeaderHeight)];
        view.backgroundColor = [UIColor clearColor];
        
        UserInfoView *userView = [UserInfoView viewFromNib];
        userView.frame = CGRectMake(0, 0, 320, 86);
        [userView settingView:self.userModel];
        [view addSubview:userView];
        
        return view;
    }
    else
    {
        return nil;
    }
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
    
    // 添加右边条数更新
    NSMutableDictionary *dicForCell = [[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"cellInfo"]];  // 内容
    
    // 只针对第一个section
    if (indexPath.section == 0)
    {
        // 判断是否要显示右边的订单个数视图
        UserInfoModel *userModel = [[UserManager shareInstant] getUserCenterInfo];
        // Test
//        userModel.un_pay_orders = @"3";
//        userModel.un_ship_orders = @"14";
//        userModel.un_sign_orders = @"168";
//        userModel.nodiscuss_orders = @"8";
        NSString *strNumber = nil;
        
        switch (indexPath.row) {
            case 0:
                strNumber = userModel.un_pay_orders;
                break;
            case 1:
                strNumber = userModel.un_ship_orders;
                break;
            case 2:
                strNumber = userModel.un_sign_orders;
                break;
            case 3:
                strNumber = userModel.nodiscuss_goods;
                break;
            case 4:
                strNumber = userModel.order_count;
                break;
            default:
                break;
        }
        if (strNumber == nil || [strNumber isEqualToString:@""] == YES)
        {
            //[dicForCell setObject:@"" forKey:@"subTitle"];
            [dicForCell removeObjectForKey:@"subTitle"];
        }
        else
        {
            if ([strNumber intValue] == 0)
            {
                [dicForCell removeObjectForKey:@"subTitle"];
            }
            else
            {
               [dicForCell setObject:strNumber forKey:@"subTitle"];
            }
        }
    }
    else if (indexPath.section == 1)
    {
        UserInfoModel *userModel = [[UserManager shareInstant] getUserCenterInfo];
        NSString *strNumber = userModel.favcount;
        if (strNumber == nil || [strNumber isEqualToString:@""] == YES)
        {
            [dicForCell removeObjectForKey:@"subTitle"];
        }
        else
        {
            if ([strNumber intValue] == 0)
            {
                [dicForCell removeObjectForKey:@"subTitle"];
            }
            else
            {
                [dicForCell setObject:strNumber forKey:@"subTitle"];
            }
        }
    }
    else
    {
        [dicForCell removeObjectForKey:@"subTitle"];
    }
    
//    // 判断是否是最新
//    NSString *keyForCell = [dic objectForKey:@"keyForCell"];
//    if (keyForCell != nil)
//    {
//        NSNumber *isNew = [_dicNumDisplay objectForKey:[NSString stringWithFormat:@"%@IsNew", keyForCell]];
//        if (isNew)
//        {
//            [dicForCell setObject:isNew forKey:@"isNew"];
//        }
//        
//    }
    
    [cell configWithData:dicForCell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _arrItems.count - 1)
    {
        return 10;
    }
    else
    {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
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
    
    /****************************************************/
    // add by xzy
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        MyCollectViewController *collectVC = [[MyCollectViewController alloc] initWithNibName:@"MyCollectViewController" bundle:nil];
        UINavigationController *theNavVC = self.tabBarController.navigationController;
        [theNavVC pushViewController:collectVC animated:YES];
        return;
    }
    /****************************************************/
    
    NSDictionary *aDic = [[[_arrItems objectAtIndex:indexPath.section] objectForKey:@"itemList"] objectAtIndex:indexPath.row];
    NSString *pushClass = [aDic objectForKey:@"pushClass"];
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
        [theNavVC pushViewController:pushVC animated:YES];
        //[self.navigationController pushViewController:pushVC animated:YES];
    }
}


@end
