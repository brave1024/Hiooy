//
//  MainViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "MainViewController.h"
#import "ScanQRViewController.h"
#import "ZXingObjC.h"
#import "SearchViewController.h"
#import "ProductListViewController.h"
#import "MyHiooyViewController.h"
#import "ViewController.h"

#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

#import "GrouponListViewController.h"
#import "SecondKillListViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

#define TAG_TYPE 100

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
    
//    UIImage *imgSelect = [UIImage imageNamed:@"ico_home_selected"];
//    UIImage *imgUnselect = [UIImage imageNamed:@"ico_home_unselected"];
//    [self.tabBarItem setSelectedImage:imgSelect];
//    [self.tabBarItem setFinishedSelectedImage:imgSelect withFinishedUnselectedImage:imgUnselect];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)225 green:(CGFloat)246 blue:(CGFloat)255 alpha:1];
    
    self.scrollContent.contentSize = CGSizeMake(320, 426);
    self.scrollContent.scrollEnabled = YES;
    
    UIImage *img = [UIImage imageNamed:@"search_box"];
    img = [img stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    self.searchBar.backgroundImage = img;

    //self.viewTop.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
    
    // iPhone4屏幕适配
    self.scrollContent.frame = CGRectMake(0, 140, 320, kScreenHeight - 140 - 49);
    
    self.tabBarController.tabBar.hidden = NO;
    
    kAppDelegate.currentSelectedIndex = 0;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //[self.searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setHidesBottomBarWhenPushed:NO];
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

// 二维码扫描
- (IBAction)scanQRAction:(id)sender
{
    ScanQRViewController *scanVC = [[ScanQRViewController alloc] initWithNibName:@"ScanQRViewController" bundle:nil];
    [self setHidesBottomBarWhenPushed:YES]; // 隐藏tabbar
    //[self.navigationController pushViewController:scanVC animated:YES];
    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:scanVC];
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}

// 团购
- (IBAction)groupBuyingAction:(id)sender
{
//    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    [self setHidesBottomBarWhenPushed:YES]; // 隐藏tabbar
//    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:^{
//        //
//    }];
    
    GrouponListViewController *grouponVC = [[GrouponListViewController alloc] initWithNibName:@"GrouponListViewController" bundle:nil];
    [self.tabBarController.navigationController pushViewController:grouponVC animated:YES];
}

// 秒杀
- (IBAction)secondKillAction:(id)sender
{
    SecondKillListViewController *killVC = [[SecondKillListViewController alloc] initWithNibName:@"SecondKillListViewController" bundle:nil];
    [self.tabBarController.navigationController pushViewController:killVC animated:YES];
}

// 精品频道
- (IBAction)productTypeSelected:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = (int)(btn.tag);
    NSString *titleStr = @"奢侈品";
    int listType = 1;
    switch (tag) {
        case TAG_TYPE:
            titleStr = @"奢侈品";
            listType = 1;
            break;
        case TAG_TYPE+1:
            titleStr = @"3C数码";
            listType = 2;
            break;
        case TAG_TYPE+2:
            titleStr = @"服饰运动";
            listType = 3;
            break;
        case TAG_TYPE+3:
            titleStr = @"餐饮娱乐";
            listType = 4;
            break;
        case TAG_TYPE+4:
            titleStr = @"会员俱乐部";
            listType = 5;
            break;
        case TAG_TYPE+5:
            titleStr = @"发烧友";
            listType = 6;
            break;
        default:
            break;
    }
    
    if (tag == TAG_TYPE+4)
    {        
        // 若未登录,则需要先弹出登录界面;成功登录后,再跳到个人中心
        // 若已登录,则直接进入个人中心
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.willSelectedIndex = 3;
        
        // 获取个人中心vc
        MyHiooyViewController *userVC = nil;
        NSArray *arrayVC = appDelegate.tabVC.viewControllers;
        for (UIViewController *vc in arrayVC)
        {
            if ([vc isKindOfClass:[UINavigationController class]] == YES)
            {
                UINavigationController *navVC = (UINavigationController *)vc;
                UIViewController *myVC = [navVC.viewControllers objectAtIndex:0];   // 指定nav栈中的第0个vc
                if ([myVC isKindOfClass:[MyHiooyViewController class]] == YES)
                {
                    userVC = (MyHiooyViewController *)myVC;
                }
            }
        }
        
        if ([[UserManager shareInstant] isLogin] == NO)
        {
            if (userVC != nil)
            {
                [userVC showUserLogin];
            }
        }
        else
        {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.willSelectedIndex = 3;
            appDelegate.tabVC.selectedIndex = 3;
        }
        return;
    }
    
    ProductListViewController *listVC = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
    listVC.listType = listType;
    listVC.titleStr = titleStr;
    [self.tabBarController.navigationController pushViewController:listVC animated:YES];
    
    /* 会员俱乐部
    {
        "status": "success",
        "msg": "",
        "data": {
            "login_name": "cookov",
            "levelname": "注册会员",
            "name": null,
            "un_pay_orders": 0,
            "un_ship_orders": 0,
            "un_sign_orders": 0,
            "nodiscuss_orders": "0"
        }
    }
    */
    
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchViewController *searchVC = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:searchVC];
    //[self.navigationController pushViewController:searchVC animated:YES];
    [self presentViewController:nav animated:NO completion:^{
        //
    }];
    return NO;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //
    
    
    [self.searchBar resignFirstResponder];
}


@end
