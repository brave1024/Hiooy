//
//  PayViewController.m
//  hiooy
//
//  Created by retain on 14-4-28.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "PayViewController.h"
#import "PayProductView.h"
#import "PaymentCell.h"
#import "WebViewController.h"

#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"


@interface PayViewController ()

@end

@implementation PayViewController
@synthesize result = _result;

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
    
    self.navigationItem.title = @"支付";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
    //self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)211/255 green:(CGFloat)211/255 blue:(CGFloat)211/255 alpha:1];
    self.scrollview.backgroundColor = [UIColor clearColor];
    
    //self.viewBottom.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
    
    UIImage *img = [UIImage imageNamed:@"btn_red"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnPay setBackgroundImage:img forState:UIControlStateNormal];
    
    self.imgviewTop.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"addr_topbg"]];
    
//    self.tableviewPay.backgroundColor = [UIColor clearColor];
//    self.tableviewPay.backgroundView = nil;
    
    if (self.type == 0 && self.orderData != nil)
    {
        self.lblMoney.text = [NSString stringWithFormat:@"¥ %.2f", [self.orderData.pay_money floatValue]];
        [self showOrderInfo];
    }
    else if (self.type == 1 && self.orderDataAnother != nil)
    {
        self.lblMoney.text = [NSString stringWithFormat:@"¥ %.2f", [self.orderDataAnother.order.total_amount floatValue]];
        [self showOrderInfoToPay];
    }
    else
    {
        //
    }
    
    _result = @selector(paymentResult:);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToUserCenter) name:kBackToUserCenter object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 显示当前订单信息...<从购物车或立即购买流程中跳转过来>
- (void)showOrderInfo
{
    int count = self.orderData.goodslist.count;
    float viewHeight = 40*(count+2);
    self.viewOrder.frame = CGRectMake(0, 10, 320, viewHeight);
    
    int countPay = self.orderData.payments.count;
    float viewHeightPay = 50*countPay;
    self.viewPay.frame = CGRectMake(0, self.viewOrder.frame.size.height+20, 320, viewHeightPay);
    self.tableviewPay.frame = CGRectMake(0, 0, 320, self.viewPay.frame.size.height-1);
    self.tableviewPay.scrollEnabled = NO;
    self.viewPay.backgroundColor = [UIColor clearColor];
    
    self.viewBottom.frame = CGRectMake(0, self.viewPay.frame.origin.y+self.viewPay.frame.size.height+10, 320, 116);
    
    self.scrollview.contentSize = CGSizeMake(320, self.viewBottom.frame.origin.y+self.viewBottom.frame.size.height);
    
    for (int i = 0; i < count; i++)
    {
        PayProductModel *pro = [self.orderData.goodslist objectAtIndex:i];
        
        float rectY = 40*(i+1);
        PayProductView *proView = [PayProductView viewFromNib];
        proView.frame = CGRectMake(0, rectY, 320, 40);
        proView.lblTitle.text = pro.name;
        proView.lblNumber.text = pro.nums;
        [self.viewOrder addSubview:proView];
    }
    float rectY = 40*(count+1);
    PayProductView *proView = [PayProductView viewFromNib];
    proView.frame = CGRectMake(0, rectY, 320, 40);
    proView.lblTitle.text = @"订单总额";
    proView.lblNumber.text = [NSString stringWithFormat:@"¥ %.2f", [self.orderData.pay_money floatValue]];
    [self.viewOrder addSubview:proView];
    
//    for (int i = 0; i < countPay; i++)
//    {
//        CartResponsePaymentModel *pay = [self.orderData.payments objectAtIndex:i];
//        
//        float rectY = 50*i;
//        PaymentCell *payView = [PaymentCell cellFromNib];
//        payView.frame = CGRectMake(0, rectY, 320, 50);
//        [payView settingCell:pay];
//        [self.viewPay addSubview:payView];
//    }

    [self.tableviewPay reloadData];
    
}

// 显示订单信息...<从待付款订单界面中跳转过来>
- (void)showOrderInfoToPay
{
    int count = self.orderDataAnother.order.goodlist.count;
    float viewHeight = 40*(count+2);
    self.viewOrder.frame = CGRectMake(0, 10, 320, viewHeight);
    
    int countPay = self.orderDataAnother.payment_list.count;
    float viewHeightPay = 50*countPay;
    self.viewPay.frame = CGRectMake(0, self.viewOrder.frame.size.height+20, 320, viewHeightPay);
    self.tableviewPay.frame = CGRectMake(0, 0, 320, self.viewPay.frame.size.height-1);
    self.tableviewPay.scrollEnabled = NO;
    self.viewPay.backgroundColor = [UIColor clearColor];
    
    self.viewBottom.frame = CGRectMake(0, self.viewPay.frame.origin.y+self.viewPay.frame.size.height+10, 320, 116);
    
    self.scrollview.contentSize = CGSizeMake(320, self.viewBottom.frame.origin.y+self.viewBottom.frame.size.height);
    
    for (int i = 0; i < count; i++)
    {
        PayProductModel *pro = [self.orderDataAnother.order.goodlist objectAtIndex:i];
        
        float rectY = 40*(i+1);
        PayProductView *proView = [PayProductView viewFromNib];
        proView.frame = CGRectMake(0, rectY, 320, 40);
        proView.lblTitle.text = pro.name;
        proView.lblNumber.text = pro.nums;
        [self.viewOrder addSubview:proView];
    }
    float rectY = 40*(count+1);
    PayProductView *proView = [PayProductView viewFromNib];
    proView.frame = CGRectMake(0, rectY, 320, 40);
    proView.lblTitle.text = @"订单总额";
    proView.lblNumber.text = [NSString stringWithFormat:@"¥ %.2f", [self.orderDataAnother.order.total_amount floatValue]];
    [self.viewOrder addSubview:proView];
    
    [self.tableviewPay reloadData];
}

/*
"payments": [
             {
                 "app_display_name": "支付宝快捷支付",
                 "app_id": "kalipay",
                 "choosed": "true"
             },
             {
                 "app_display_name": "手机支付宝",
                 "app_id": "malipay",
                 "choosed": "false"
             },
             {
                 "app_display_name": "预存款支付",
                 "app_id": "deposit",
                 "choosed": "false"
             },
             {
                 "app_display_name": "通联互联网支付",
                 "app_id": "doubletenpay",
                 "choosed": "false"
             }
             ]
*/

// 支付
- (IBAction)payAction:(id)sender
{
    if (self.type == 0 && self.orderData == nil)
    {
        return;
    }
    
    if (self.type == 1 && self.orderDataAnother == nil)
    {
        return;
    }
    
    NSString *orderID = nil;
    if (self.type == 0)
    {
        orderID = self.orderData.order_id;
        
        for (int i = 0; i < self.orderData.payments.count; i++)
        {
            CartResponsePaymentModel *pay = [self.orderData.payments objectAtIndex:i];
            if ([pay.choosed isEqualToString:@"true"] == YES)
            {
                self.payType = pay;
            }
        }
    }
    else
    {
        NSLog(@"未付款订单支付");
        orderID = self.orderDataAnother.order.order_id;
        
        for (int i = 0; i < self.orderDataAnother.payment_list.count; i++)
        {
            CartResponsePaymentModel *pay = [self.orderDataAnother.payment_list objectAtIndex:i];
            if ([pay.choosed isEqualToString:@"true"] == YES)
            {
                self.payType = pay;
            }
        }
    }
    
    if (self.payType == nil)
    {
        return; // 若支付方式为空,则不可进行支付操作
    }
    
    // TEST
//    [self alipayAction];
//    return;
    
    [self startLoading:kLoading];
    
    // 提交
    [InterfaceManager payOrder:orderID withPayType:self.payType.app_id completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed) {
            NSLog(@"订单支付成功");
            
            if ([self.payType.app_id isEqualToString:@"deposit"] == YES)
            {
                /*
                {
                    "status": "success",
                    "msg": "支付成功！",
                    "data": ""
                }
                */
                
                // 账户余额支付
                [self toast:@"支付成功"];
                // 若用账户余额支付,则需跳转到个人中心
                [self.navigationController popToRootViewControllerAnimated:YES];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.willSelectedIndex = 3;
                appDelegate.tabVC.selectedIndex = 3;
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserCenter object:nil];
                
                return ;
            }
            else if ([self.payType.app_id isEqualToString:@"malipay"] == YES)
            {
                /*
                {
                    "status": "success",
                    "msg": "",
                    "data": {
                        "html": "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\r\n\t\t<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en-US\" lang=\"en-US\" dir=\"ltr\">\r\n\t\t<head>\r\n\t\t</head><body><div>Redirecting...</div><form action=\"http://wappaygw.alipay.com/service/rest.htm?_input_charset=utf-8\" method=\"GET\" name=\"pay_form\" id=\"pay_form\"><input type=\"hidden\" name=\"req_data\" value=\"<auth_and_execute_req><request_token>签名不正确</request_token></auth_and_execute_req>\" /><input type=\"hidden\" name=\"service\" value=\"alipay.wap.auth.authAndExecute\" /><input type=\"hidden\" name=\"sec_id\" value=\"MD5\" /><input type=\"hidden\" name=\"partner\" value=\"2088411106729982\" /><input type=\"hidden\" name=\"call_back_url\" value=\"http://linux.hiooy.com/ecstore/index.php/openapi/ectools_payment/parse/wap/wap_payment_plugin_malipay/callback/\" /><input type=\"hidden\" name=\"format\" value=\"xml\" /><input type=\"hidden\" name=\"v\" value=\"2.0\" /><input type=\"hidden\" name=\"sign\" value=\"14a99570567c4d0f912c585bcffd68d0\" /><input type=\"submit\" name=\"btn_purchase\" value=\"购买\" style=\"display:none;\" /></form><script type=\"text/javascript\">\r\n\t\t\t\t\t\twindow.onload=function(){\r\n\t\t\t\t\t\t\tdocument.getElementById(\"pay_form\").submit();\r\n\t\t\t\t\t\t}\r\n\t\t\t\t\t</script></body></html>"
                    }
                }
                */
                
                // 支付宝之网页支付
                NSDictionary *dic = [(NSDictionary *)data objectForKey:@"data"];
                NSString *htmlStr = [dic objectForKey:@"html"]; // 增加了html字段
                NSLog(@"html:%@", htmlStr);
                [self openWebviewForAlipay:htmlStr];
                return;
            }
            else if ([self.payType.app_id isEqualToString:@"kalipay"] == YES)
            {
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
            
            // 只剩下通联支付...~!@
            
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            self.alipayData = [[AliPayModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析错误:%@", error);
                [self toast:@"支付失败,请返回重试"];
                return;
            }
            //[self toast:@"订单支付成功"];
            
            if ([self.payType.app_id isEqualToString:@"doubletenpay"] == YES)
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
//            else if ([self.payType.app_id isEqualToString:@"malipay"] == YES)
//            {
//                // 支付宝支付
//                
//            }
//            else
//            {
//                // 账户余额支付
//                // 若用账户余额支付,则需跳转到个人中心
//                [self.navigationController popToRootViewControllerAnimated:YES];
//                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                appDelegate.willSelectedIndex = 3;
//                appDelegate.tabVC.selectedIndex = 3;
//                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserCenter object:nil];
//            }
        }else {
            NSLog(@"订单支付失败:%@", message);
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
    webviewVC.htmlStr = nil;
    NavigationViewController *navVC = [[NavigationViewController alloc] initWithRootViewController:webviewVC];
    [self presentViewController:navVC animated:YES completion:^{
        [self backToUserCenter];
    }];
    
//    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webviewVC];
//    if (__CUR_IOS_VERSION >= __IPHONE_7_0)
//    {
//        navVC.navigationBar.barTintColor = [UIColor colorWithRed:(CGFloat)114/255 green:(CGFloat)110/255 blue:(CGFloat)147/255 alpha:1];
//    }
//    else
//    {
//        navVC.navigationBar.tintColor = [UIColor colorWithRed:(CGFloat)114/255 green:(CGFloat)110/255 blue:(CGFloat)147/255 alpha:1];
//    }
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


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return self.orderData.payments.count;
    if (self.type == 0)
    {
        return self.orderData.payments.count;
    }
    else
    {
        return self.orderDataAnother.payment_list.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"PaymentCell";
    PaymentCell *cell = (PaymentCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [PaymentCell cellFromNib];
    }
    
    // Configure the cell...
//    CartResponsePaymentModel *pay = [self.orderData.payments objectAtIndex:indexPath.row];
//    [cell settingCell:pay];
    
    if (self.type == 0)
    {
        CartResponsePaymentModel *pay = [self.orderData.payments objectAtIndex:indexPath.row];
        [cell settingCell:pay];
    }
    else
    {
        CartResponsePaymentModel *pay = [self.orderDataAnother.payment_list objectAtIndex:indexPath.row];
        [cell settingCell:pay];
    }
    
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
    
    if (self.type == 0)
    {
        CartResponsePaymentModel *payCurrent = [self.orderData.payments objectAtIndex:indexPath.row];
        if ([payCurrent.choosed isEqualToString:@"true"] == NO)
        {
            for (int i = 0; i < self.orderData.payments.count; i++)
            {
                CartResponsePaymentModel *pay = [self.orderData.payments objectAtIndex:i];
                pay.choosed = @"false";
            }
            payCurrent.choosed = @"true";
            [self.tableviewPay reloadData];
        }
    }
    else
    {
        CartResponsePaymentModel *payCurrent = [self.orderDataAnother.payment_list objectAtIndex:indexPath.row];
        if ([payCurrent.choosed isEqualToString:@"true"] == NO)
        {
            for (int i = 0; i < self.orderDataAnother.payment_list.count; i++)
            {
                CartResponsePaymentModel *pay = [self.orderDataAnother.payment_list objectAtIndex:i];
                pay.choosed = @"false";
            }
            payCurrent.choosed = @"true";
            [self.tableviewPay reloadData];
        }
    }
    
//    CartResponsePaymentModel *payCurrent = [self.orderData.payments objectAtIndex:indexPath.row];
//    if ([payCurrent.choosed isEqualToString:@"true"] == NO)
//    {
//        for (int i = 0; i < self.orderData.payments.count; i++)
//        {
//            CartResponsePaymentModel *pay = [self.orderData.payments objectAtIndex:i];
//            pay.choosed = @"false";
//        }
//        payCurrent.choosed = @"true";
//        [self.tableviewPay reloadData];
//    }
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
	order.notifyURL =  kNotifyUrl; //回调URL
	
	return [order description];
}

// 本地生成订单号...<不使用>
//- (NSString *)generateTradeNO
//{
//	const int N = 15;
//	
//	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//	NSMutableString *result = [[NSMutableString alloc] init] ;
//	srand(time(0));
//	for (int i = 0; i < N; i++)
//	{
//		unsigned index = rand() % [sourceString length];
//		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
//		[result appendString:s];
//	}
//	return result;
//}

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
