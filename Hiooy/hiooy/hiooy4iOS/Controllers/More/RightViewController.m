//
//  RightViewController.m
//  hiooy
//
//  Created by 黄磊 on 14-3-17.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "RightViewController.h"
#import "ScanQRViewController.h"
#import "ZXingObjC.h"
#import "InterfaceManager.h"
#import "ProductCatListModel.h"
#import "ProductCatItemModel.h"

@interface RightViewController ()

@end

@implementation RightViewController

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
    self.navigationItem.title = @"更多分类";
    [self.navController showBackButtonWith:self andAction:@selector(showCenterView:)];
    
    // 导航右边分享按钮
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(0, 6, 42, 32);
    [btnShare setTitle:@"分享" forState:UIControlStateNormal];
    [btnShare.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //[btnShare setImage:[UIImage imageNamed:@"btn_setting"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    //btnShare.imageEdgeInsets = UIEdgeInsetsMake(-1, -30, 0, 0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnShare];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showCenterView:(id)sender {
    [[self sliderViewController] showCenterView];
}


#pragma mark - 二维码扫描与生成
// 生成二维码
- (IBAction)EncodeActionTest:(id)sender
{
    
    NSError* error = nil;
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:@"02...<test>" // 海印移动商城之商品二维码02...<test>
                                  format:kBarcodeFormatQRCode
                                   width:500
                                  height:500
                                   error:&error];
    if (result) {
        //CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        //UIImage *imgCode = [[UIImage imageWithCGImage:image] copy];
        //UIImage *imgCode = [[UIImage alloc] initWithCGImage:image];
        //self.imgview.image = imgCode;
        self.imgview.image = [UIImage imageWithCGImage: [[ZXImage imageWithMatrix:result] cgimage]];
        //self.imgview.image = [UIImage imageWithCGImage:[[ZXImage imageWithMatrix:result] cgimage] scale:2 orientation:UIImageOrientationUp];
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString* errorMessage = [error localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示:编码失败" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

// 扫描二维码
- (IBAction)QRCodeScanActionTest:(id)sender
{
    ScanQRViewController *scanVC = [[ScanQRViewController alloc] initWithNibName:@"ScanQRViewController" bundle:nil];
    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:scanVC];
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}


#pragma mark - Share

// 分享
- (void)shareAction
{
    // 注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    // 如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:SHARE_CONTENT
                                     shareImage:[UIImage imageNamed:@"logo"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToEmail,UMShareToSms,nil]
                                       delegate:self];
}

/*
 // 点击每个平台后默认会进入内容编辑页面，若想点击后直接分享内容，可以实现下面的回调方法。
 // 弹出列表方法presentSnsIconSheetView需要设置delegate为self
 - (BOOL)isDirectShareInIconActionSheet
 {
 return YES;
 }
 */


#pragma mark - UMSocialUIDelegate

// 下面得到分享完成的回调
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    LogTrace(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    // 根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        LogInfo(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        [self toast:@"发送成功"];
    }
    else if(response.responseCode == UMSResponseCodeCancel)
    {
        [self toast:@"发送取消"];
    }
    /*
     else if (response.responseCode == UMSResponseCodeBaned)
     {
     [self toast:@"用户被封禁"];
     }
     else if (response.responseCode == UMSResponseCodeFaild)
     {
     [self toast:@"发送失败"];
     }
     else if (response.responseCode == UMSResponseCodeEmptyContent)
     {
     [self toast:@"发送内容为空"];
     }
     else if (response.responseCode == UMSResponseCodeShareRepeated)
     {
     [self toast:@"分享内容重复"];
     }
     else if (response.responseCode == UMSResponseCodeGetNoUidFromOauth)
     {
     [self toast:@"授权之后没有得到用户uid"];
     }
     else if (response.responseCode == UMSResponseCodeAccessTokenExpired)
     {
     [self toast:@"token过期"];
     }
     else if (response.responseCode == UMSResponseCodeNetworkError)
     {
     [self toast:@"网络错误"];
     }
     else if (response.responseCode == UMSResponseCodeGetProfileFailed)
     {
     [self toast:@"获取账户失败"];
     }
     else if (response.responseCode == UMSResponseCodeCancel)
     {
     [self toast:@"用户取消授权"];
     }
     */
    else
    {
        [self toast:@"发送失败"];
    }
}


#pragma mark - TEST

- (IBAction)memberCenterAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = (int)btn.tag;
    
    UserManager *user = [UserManager shareInstant];
    
    switch (tag) {
        case 80:
            [user userRegister:@"kingkong1024" withPassword:@"123456" andVerify:@"brave1024@163.com" completion:^(BOOL isSucceed, NSString *message) {
                if (isSucceed) {
                    NSLog(@"注册成功");
                }else {
                    NSLog(@"注册失败:%@", message);
                }
            }];
            break;
        case 81:
            [user userLogin:@"kingkong1024" withPassword:@"xygdp0" andType:@"2" completion:^(BOOL isSucceed, NSString *message) {
                if (isSucceed) {
                    NSLog(@"登录成功");
                }else {
                    NSLog(@"登录失败:%@", message);
                }
            }];
            break;
        case 82:
            [user userChangePassword:@"xygdp0" withNewPassword:@"123456" completion:^(BOOL isSucceed, NSString *message) {
                if (isSucceed) {
                    NSLog(@"修改密码成功");
                }else {
                    NSLog(@"修改密码失败:%@", message);
                }
            }];
            break;
        case 83:
            [user userGetPassword:@"kingkong1024" withVerify:@"lopo" andPasswrod:@"000000" completion:^(BOOL isSucceed, NSString *message) {
                if (isSucceed) {
                    NSLog(@"找回密码成功");
                }else {
                    NSLog(@"找回密码失败:%@", message);
                }
            }];
            break;
        case 84:
            [user userLogout:nil withPassword:nil completion:^(BOOL isSucceed, NSString *message) {
                if (isSucceed) {
                    NSLog(@"登出成功");
                }else {
                    NSLog(@"登出失败:%@", message);
                }
            }];
            break;
        case 85:
            [user userCenter:nil completion:^(BOOL isSucceed, NSString *message) {
                if (isSucceed) {
                    NSLog(@"获取会员中心信息成功");
                }else {
                    NSLog(@"获取会员中心信息失败:%@", message);
                }
            }];
            break;
        default:
            break;
    }
    
}

- (IBAction)getCategory:(id)sender
{
    [InterfaceManager getProductCategory:nil withPage:nil completion:^(BOOL isSucceed, NSString *message, id data) {
        if (isSucceed) {
            NSLog(@"获取商品分类成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
            NSError *error = nil;
            ProductCatListModel *productList = [[ProductCatListModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败");
                return;
            }
            ProductCatItemModel *item = [productList.cat_lists objectAtIndex:0];
            NSLog(@"id:%@, name:%@", item.cat_id, item.cat_name);
            
        }else {
            NSLog(@"获取商品分类失败:%@", message);
        }
    }];
}


@end
