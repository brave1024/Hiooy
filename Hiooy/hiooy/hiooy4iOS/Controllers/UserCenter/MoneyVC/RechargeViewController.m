//
//  RechargeViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "RechargeViewController.h"
#import "WebViewController.h"

#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

@interface RechargeViewController ()

@end

@implementation RechargeViewController
@synthesize result = _result;

#define kTag 100

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
    
    self.navigationItem.title = @"预存款充值";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)220/255 green:(CGFloat)220/255 blue:(CGFloat)220/255 alpha:1];
    
    UIImage *img = [UIImage imageNamed:@"btn_red"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnPay setBackgroundImage:img forState:UIControlStateNormal];
    
    UIImage *img_ = [UIImage imageNamed:@"search_box"];
    img_ = [img_ stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    self.imgviewNumber.image = img_;
    self.imgviewPay.image = img_;
    
    self.arrayEdit = [[NSMutableArray alloc] initWithObjects:self.txtfieldNumber, nil];
    self.keyboardbar = [[KeyBoardTopBar alloc] init];
    [self.keyboardbar setAllowShowPreAndNext:NO];  // 隐藏前一项、后一项
    [self.keyboardbar setIsInNavigationController:NO];
    [self.keyboardbar setTextFieldsArray:self.arrayEdit];
    self.txtfieldNumber.inputAccessoryView = self.keyboardbar.view;
    
    _result = @selector(paymentResult:);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToUserCenter) name:kBackToUserCenter object:nil];
    
    // 获取预存款支付方式列表
    [self requestRechargeMethod];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestRechargeMethod
{
    [self startLoading:kLoading];
    
    [InterfaceManager getRechargeMethods:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSLog(@"获取预存款支付方式成功");
            NSDictionary *dic = [(NSDictionary *)data objectForKey:@"data"];
            NSError *error = nil;
            self.rechargeList = [[RechargeMethodModel alloc] initWithDictionary:dic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析错误:%@", error);
            }
            else
            {
                if (self.rechargeList == nil || self.rechargeList.payments == nil || self.rechargeList.payments.count == 0)
                {
                    [self toast:@"未获取到支付方式,请返回重试"];
                    return;
                }
                [self showRechargeMethods];
            }
        }
        else
        {
            [self toast:message];
        }
    }];
}

- (void)showRechargeMethods
{
    int count = self.rechargeList.payments.count;
    self.viewPay.frame = CGRectMake(24, 64, 272, 42+38*count);
    self.btnPay.frame = CGRectMake(26, self.viewPay.frame.origin.y+self.viewPay.frame.size.height+20, 268, 42);
    
    for (int i = 0; i < count; i++)
    {
        CartResponsePaymentModel *payment = [self.rechargeList.payments objectAtIndex:i];
        RechargeView *view = [RechargeView viewFromNib];
        view.delegate = self;
        view.tag = kTag+i;
        view.frame = CGRectMake(0, 40+38*i, 272, 38);
        [self.viewPay addSubview:view];
        
        if (i == 0)
        {
            payment.choosed = @"true";
        }
        else
        {
            payment.choosed = @"false";
        }
        [view settingView:payment];
    }
}

- (void)hideKeyboard
{
    [self.txtfieldNumber resignFirstResponder];
    //[self.txtfieldPay resignFirstResponder];
}

//- (IBAction)selectPayMethod:(id)sender
//{
//    [self hideKeyboard];
//    
//    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"支付宝" otherButtonTitles:@"银联", nil];
//    [action showInView:self.view];
//}

// 预存款提交
- (IBAction)btnPayAction:(id)sender
{
    [self hideKeyboard];
    
    if ([TextVerifyHelper checkContent:self.txtfieldNumber.text] == NO)
    {
        [self toast:@"请输入充值金额"];
        return;
    }
    
    if (self.rechargeList == nil || self.rechargeList.payments == nil || self.rechargeList.payments.count == 0)
    {
        [self toast:@"未获取到支付方式,请返回重试"];
        return;
    }
    
    NSString *pay = nil;
    for (CartResponsePaymentModel *payment in self.rechargeList.payments)
    {
        if ([payment.choosed isEqualToString:@"true"] == YES)
        {
            pay = [payment.app_id copy];
            break;
        }
    }
    if (pay == nil || [pay isEqualToString:@""] == YES)
    {
        [self toast:@"请选择支付方式"];
        return;
    }
    
    [self startLoading:kLoading];
    
    NSString *moneyStr = self.txtfieldNumber.text;
    
    // Test
    //moneyStr = @"0.01";
    
    [InterfaceManager RechargeAccount:moneyStr andPayType:pay completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSLog(@"预存款提交成功");
            
            if ([pay isEqualToString:@"malipay"] == YES)
            {
                // 支付宝之网页支付
                NSDictionary *dic = [(NSDictionary *)data objectForKey:@"data"];
                NSString *htmlStr = [dic objectForKey:@"html"]; // 增加了html字段
                NSLog(@"html:%@", htmlStr);
                [self openWebviewForAlipay:htmlStr];
                return;
            }
            else if ([pay isEqualToString:@"kalipay"] == YES)
            {
                /*
                {
                    "status": "success",
                    "msg": "",
                    "data": {
                        "payment_id": "14014179846953",
                        "money": "1",
                        "goods_name": "充值",
                        "goods_body": "海印生活圈个人账户充值"
                    }
                }
                */
                
                // 支付宝之快捷支付
                NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                NSError *error = nil;
                self.alipayOrder = [[AlipayOrderModel alloc] initWithDictionary:dataDic error:&error];
                if (error != nil)
                {
                    NSLog(@"json解析错误:%@", error);
                    [self toast:@"支付失败,请返回重试"];
                    return;
                }
                // 开始支付操作
                [self alipayAction];
                return;
            }
            
            /*****************************************************************/
            // 以下是通联支付方式
            /*****************************************************************/
            
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            self.alipayData = [[AliPayModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析错误:%@", error);
                [self toast:@"支付失败,请返回重试"];
                return;
            }
            
            if ([pay isEqualToString:@"doubletenpay"] == YES)
            {
                /*
                 {
                 "status": "success",
                 "msg": "",
                 "data": {
                 "url": "http://linux.hiooy.com/ecstore/api/tlpay/index.php/Home/Index/index/orderid/201405261905939"
                 }
                 }
                 */
                // 银联之通联支付
                [self openWebview:self.alipayData.url andDataToPost:self.alipayData.post];
            }
        }
        else
        {
            [self toast:message];
        }
    }];
}

// 通联支付时,调用内置浏览器打开url
- (void)openWebview:(NSString *)urlStr andDataToPost:(id)data
{
    WebViewController *webviewVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webviewVC.url = [NSURL URLWithString:urlStr];
    webviewVC.post = (AliPayPostModel *)data;
    NavigationViewController *navVC = [[NavigationViewController alloc] initWithRootViewController:webviewVC];
    [self presentViewController:navVC animated:YES completion:^{
        [self backToUserCenter];
    }];
}

// 支付宝网页支付时,调用内置浏览器打开url
- (void)openWebviewForAlipay:(NSString *)html
{
    WebViewController *webviewVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webviewVC.url = nil;
    webviewVC.post = nil;
    webviewVC.htmlStr = html;
    NavigationViewController *navVC = [[NavigationViewController alloc] initWithRootViewController:webviewVC];
    [self presentViewController:navVC animated:YES completion:^{
        [self backToUserCenter];
    }];
}

// 交易成功,则返回到个人中心主界面
- (void)backToUserCenter
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.willSelectedIndex = 3;
    appDelegate.tabVC.selectedIndex = 3;
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserCenter object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}


#pragma mark - RechargeViewDelegate

- (void)payMethodSelected:(int)tag
{
    NSLog(@"当前选择的支付方式索引为:%d", tag);
    CartResponsePaymentModel *payment = [self.rechargeList.payments objectAtIndex:tag];
    if ([payment.choosed isEqualToString:@"true"] == YES)
    {
        //
    }
    else
    {
        for (CartResponsePaymentModel *item in self.rechargeList.payments)
        {
            item.choosed = @"false";
        }
        payment.choosed = @"true";
        // 更新
        NSArray *arr = [self.viewPay subviews];
        for (UIView *view in arr)
        {
            if ([view isKindOfClass:[RechargeView class]] == YES)
            {
                int myTag = view.tag - kTag;
                [(RechargeView *)view settingView:[self.rechargeList.payments objectAtIndex:myTag]];
            }
        }
    }
}


//#pragma mark - UIActionSheetDelegate
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        NSLog(@"支付宝");
//        self.txtfieldPay.text = @"支付宝";
//    }
//    else if (buttonIndex == 1)
//    {
//        NSLog(@"银联");
//        self.txtfieldPay.text = @"银联";
//    }
//    else if (buttonIndex == 2)
//    {
//        //
//    }
//    else
//    {
//        //
//    }
//}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.txtfieldNumber.text == nil || self.txtfieldNumber.text.length == 0)
    {
        return;
    }
    int number = [self.txtfieldNumber.text intValue];
    self.txtfieldNumber.text = [NSString stringWithFormat:@"%d", number];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // KeyBoardTopBar的实例对象调用显示键盘方法
    [self.keyboardbar showBar:textField];
}


#pragma mark - AliPay

//wap回调函数
- (void)paymentResult:(NSString *)resultd
{
    NSLog(@"wap回调函数...~!@");
    
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSLog(@"交易成功");
            
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                NSLog(@"验证签名成功，交易结果无篡改");
                [self toast:@"交易成功"];
                [self backToUserCenter];
                return;
			}
            else
            {
                NSLog(@"验证签名失败，交易结果已被篡改~!@");
            }
        }
        else
        {
            //交易失败
            NSLog(@"交易失败");
            [self toast:@"交易失败"];
        }
    }
    else
    {
        //失败
        NSLog(@"失败");
        [self toast:@"交易取消"];
    }
    
    [self backToUserCenter];
}

// 支付宝支付
- (void)alipayAction
{
    NSString *appScheme = AppScheme;
    NSString *orderInfo = [self getOrderInfo];
    NSString *signedStr = [self doRsa:orderInfo];
    
    NSLog(@"appScheme:%@", appScheme);
    NSLog(@"orderInfo:%@", orderInfo);
    NSLog(@"signedStr:%@", signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
	
    NSLog(@"orderString:%@", orderString);
    
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
}

- (NSString*)getOrderInfo
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
	//AlipayOrderModel *product = self.alipayOrder;
    
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
//	order.productName = @"话费充值"; //商品标题
//	order.productDescription = @"[四钻信誉]北京移动30元 电脑全自动充值 1到10分钟内到账"; //商品描述
//	order.amount = @"0.02"; //商品价格
    
    order.tradeNO = self.alipayOrder.payment_id; //订单ID（由商家自行制定）
    order.productName = self.alipayOrder.goods_name; //商品标题
	order.productDescription = self.alipayOrder.goods_body ? self.alipayOrder.goods_body : @""; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",[self.alipayOrder.money floatValue]]; //商品价格
    //order.amount = @"0.02";
	order.notifyURL =  kNotifyUrl; //回调URL
	
	return [order description];
}

// 本地生成订单号...<不使用>
- (NSString *)generateTradeNO
{
	const int N = 15;

	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

// 将订单信息进行rsa加密或签名
- (NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

- (void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"paymentResult:%@",result);
}


@end
