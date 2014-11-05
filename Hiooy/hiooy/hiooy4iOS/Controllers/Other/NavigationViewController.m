//
//  NavigationViewController.m
//  KKMYForU
//
//  Created by 黄磊 on 13-11-22.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//

#import "NavigationViewController.h"


@implementation UIViewController (SlideViewController)


- (NavigationViewController *)navController
{
    UIViewController *viewController = self.parentViewController;
    while (!(viewController == nil || [viewController isKindOfClass:[NavigationViewController class]]))
    {
        viewController = viewController.parentViewController;
    }
    
    return (NavigationViewController *)viewController;
}


@end

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view setBackgroundColor:[UIColor clearColor]];
    
    // 导航栏背景色使用默认效果
    if (__CUR_IOS_VERSION >= __IPHONE_7_0) {
        // This code will only compile on versions >= iOS 7.0
        self.edgesForExtendedLayout= UIRectEdgeTop;
        //self.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"62bf3d"];
    } else if (__CUR_IOS_VERSION >= __IPHONE_6_0) {
        //self.navigationBar.tintColor = [UIColor colorFromHexRGB:@"62bf3d"];
    }
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    // 设置返回键
//    BackNavItem *backNav = [[BackNavItem alloc] initWithTitle:@"返回" type:UIBackNavWhite target:self action:@selector(back)];
    
    // 导航栏中间标题的设置
    NSDictionary *textAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor darkGrayColor], TextAttributeTextColor,
//                              [UIFont fontWithName:@"JXiHei" size:17], TextAttributeFont,
                              [UIFont boldSystemFontOfSize:17], TextAttributeFont,
                              [UIColor clearColor], UITextAttributeTextShadowColor,nil];
    self.navigationBar.titleTextAttributes = textAttr;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

// 固定的返回键
- (void)showBackButtonWith:(UIViewController *)viewController
{
    UIBarButtonItem *leftItem = [self createButtonWith:self action:@selector(back)];
    [viewController.navigationItem setLeftBarButtonItem:leftItem animated:YES];
}

// 可自定义功能键
- (void)showBackButtonWith:(UIViewController *)viewController andAction:(SEL)action
{
    UIBarButtonItem *leftItem = [self createButtonWith:viewController action:action];
    [viewController.navigationItem setLeftBarButtonItem:leftItem animated:YES];
}

- (UIBarButtonItem *)createButtonWith:(id)target action:(SEL)action
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 6, 48, 32);
    //[btnBack setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    //[btnBack setImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [btnBack setImage:[UIImage imageNamed:@"back_ico_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_ico_press"] forState:UIControlStateHighlighted];
    [btnBack addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btnBack.imageEdgeInsets = UIEdgeInsetsMake(-1, -30, 0, 0);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    return leftItem;
}

- (void)back
{
    if (self.viewControllers.count > 1) {
        [self popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//- (BOOL)haveThisClass:(Class)className equalToId:(int)pushId
//{
//    return [self.topViewController haveThisClass:className equalToId:pushId];
//}

@end
