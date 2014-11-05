//
//  CartSubmitViewController.m
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "CartSubmitViewController.h"
#import "OrderCell.h"
#import "AddressSelectViewController.h"
#import "PaymentViewController.h"
#import "ShippingSelectViewController.h"
#import "CartSellerGoodsModel.h"
#import "CartSubmitResponseModel.h"
#import "PayViewController.h"
#import "EditAddrViewController.h"

@interface CartSubmitViewController ()
@property (nonatomic, assign) CGRect viewRect;
@property (nonatomic, strong) PayAndMemoView *viewPay;
@end


@implementation CartSubmitViewController

#define kCellHeight 102
#define kCellHeaderHeight 42
#define kCellFooterHeight 50
#define kFooterTxtTag 888

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
    
    self.navigationItem.title = @"提交订单";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
    
    self.viewBottom.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.showsVerticalScrollIndicator = NO;
    
    UIImage *img = [UIImage imageNamed:@"btn_red"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnSubmit setBackgroundImage:img forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAndShowUserNewAddress:) name:kShowUserNewAddress object:nil];
    
    self.lblCount.text = @"";
    self.lblMoney.text = @"";
    _viewRect = self.tableview.frame;
    
    if (self.type == 0) // 立即购买
    {
        if (self.cartSubmitRes != nil)
        {
            self.arrayCart = (NSMutableArray<CartResponseItemModel> *)self.cartSubmitRes.aCart;
            [self showAllGoodsPrice];
            [self.tableview reloadData];
        }
    }
    else                // 购物车购买
    {
        [self requestCartSubmit];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.arrayCart = (NSMutableArray<CartResponseItemModel> *)self.cartSubmitRes.aCart;
    [self.tableview reloadData];
}

// 提交购物车,获取提交后的相关数据
- (void)requestCartSubmit
{
    [self startLoading:kLoading];
    
    // 提交
    [InterfaceManager submitShoppingCart:self.cartSubmitReq completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed) {
            NSLog(@"提交购物车成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            self.cartSubmitRes = [[CartResponseModel alloc] initWithDictionary:dataDic error:&error];
            if (error)
            {
                NSLog(@"json解析失败");
            }
            else
            {
                NSLog(@"seller count:%d, total:%@", self.cartSubmitRes.aCart.count, self.cartSubmitRes.total);
                self.arrayCart = (NSMutableArray<CartResponseItemModel> *)self.cartSubmitRes.aCart;
                [self showAllGoodsPrice];
                [self.tableview reloadData];
            }
        }else {
            NSLog(@"提交购物车失败:%@", message);
        }
    }];
}

// 提交订单
- (IBAction)submitBtnTouched:(id)sender
{
    //NSLog(@"current Data:%@", self.cartSubmitRes);
    
    // 需传递的参数实体
    CartSubmitRequestModel *submit = [[CartSubmitRequestModel alloc] init];
    submit.member_id = [[UserManager shareInstant] getMemberId];
    submit.addr_id = [self getAddressId];
    submit.payment_app_id = [self getPaymentId];
    //submit.memo = [self getMemo];
    submit.memo = self.strMemo;
    NSLog(@"addressid:%@, paymentid:%@, memo:%@", [self getAddressId], [self getPaymentId], self.strMemo);
    
    if (submit.addr_id == nil || [submit.addr_id isEqualToString:@""] == YES)
    {
        [self toast:@"请先选择或添加收货地址"];
        return;
    }
    
    NSMutableArray *arraySeller = [[NSMutableArray alloc] init];    // 保存所有seller
    for (int i = 0; i < self.arrayCart.count; i++)
    {
        CartResponseItemModel *seller = [self.arrayCart objectAtIndex:i];  // 商家
        if ([seller.seller_info.selected isEqualToString:@"true"] == YES && [seller.items_quantity intValue] > 0)
        {   // 当前商家下有被选中的商品,才会进行后续处理
            CartSubmitSellerModel *sellerSubmit = [[CartSubmitSellerModel alloc] init];
            sellerSubmit.seller_id = seller.seller_info.seller_id;
            sellerSubmit.shipping_id = [NSString stringWithString:[self getShippingId:seller]];
            NSMutableArray *arrayGoods = [[NSMutableArray alloc] init]; // 保存当前seller下的所有goods
            for (int j = 0; j < seller.goods.count; j++)
            {
                CartGoodsModel *goods = [seller.goods objectAtIndex:j];
                if ([goods.selected isEqualToString:@"true"] == YES)
                {
                    CartSumbitGoodsModel *goodsSubmit = [[CartSumbitGoodsModel alloc] init];
                    goodsSubmit.goods_id = goods.goods_id;
                    goodsSubmit.product_id = goods.product_id;
                    goodsSubmit.num = goods.quantity;
                    [arrayGoods addObject:goodsSubmit];
                }
                else
                {
                    //NSLog(@"当前goods<%@>未被选中...seller<%@>", goods.name, seller.seller_info.seller_name);
                }
            }   // for
            sellerSubmit.goods = (NSArray<CartSumbitGoodsModel> *)arrayGoods;
            [arraySeller addObject:sellerSubmit];
        }
        else
        {
            //NSLog(@"当前seller<%@>下无选中商品", seller.seller_info.seller_name);
        }
    }   // for
    submit.seller = (NSArray<CartSubmitSellerModel> *)arraySeller;
    
    /*
    {
        "addr_id": "1",
        "member_id": "2",
        "seller": {
            "10": {
                "shipping_id": "1"
            },
            "21": {
                "shipping_id": "18"
            }
        },
        "payment_app_id": "deposit"
    }
    */
    
    /*
    {
        "member_id": "2",
        "payment_app_id": "malipay",
        "addr_id": "24",
        "memo": "夏志勇",
        "seller": {
            "10": {
                "shipping_id": "1"
            },
            "21": {
                "shipping_id": "18"
            }
        }
    }
    */
    
    // 生成seller dic
    // 只针对购物车情况...
    // 立即购买情况单独提出...~!@
    NSMutableDictionary *sellerDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < submit.seller.count; i++)
    {
        CartSubmitSellerModel *seller = [submit.seller objectAtIndex:i];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:seller.shipping_id, @"shipping_id", nil];
        //NSDictionary *myDic = [[NSDictionary alloc] initWithObjectsAndKeys:dic, seller.seller_id, nil];
        [sellerDic setObject:dic forKey:seller.seller_id];
    }
    
    NSLog(@"seller:%@", sellerDic);
    
    if (sellerDic.count == 0)
    {
        [self toast:@"配送方式不能为空"];
        return;
    }
    
    if (submit.memo == nil)
    {
        submit.memo = @"";
    }
    
    NSDictionary *resDic = nil;
    if (self.type == 0 || self.type == 2) // 立即购买
    {
        // 立即购买只能有一个商家，一个商品
        // 需要传递 goods_id product_id num
        CartGoodsModel *goodsItem = nil;
        
        if (self.arrayCart.count == 0)
        {
            [self toast:@"购物车中商品数据错误,无法提交"];
            return;
        }
        else
        {
            CartResponseItemModel *cartItem = [self.arrayCart objectAtIndex:0];
            if (cartItem.goods.count == 0)
            {
                [self toast:@"购物车中商品数据错误,无法提交"];
                return;
            }
            else
            {
                goodsItem = [cartItem.goods objectAtIndex:0];
            }
        }
        
        if (goodsItem == nil)
        {
            [self toast:@"购物车中商品数据错误,无法提交"];
            return;
        }
        
        /*
        {
            "payment_app_id": "malipay",
            "member_id": "115",
            "seller": {
                "21": {
                    "shipping_id": "11",
                    "goods_id": "98",
                    "product_id": "107",
                    "num": "1"
                }
            },
            "is_fast": "1",
            "addr_id": "115"
        }
        */
        
        /*
        {
            "member_id": "101",
            "is_fast": "1",
            "payment_app_id": "kalipay",
            "addr_id": "108",
            "seller": {
                "21": {
                    "shipping_id": "11",
                    "product_id": "114",
                    "goods_id": "105",
                    "num": "1"
                }
            },
            "memo": "夏志勇"
        }
        */
        
        /*
        {
            "member_id": "101",
            "is_group": "1",
            "payment_app_id": "kalipay",
            "addr_id": "121",
            "seller": {
                "21": {
                    "shipping_id": "11",
                    "product_id": "122",
                    "goods_id": "113",
                    "num": "1"
                }
            },
            "memo": "COOKOV"
        }
        */
        
        NSString *goodsID = goodsItem.goods_id ? goodsItem.goods_id : @"";
        NSString *productID = goodsItem.product_id ? goodsItem.product_id : @"";
        NSString *num = goodsItem.quantity ? goodsItem.quantity : @"1";
        
        // 立即购买时,只可能有一个商家
        NSMutableDictionary *sellerDic = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < submit.seller.count; i++)
        {
            CartSubmitSellerModel *seller = [submit.seller objectAtIndex:i];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 seller.shipping_id, @"shipping_id",
                                 goodsID, @"goods_id",
                                 productID, @"product_id",
                                 num, @"num", nil];
            [sellerDic setObject:dic forKey:seller.seller_id];
        }
        
//        resDic = [[NSDictionary alloc] initWithObjectsAndKeys:submit.member_id, @"member_id",
//                  submit.addr_id, @"addr_id", submit.payment_app_id, @"payment_app_id", sellerDic, @"seller", submit.memo, @"memo", @"1", @"is_fast", nil];
        
        if (self.type == 0) // 立即购买
        {
            resDic = [[NSDictionary alloc] initWithObjectsAndKeys:submit.member_id, @"member_id",
                      submit.addr_id, @"addr_id", submit.payment_app_id, @"payment_app_id", sellerDic, @"seller", submit.memo, @"memo", @"1", @"is_fast", nil];
        }
        else                // 团购秒杀
        {
            resDic = [[NSDictionary alloc] initWithObjectsAndKeys:submit.member_id, @"member_id",
                      submit.addr_id, @"addr_id", submit.payment_app_id, @"payment_app_id", sellerDic, @"seller", submit.memo, @"memo", @"1", @"is_group", nil];
        }
    }
    else                // 购物车购买
    {
        resDic = [[NSDictionary alloc] initWithObjectsAndKeys:submit.member_id, @"member_id",
                  submit.addr_id, @"addr_id", submit.payment_app_id, @"payment_app_id", sellerDic, @"seller", submit.memo, @"memo", nil];
    }
    
//    NSDictionary *resDic = [[NSDictionary alloc] initWithObjectsAndKeys:submit.member_id, @"member_id",
//                         submit.addr_id, @"addr_id", submit.payment_app_id, @"payment_app_id", sellerDic, @"seller", submit.memo, @"memo", @"1", @"is_fast", nil];
    
    [self startLoading:kLoading];
    
    // 提交
    [InterfaceManager submitOrder:resDic completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed) {
            NSLog(@"提交订单成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            CartSubmitResponseModel *cartResponse = [[CartSubmitResponseModel alloc] initWithDictionary:dataDic error:&error];
            if (error)
            {
                NSLog(@"json解析失败");
            }
            else
            {
                NSLog(@"%@", [(NSDictionary *)data objectForKey:@"msg"]);
                PayViewController *payVC = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
                payVC.type = 0; // 直接进入支付界面,而不是从之前老的待付款订单中进入
                payVC.orderData = cartResponse;
                payVC.orderDataAnother = nil;
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }else {
            NSLog(@"提交订单失败:%@", message);
            [self toast:message];
        }
    }];
}

// 显示总金额
- (void)showAllGoodsPrice
{
    // 总金额
    float totalPrice = [self.cartSubmitRes.total floatValue];
    // 总数量
    int count = 0;
    for (int i = 0; i < self.arrayCart.count; i++)
    {
        CartResponseItemModel *seller = [self.arrayCart objectAtIndex:i];
        int num = [seller.items_quantity intValue];
        count += num;
//        for (int j = 0; j < seller.goods.count; j++)
//        {
//            CartGoodsModel *goods = [seller.goods objectAtIndex:j];
//            int num = [goods.quantity intValue];
//        }
    }
    self.lblCount.text = [NSString stringWithFormat:@"共计%d件商品", count];
    self.lblMoney.text = [NSString stringWithFormat:@"¥ %.2f", totalPrice];
}

// 新注册用户在正式添加地址前进行购物操作,则订单中不会返回地址信息;
// 需用户在当前界面立即添加新地址
- (void)getAndShowUserNewAddress:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSError *error = nil;
    AddressModel *addrNew = [[AddressModel alloc] initWithDictionary:dic error:&error];
    if (error != nil)
    {
        NSLog(@"json解析失败:%@", error);
        return;
    }
    NSLog(@"addressId:%@", addrNew.addr_id);
    
    CartResponseAddressModel *myAddr = [[CartResponseAddressModel alloc] init];
    myAddr.addr_id = addrNew.addr_id;
    myAddr.address = addrNew.addr;
    myAddr.mobile = addrNew.phone.mobile;
    myAddr.telephone = addrNew.phone.tel;
    myAddr.name = addrNew.name;
    myAddr.choosed = @"true";
    
    self.cartSubmitRes.def_arr_addr = myAddr;
    self.cartSubmitRes.addrlist = (NSArray<CartResponseAddressModel, Optional> *)[NSArray arrayWithObject:myAddr];
    
    [self.tableview reloadData];
    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 320, 50) animated:NO];
}


#pragma mark - GetID

- (NSString *)getAddressId
{
    if (self.cartSubmitRes.def_arr_addr == nil)
    {
        return @"";
    }
    else
    {
        NSLog(@"addrId:%@", self.cartSubmitRes.def_arr_addr.addr_id);
        return self.cartSubmitRes.def_arr_addr.addr_id;
    }
}

- (NSString *)getPaymentId
{
    if (self.cartSubmitRes.payment == nil
        || self.cartSubmitRes.payment.count == 0)
    {
        return @"";
    }
    else
    {
        for (int i = 0; i < self.cartSubmitRes.payment.count; i++)
        {
            CartResponsePaymentModel *payment = [self.cartSubmitRes.payment objectAtIndex:i];
            if ([payment.choosed isEqualToString:@"true"] == YES)
            {
                NSLog(@"appId:%@", payment.app_id);
                return payment.app_id;
            }
        }
        return @"";
    }
}

- (NSString *)getShippingId:(CartResponseItemModel *)seller
{
    if (seller.shipping == nil
        || seller.shipping.count == 0)
    {
        return @"";
    }
    else
    {
        for (int i = 0; i < seller.shipping.count; i++)
        {
            CartResponseShippingModel *shipping = [seller.shipping objectAtIndex:i];
            if ([shipping.choosed isEqualToString:@"true"] == YES)
            {
                NSLog(@"shippingId:%@", shipping.dt_id);
                return shipping.dt_id;
            }
        }
        return @"";
    }
}

- (NSString *)getMemo
{
    NSString *memo = @"";
    // 获取最后一个section下面的footerview
    // bug...获取到的footerview为空~!@
//    UIView *footerview = [self.tableview footerViewForSection:self.arrayCart.count-1];
//    PayAndMemoView *memoView = (PayAndMemoView *)[footerview viewWithTag:kFooterTxtTag];
    if (_viewPay)
    {
        UITextView *txtview = (UITextView *)[_viewPay viewWithTag:kFooterTxtTag+1];
        BOOL isValid = [TextVerifyHelper checkContent:txtview.text];
        if (isValid)
        {
            memo = [txtview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    NSLog(@"memo:%@", memo);
    return memo;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //return (CGFloat)kCellHeaderHeight + 10;
    if (section == 0)
    {
        return (CGFloat)kCellHeaderHeight + 10 + 85 + 10;
    }
    else
    {
        return (CGFloat)kCellHeaderHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CartResponseItemModel *seller = [self.arrayCart objectAtIndex:section];
    
    // 第一个section单独考虑
    if (section == 0)
    {
        UIView *viewAll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellHeaderHeight + 10 + 85 + 10)];
        viewAll.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
        
        //UIView *viewAddr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
        AddressView *viewAddr = [AddressView viewFromNib];
        [viewAddr settingView:nil];
        viewAddr.delegate = self;
        viewAddr.frame = CGRectMake(0, 10, 320, 85);
        //viewAddr.backgroundColor = [UIColor clearColor];
        
        // 获取默认地址
        CartResponseAddressModel *address = self.cartSubmitRes.def_arr_addr;
        if (address == nil)
        {
            viewAddr.lblTip.hidden = NO;
            viewAddr.lblTitle.hidden = YES;
            viewAddr.lblName.hidden = YES;
            viewAddr.lblPhone.hidden = YES;
            viewAddr.lblAddress.hidden = YES;
        }
        else
        {
            viewAddr.lblTip.hidden = YES;
            viewAddr.lblTitle.hidden = NO;
            viewAddr.lblName.hidden = NO;
            viewAddr.lblPhone.hidden = NO;
            viewAddr.lblAddress.hidden = NO;
            
            viewAddr.lblName.text = address.name;
            viewAddr.lblPhone.text = address.mobile;
            viewAddr.lblAddress.text = address.address;
        }
        
        /*********************************************************************/
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 85+10+10, 320, kCellHeaderHeight)];
        view.tag = section;
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.8)];
        viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)220/255 green:(CGFloat)220/255 blue:(CGFloat)223/255 alpha:1];
        
        UILabel *lblStore = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 189, 30)];
        lblStore.textAlignment = NSTextAlignmentLeft;
        lblStore.font = [UIFont systemFontOfSize:14];
        //lblStore.text = @"海印直营";
        lblStore.text = seller.seller_info.seller_name;
        
        [view addSubview:viewLine];
        [view addSubview:lblStore];
        
        [viewAll addSubview:viewAddr];
        [viewAll addSubview: view];
        
        return viewAll;
    }
    
    /*********************************************************************/
    
    UIView *viewAll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellHeaderHeight)];
    viewAll.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellHeaderHeight)];
    view.tag = section;
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.8)];
    viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)220/255 green:(CGFloat)220/255 blue:(CGFloat)223/255 alpha:1];
    
    UILabel *lblStore = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 189, 30)];
    lblStore.textAlignment = NSTextAlignmentLeft;
    lblStore.font = [UIFont systemFontOfSize:14];
    //lblStore.text = @"海印直营";
    lblStore.text = seller.seller_info.seller_name;

    [view addSubview:viewLine];
    [view addSubview:lblStore];
    [viewAll addSubview: view];
    
    return viewAll;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.arrayCart.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    CartResponseItemModel *seller = [self.arrayCart objectAtIndex:section];
    return seller.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"orderCell";
    OrderCell *cell = (OrderCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [OrderCell cellFromNib];
    }
    //cell.delegate = self;
    
    // Configure the cell...
    
    CartResponseItemModel *seller = [self.arrayCart objectAtIndex:indexPath.section];
    CartGoodsModel *goods = [seller.goods objectAtIndex:indexPath.row];
    [cell settingCell:goods];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //return (CGFloat)kCellFooterHeight + 10;
    if (section == self.arrayCart.count - 1)
    {
        return (CGFloat)kCellFooterHeight + 10 + 180;
    }
    else
    {
        return (CGFloat)kCellFooterHeight + 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == self.arrayCart.count - 1)
    {
        //PayAndMemoView *viewPay = [PayAndMemoView viewFromNib];
        self.footview = [PayAndMemoView viewFromNib];
        self.footview.tag = kFooterTxtTag;
        self.footview.txtviewMemo.tag = kFooterTxtTag+1;
        self.footview.delegate = self;
        [self.footview settingView:nil];
        self.footview.frame = CGRectMake(0, kCellFooterHeight + 10, 320, 180);
        self.footview.backgroundColor = [UIColor clearColor];
        
        // 显示备注信息
        if (self.strMemo == nil || [self.strMemo isEqualToString:@""] == YES)
        {
            self.footview.txtviewMemo.text = @"";
            self.footview.lblTip.hidden = NO;
        }
        else
        {
            self.footview.txtviewMemo.text = self.strMemo;
            self.footview.lblTip.hidden = YES;
        }
        
        // 获取支付方式
        NSArray *arrayPay = self.cartSubmitRes.payment;
        if (arrayPay == nil || arrayPay.count == 0)
        {
            self.footview.lblName.text = @"";
        }
        else
        {
            BOOL hasChoosed = NO;
            for (int i = 0; i < arrayPay.count; i++)
            {
                CartResponsePaymentModel *pay = [arrayPay objectAtIndex:i];
                if ([pay.choosed isEqualToString:@"true"] == YES)
                {
                    self.footview.lblName.text = pay.app_display_name;
                    hasChoosed = YES;
                    break;
                }
            }
            if (hasChoosed == NO)
            {
                self.footview.lblName.text = @"";
            }
        }
        
        // 显示优惠金额
        float totalPrice = 0.0;
        float realPrice = [self.cartSubmitRes.total floatValue];
        for (CartResponseItemModel *seller in self.cartSubmitRes.aCart)
        {
            totalPrice += [seller.subtotal floatValue];
        }
        if (totalPrice > realPrice)
        {
            self.footview.lblMoney.text = [NSString stringWithFormat:@"%.2f 元", totalPrice-realPrice];
        }
        
        /*********************************************************************/
        
        CartResponseItemModel *seller = [self.arrayCart objectAtIndex:section];
        int shippingIndex = 0;
        BOOL hasShipping = NO;
        if (seller.shipping != nil && seller.shipping.count > 0)
        {
            hasShipping = YES;
            for (int i = 0; i < seller.shipping.count; i++)
            {
                // 找到选中的配送方式
                CartResponseShippingModel *shipping = [seller.shipping objectAtIndex:i];
                if ([shipping.choosed isEqualToString:@"true"] == YES)
                {
                    shippingIndex = i;
                    break;
                }
            }
        }
        else
        {
            //
        }
        
        UIView *viewAll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellFooterHeight + 10 + 120)];
        viewAll.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellFooterHeight)];
        view.tag = section;
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *btnShipping = [UIButton buttonWithType:UIButtonTypeCustom];
        btnShipping.frame = CGRectMake(0, 0, 320, 50);
        btnShipping.tag = section;
        [btnShipping setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg_press"] forState:UIControlStateHighlighted];
        [btnShipping setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg"] forState:UIControlStateNormal];
        [btnShipping addTarget:self action:@selector(selectShippingType:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 13, 100, 24)];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textAlignment = NSTextAlignmentLeft;
        lblTitle.font = [UIFont systemFontOfSize:16];
        lblTitle.text = @"配送方式";
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(146, 13, 160, 24)];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.textAlignment = NSTextAlignmentRight;
        lblName.font = [UIFont systemFontOfSize:16];
        //lblName.text = @"顺丰速运货到付款";
        
        if (hasShipping == YES)
        {
            lblName.text = [[seller.shipping objectAtIndex:shippingIndex] dt_name];
        }
        else
        {
            lblName.text = @"";
        }
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, kCellFooterHeight-1, 320, 1)];
        viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)220/255 green:(CGFloat)220/255 blue:(CGFloat)223/255 alpha:1];
        
        [view addSubview:btnShipping];
        [view addSubview:lblTitle];
        [view addSubview:lblName];
        [view addSubview:viewLine];
        
        [viewAll addSubview:view];
        [viewAll addSubview:self.footview];
        
        return viewAll;
    }
    
    /*********************************************************************/
    
    CartResponseItemModel *seller = [self.arrayCart objectAtIndex:section];
    int shippingIndex = 0;
    BOOL hasShipping = NO;
    if (seller.shipping != nil && seller.shipping.count > 0)
    {
        hasShipping = YES;
        for (int i = 0; i < seller.shipping.count; i++)
        {
            // 找到选中的配送方式
            CartResponseShippingModel *shipping = [seller.shipping objectAtIndex:i];
            if ([shipping.choosed isEqualToString:@"true"] == YES)
            {
                shippingIndex = i;
                break;
            }
        }
    }
    else
    {
       //
    }
    
    UIView *viewAll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellFooterHeight + 10)];
    viewAll.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellFooterHeight)];
    view.tag = section;
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnShipping = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShipping.frame = CGRectMake(0, 0, 320, 50);
    btnShipping.tag = section;
    [btnShipping setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg_press"] forState:UIControlStateHighlighted];
    [btnShipping setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg"] forState:UIControlStateNormal];
    [btnShipping addTarget:self action:@selector(selectShippingType:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 13, 100, 24)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.font = [UIFont systemFontOfSize:16];
    lblTitle.text = @"配送方式";
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(146, 13, 160, 24)];
    lblName.backgroundColor = [UIColor clearColor];
    lblName.textAlignment = NSTextAlignmentRight;
    lblName.font = [UIFont systemFontOfSize:16];
    //lblName.text = @"顺丰速运货到付款";
    
    if (hasShipping == YES)
    {
        lblName.text = [[seller.shipping objectAtIndex:shippingIndex] dt_name];
    }
    else
    {
        lblName.text = @"";
    }
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, kCellFooterHeight-1, 320, 1)];
    viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)220/255 green:(CGFloat)220/255 blue:(CGFloat)223/255 alpha:1];
    
    [view addSubview:btnShipping];
    [view addSubview:lblTitle];
    [view addSubview:lblName];
    [view addSubview:viewLine];
    
    [viewAll addSubview:view];
    
    return viewAll;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark - AddressViewDelegate
// 选择地址
- (void)selectAddress
{
    [self.footview hideKeyBoard];
    
    // 先判断当前用户有无地址
    // 若无地址,则直接跳转到添加地址界面
    CartResponseAddressModel *address = self.cartSubmitRes.def_arr_addr;
    if (address == nil)
    {
        EditAddrViewController *addAddrVC = [[EditAddrViewController alloc] initWithNibName:@"EditAddrViewController" bundle:nil];
        addAddrVC.curAddrInfo = nil;    // 添加
        [self.navigationController pushViewController:addAddrVC animated:YES];
        return;
    }
    
    // 若有地址,则直接跳转到地址列表界面
    AddressSelectViewController *addressVC = [[AddressSelectViewController alloc] initWithNibName:@"AddressSelectViewController" bundle:nil];
    addressVC.arrayData = (NSArray<CartResponseAddressModel> *)self.cartSubmitRes.addrlist;
    addressVC.cartSubmitVC = self;
    [self.navigationController pushViewController:addressVC animated:YES];
}

//- (void)settingDefaultAddress
//{
//    for (int i = 0; i < self.cartSubmitRes.addrlist.count; i++)
//    {
//        CartResponseAddressModel *addr = [self.cartSubmitRes.addrlist objectAtIndex:i];
//        if ([addr.choosed isEqualToString:@"true"] == YES)
//        {
//            NSLog(@"setting default address:%@", addr.address);
//            self.cartSubmitRes.def_arr_addr = addr;
//            NSLog(@"final address:%@", self.cartSubmitRes.def_arr_addr.address);
//        }
//    }
//}


#pragma mark - PayAndMemoViewDelegate
// 选择支付方式
- (void)selectPayment
{
    [self.footview hideKeyBoard];
    
    PaymentViewController *paymentVC = [[PaymentViewController alloc] initWithNibName:@"PaymentViewController" bundle:nil];
    paymentVC.arrayData = (NSArray<CartResponsePaymentModel> *)self.cartSubmitRes.payment;
    paymentVC.cartSubmitVC = self;
    [self.navigationController pushViewController:paymentVC animated:YES];
}

- (void)saveMemoContent
{
    // 保存当前备注信息
    self.strMemo = self.footview.txtviewMemo.text;
}


#pragma mark - SelectAction
// 选择配送方式...<与当前商家有关>
- (void)selectShippingType:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    CartResponseItemModel *seller = [self.arrayCart objectAtIndex:tag];
    if (seller.shipping == nil || seller.shipping.count <= 1)
    {
        [self toast:@"当前商户暂无其它配送方式"];
    }
    else
    {
        [self.footview hideKeyBoard];
        
        ShippingSelectViewController *shippingVC = [[ShippingSelectViewController alloc] initWithNibName:@"ShippingSelectViewController" bundle:nil];
        shippingVC.arrayData = (NSArray<CartResponseShippingModel> *)seller.shipping;
        shippingVC.sellerIndex = tag;
        [self.navigationController pushViewController:shippingVC animated:YES];
    }
}


#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillShow");
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height; // 获取键盘高度
    //NSLog(@"<keyboardHeight:%f>",keyboardHeight);
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;   // 键盘动画时间
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat scrollHeight = _viewRect.size.height - keyboardHeight - 20;
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        CGRect myRect = _viewRect;
        myRect.size.height = scrollHeight;
        self.tableview.frame = myRect;
    } completion:^(BOOL finished) {
        // tableview滑到最下面
        [self.tableview setContentOffset:CGPointMake(0, -(scrollHeight-self.tableview.contentSize.height))];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillHide");
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        //self.tableview.frame = _viewRect;
        CGRect rect = CGRectMake(0, 0, 320, kScreenHeight - 64 - 44);
        self.tableview.frame = rect;
    } completion:^(BOOL finished) {
        //
    }];
    
}




@end
