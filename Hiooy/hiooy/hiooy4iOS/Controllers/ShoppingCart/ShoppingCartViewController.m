//
//  ShoppingCartViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "LoginViewController.h"
#import "CartSubmitRequestModel.h"
#import "CartResponseModel.h"
#import "CartSubmitViewController.h"
#import "ProductModel.h"
#import "ProductDetailViewController.h"

@interface ShoppingCartViewController ()
@property (nonatomic, assign) CGRect viewRect;
@property (nonatomic, strong) NSIndexPath *indexpathActive;
@end


@implementation ShoppingCartViewController

#define kCellHeight 102
#define kCellHeaderHeight 42
#define kCellFooterHeight 46

#define kSectionAll 100
#define kSectionEdit 200

#define kFooterTag 1000


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
    
    /*
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
    */
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
    
    self.viewBottom.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
 
    self.tableviewCart.backgroundColor = [UIColor clearColor];
    self.tableviewCart.backgroundView = nil;
    self.tableviewCart.showsVerticalScrollIndicator = NO;
    
    self.viewNoData.hidden = YES;
    self.viewNoData.backgroundColor = [UIColor clearColor];
    
    [self.btnTotal setImage:[UIImage imageNamed:@"radioUnselect"] forState:UIControlStateNormal];
    [self.btnTotal setImage:[UIImage imageNamed:@"radioSelect"] forState:UIControlStateSelected];
    self.btnTotal.selected = NO;
    
    [self.btnPay setBackgroundColor:[UIColor colorWithRed:(CGFloat)146/255 green:(CGFloat)0/255 blue:(CGFloat)0/255 alpha:1]];
    [self.btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    UIImage *img = [UIImage imageNamed:@"btn_red"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnJump setBackgroundImage:img forState:UIControlStateNormal];
    self.viewNoData.hidden = YES;
    
    self.arrayFooter = [[NSMutableArray alloc] init];
    
    _viewRect = self.tableviewCart.frame;
    
    [self requestShoppingCartList];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"购物车";
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showUserLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginVC.completionBlock = ^(BOOL isSucceed, NSString *message) {
        if (isSucceed) {
            [self.tabBarController setSelectedIndex:self.view.tag];
            self.navigationItem.title = @"购物车";
        }
    };
    NavigationViewController *navVC = [[NavigationViewController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navVC animated:YES completion:^{
        //
    }];
}

- (void)requestShoppingCartList
{
    //[self startLoading:kLoading];
    
    [InterfaceManager getProductListInShoppingCart:^(BOOL isSucceed, NSString *message, id data) {
        //[self stopLoading];
        if (isSucceed) {
            NSLog(@"获取购物车列表成功");
            id myData = [(NSDictionary *)data objectForKey:@"data"];
            if ([myData isKindOfClass:[NSString class]] == YES || [myData isKindOfClass:[NSArray class]] == YES)
            {   // data对应的值不为字典(为字符串或数组)时,表示购物车为空
                NSLog(@"购物车为空");
                self.cart = nil;
                self.arrayCart = nil;
                self.viewNoData.hidden = NO;
                self.viewBottom.hidden = YES;
                [self.tableviewCart reloadData];
                return;
            }
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
            NSError *error = nil;
            NSLog(@"dataDic:%@", dataDic);
            self.cart = [[CartListModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败");
                return;
            }
            else
            {
                self.arrayCart = (NSMutableArray *)self.cart.seller;
                if (self.arrayCart.count == 0)
                {
                    // 无收藏的商品
                    //self.tableviewCart.hidden = YES;
                    self.viewBottom.hidden = YES;
                    self.viewNoData.hidden = NO;
                }
                else
                {
                    /*
                    {
                        "status": "success",
                        "msg": "",
                        "data": {
                            "total": "0.00",
                            "seller": [
                                       {
                                           "goods": [],
                                           "seller_info": {
                                               "seller_id": "0",
                                               "seller_name": "",
                                               "selected": "false"
                                           },
                                           "items_quantity": 0,
                                           "subtotal": 0
                                       }
                                       ],
                            "promotion": [
                                          {
                                              "name": "满1000免运费",
                                              "discount_amount": "0.00"
                                          }
                                          ]
                        }
                    }
                    */
                    
                    BOOL hasGoods = YES;
                    // 当只有一个seller时，需判断当前seller下是否有商品。若无商品,则说明当前seller无效
                    if (self.arrayCart.count == 1)
                    {
                        CartSellerGoodsModel *seller = [self.cart.seller objectAtIndex:0];
                        if (seller.goods.count == 0)
                        {
                            hasGoods = NO;
                        }
                    }
                    
                    if (hasGoods == NO)
                    {
                        self.viewBottom.hidden = YES;
                        self.viewNoData.hidden = NO;
                        self.arrayCart = nil;
                    }
                    else
                    {
                        // 有收藏的商品
                        //self.tableviewCart.hidden = NO;
                        self.viewBottom.hidden = NO;
                        self.viewNoData.hidden = YES;
                        [self checkAllProductsSelectedStatus];
                    }
                }
                [self createAndShowData];
            }
        }else {
            NSLog(@"获取购物车列表失败:%@", message);
            self.cart = nil;
            self.arrayCart = nil;
            //self.viewNoData.hidden = NO;
            self.viewBottom.hidden = YES;
            [self.tableviewCart reloadData];
        }
    }];
    
}

- (void)createAndShowData
{
    NSLog(@"显示购物车中商品");
    //
    [self.arrayFooter removeAllObjects];
    for (int i = 0; i < self.arrayCart.count; i++)
    {
        UIView *viewAll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellFooterHeight + 10)];
        viewAll.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
        [self.arrayFooter addObject:viewAll];
    }
    [self.tableviewCart reloadData];
}

- (IBAction)jumpToMainpage:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.tabVC.selectedIndex = 0;
}

// 判断当前商品是否为全选中
- (void)checkAllProductsSelectedStatus
{
    // 先获取每个商家的全部商品选中状态
    for (int i = 0; i < self.arrayCart.count; i++)
    {
        // 分析当前商家
        CartSellerGoodsModel *seller = [self.arrayCart objectAtIndex:i];
        int count = 0;
        for (int j = 0; j < seller.goods.count; j++)
        {
            CartGoodsModel *goods = [seller.goods objectAtIndex:j];
            if ([goods.selected isEqualToString:@"true"] == YES)
            {
                count++;
            }
        }
        if (count == seller.goods.count)
        {   // 全选
            seller.seller_info.selectAll = @"true";
        }
        else
        {
            seller.seller_info.selectAll = @"false";
        }
    }
    // 然后再整体判断所有商家的选中状态
    int sellerCount = 0;
    for (int i = 0; i < self.arrayCart.count; i++)
    {
        CartSellerGoodsModel *seller = [self.arrayCart objectAtIndex:i];
        if ([seller.seller_info.selectAll isEqualToString:@"true"])
        {
            sellerCount++;
        }
    }
    if (sellerCount == self.arrayCart.count)
    {
        // 所有商品全选
        self.btnTotal.selected = YES;
        self.btnPay.enabled = YES;
    }
    else
    {
        self.btnTotal.selected = NO;
        self.btnPay.enabled = NO;
    }
    
    self.lblTotal.text = [NSString stringWithFormat:@"%.2f 元", [self.cart.total floatValue]];
    
//    // 增加优惠金额显示
//    NSString *strDiscount = @"0.00 元";
//    if (self.cart.promotion != nil && self.cart.promotion.count > 0)
//    {
//        // 取第0个优惠元素...<只有一个>
//        CartPromotionModel *promotion = [self.cart.promotion objectAtIndex:0];
//        if (promotion.discount_amount != nil)
//        {
//            float discount = [promotion.discount_amount floatValue];
//            strDiscount = [NSString stringWithFormat:@"%.2f 元", discount];
//        }
//    }
//    self.lblDiscount.text = strDiscount;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:kHideKeyboardInCart object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideKeyboardInCart object:nil];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (CGFloat)kCellHeaderHeight + 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CartSellerGoodsModel *allGoodsInSeller = [self.arrayCart objectAtIndex:section];
    
    UIView *viewAll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellHeaderHeight + 10)];
    viewAll.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, kCellHeaderHeight)];
    view.tag = section;
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)220/255 green:(CGFloat)220/255 blue:(CGFloat)223/255 alpha:1];
    
    UIButton *btnAll = [[UIButton alloc] initWithFrame:CGRectMake(3, 2, 38, 38)];
    btnAll.tag = kSectionAll + section;
    [btnAll setImage:[UIImage imageNamed:@"radioUnselect"] forState:UIControlStateNormal];
    [btnAll setImage:[UIImage imageNamed:@"radioSelect"] forState:UIControlStateSelected];
    //[btnAll addTarget:self action:@selector(sectionHeaderButtonTouched:withTag:) forControlEvents:UIControlEventTouchUpInside];
    [btnAll addTarget:self action:@selector(sectionHeaderSelectButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    // false表示均未被选中,true表示至少一件被选中
    if ([allGoodsInSeller.seller_info.selected isEqualToString:@"false"] == YES)
    {
        // 所有商品均未被选中
        btnAll.selected = NO;
        allGoodsInSeller.seller_info.selectAll = @"false";
    }
    else
    {
        // 至少有一样商品被选中
        // 判断当前商家下的所有商品是否全被选中
        BOOL selectAll = YES;
        for (int i = 0; i < allGoodsInSeller.goods.count; i++)
        {
            CartGoodsModel *goods = [allGoodsInSeller.goods objectAtIndex:i];
            if ([goods.selected isEqualToString:@"false"] == YES)
            {
                selectAll = NO;
                break;
            }
        }   // for
        if (selectAll == YES)
        {
            btnAll.selected = YES;
            allGoodsInSeller.seller_info.selectAll = @"true";
        }
        else
        {
            btnAll.selected = NO;
            allGoodsInSeller.seller_info.selectAll = @"false";
        }
    }
    
    UILabel *lblStore = [[UILabel alloc] initWithFrame:CGRectMake(44, 6, 189, 30)];
    lblStore.textAlignment = NSTextAlignmentLeft;
    lblStore.font = [UIFont systemFontOfSize:14];
    //lblStore.text = @"海印直营";
    lblStore.text = allGoodsInSeller.seller_info.seller_name;
    
    UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(254, 7, 58, 30)];
    btnEdit.tag = kSectionEdit + section;
    [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [btnEdit setTitle:@"完成" forState:UIControlStateSelected];
    [btnEdit setTitleColor:[UIColor colorWithRed:(CGFloat)146/255 green:(CGFloat)0/255 blue:0.0 alpha:1] forState:UIControlStateNormal];
    [btnEdit.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [btnEdit setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [btnEdit setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    //[btnEdit addTarget:self action:@selector(sectionHeaderButtonTouched:withTag:) forControlEvents:UIControlEventTouchUpInside];
    [btnEdit addTarget:self action:@selector(sectionHeaderDeleteButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    if (allGoodsInSeller.isEditting == nil || [allGoodsInSeller.isEditting isEqualToString:@""] == YES)
    {
        btnEdit.selected = NO;
    }
    else
    {
        if ([allGoodsInSeller.isEditting isEqualToString:@"YES"] == YES)
        {
            btnEdit.selected = YES;
        }
        else
        {
            btnEdit.selected = NO;
        }
    }
    
    [view addSubview:viewLine];
    [view addSubview:btnAll];
    [view addSubview:lblStore];
    [view addSubview:btnEdit];
    
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
    CartSellerGoodsModel *allGoodsInSeller = [self.arrayCart objectAtIndex:section];
    return allGoodsInSeller.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cartCell";
    CartCell *cell = (CartCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [CartCell cellFromNib];
    }
    cell.delegate = self;
    
    // Configure the cell...

    CartSellerGoodsModel *allGoodsInSeller = [self.arrayCart objectAtIndex:indexPath.section];
    CartGoodsModel *goods = [allGoodsInSeller.goods objectAtIndex:indexPath.row];
    [cell settingCell:goods withStatus:allGoodsInSeller.isEditting];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (CGFloat)kCellFooterHeight + 10;
    //return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CartSellerGoodsModel *allGoodsInSeller = [self.arrayCart objectAtIndex:section];
    
//    UIView *viewAll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellFooterHeight + 10)];
//    viewAll.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
    
    UIView *viewAll = [self.arrayFooter objectAtIndex:section];
    NSArray *arr = [viewAll subviews];
    for (UIView *view in arr)
    {
        [view removeFromSuperview];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCellFooterHeight)];
    view.tag = section;
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblNumberT = [[UILabel alloc] initWithFrame:CGRectMake(147, 2, 62, 22)];
    lblNumberT.textAlignment = NSTextAlignmentRight;
    lblNumberT.font = [UIFont systemFontOfSize:14];
    lblNumberT.text = @"数量:";
    
    UILabel *lblTotalT = [[UILabel alloc] initWithFrame:CGRectMake(147, 22, 62, 22)];
    lblTotalT.textAlignment = NSTextAlignmentRight;
    lblTotalT.font = [UIFont systemFontOfSize:14];
    lblTotalT.text = @"合计:";
    
    UILabel *lblNumberC = [[UILabel alloc] initWithFrame:CGRectMake(211, 2, 102, 22)];
    lblNumberC.tag = kFooterTag;
    lblNumberC.textAlignment = NSTextAlignmentRight;
    lblNumberC.font = [UIFont systemFontOfSize:14];
    //lblNumberC.text = @"12";
    //NSLog(@"product number of seller: %d", [allGoodsInSeller.items_quantity intValue]);
    lblNumberC.text = allGoodsInSeller.items_quantity;
    
    UILabel *lblTotalC = [[UILabel alloc] initWithFrame:CGRectMake(211, 22, 102, 22)];
    lblTotalC.tag = kFooterTag+1;
    lblTotalC.textAlignment = NSTextAlignmentRight;
    lblTotalC.font = [UIFont systemFontOfSize:14];
    lblTotalC.textColor = [UIColor colorWithRed:(CGFloat)146/255 green:(CGFloat)0/255 blue:0.0 alpha:1];
    //lblTotalC.text = @"5863902.00 元";
    lblTotalC.text = [NSString stringWithFormat:@"%.2f 元", [allGoodsInSeller.subtotal floatValue]];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, kCellFooterHeight-1, 320, 1)];
    viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)220/255 green:(CGFloat)220/255 blue:(CGFloat)223/255 alpha:1];
    
    [view addSubview:lblNumberT];
    [view addSubview:lblTotalT];
    [view addSubview:lblNumberC];
    [view addSubview:lblTotalC];
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
    
    // 进入商品详情界面
    CartSellerGoodsModel *allGoodsInSeller = [self.arrayCart objectAtIndex:indexPath.section];
    CartGoodsModel *goods = [allGoodsInSeller.goods objectAtIndex:indexPath.row];
    ProductModel *item = [[ProductModel alloc] init];
    item.goods_id = goods.goods_id; // 只需要传goods_id就行
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    detailVC.productModel = item;
    detailVC.fromCart = YES;
    [self.tabBarController.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - CartCellDelegate
// 点击cell上的select btn触发的操作
- (void)cartSelectButtonTouched:(id)cell withButtonTag:(int)tag
{
    CartCell *cartCell = (CartCell *)cell;
    NSIndexPath *indexPath = [self.tableviewCart indexPathForCell:cartCell];
    CartSellerGoodsModel *allGoodsInSeller = [self.arrayCart objectAtIndex:indexPath.section];  // 商家
    CartGoodsModel *goods = [allGoodsInSeller.goods objectAtIndex:indexPath.row];               // 指定商品
    if ([goods.selected isEqualToString:@"true"])
    {
        goods.selected = @"false";
        cartCell.btnSelect.selected = NO;
    }
    else
    {
        goods.selected = @"true";
        cartCell.btnSelect.selected = YES;
    }
    // 判断当前商品所属的商家下，是否所有商品均被选，或均未被选
    UIView *headerView = [self.tableviewCart headerViewForSection:indexPath.section];
    UIButton *btn = (UIButton *)[headerView viewWithTag:kSectionAll];
    //BOOL selectAll = YES;
    int selectCount = 0;    // 已选的个数
    for (int i = 0; i < allGoodsInSeller.goods.count; i++)
    {
        CartGoodsModel *goods = [allGoodsInSeller.goods objectAtIndex:i];
        if ([goods.selected isEqualToString:@"false"] == YES)
        {
            //selectAll = NO;
            //break;
        }
        else
        {
            selectCount++;
        }
    }   // for
    if (selectCount == allGoodsInSeller.goods.count)
    {
        // 全选
        btn.selected = YES;
        allGoodsInSeller.seller_info.selected = @"true";
        allGoodsInSeller.seller_info.selectAll = @"true";
    }
    else if (selectCount == 0)
    {
        // 全未选
        btn.selected = NO;
        allGoodsInSeller.seller_info.selected = @"false";
        allGoodsInSeller.seller_info.selectAll = @"false";
    }
    else
    {
        btn.selected = NO;
        allGoodsInSeller.seller_info.selected = @"true";
        allGoodsInSeller.seller_info.selectAll = @"false";
    }
    // 当前商家下所有已选商品的价格和
    if ([goods.selected isEqualToString:@"true"])
    {
        // 加价
        float price = [goods.subtotal floatValue];  // 加的价格
        float subtotal = [allGoodsInSeller.subtotal floatValue] + price;
        allGoodsInSeller.subtotal = [NSString stringWithFormat:@"%.2f", subtotal];
        // 加数量
        int goodsCount = [goods.quantity intValue];
        int quantity = [allGoodsInSeller.items_quantity intValue] + goodsCount;
        allGoodsInSeller.items_quantity = [NSString stringWithFormat:@"%d", quantity];
        
        float totalPrice = [self.cart.total floatValue];
        totalPrice += price;
        self.cart.total = [NSString stringWithFormat:@"%.2f", totalPrice];
        self.lblTotal.text = [NSString stringWithFormat:@"%.2f 元", [self.cart.total floatValue]];
        if (totalPrice > 0.00)
        {
            self.btnPay.enabled = YES;
        }
    }
    else
    {
        // 减价
        float price = [goods.subtotal floatValue];
        float subtotal = [allGoodsInSeller.subtotal floatValue] - price;
        allGoodsInSeller.subtotal = [NSString stringWithFormat:@"%.2f", subtotal];
        // 减数量
        int goodsCount = [goods.quantity intValue];
        int quantity = [allGoodsInSeller.items_quantity intValue] - goodsCount;
        allGoodsInSeller.items_quantity = [NSString stringWithFormat:@"%d", quantity];
        
        float totalPrice = [self.cart.total floatValue];
        totalPrice -= price;
        self.cart.total = [NSString stringWithFormat:@"%.2f", totalPrice];
        self.lblTotal.text = [NSString stringWithFormat:@"%.2f 元", [self.cart.total floatValue]];
        // 只有在减价(即不选商品时),才会出现此种情况,结算按钮不可用
        if (totalPrice == 0.00)
        {
            self.btnPay.enabled = NO;
        }
    }
    [self.tableviewCart reloadData];
    
    // 判断界面下方总的”全选“按钮状态
    int sellerCount = 0;
    for (int i = 0; i < self.arrayCart.count; i++)
    {
        CartSellerGoodsModel *seller = [self.arrayCart objectAtIndex:i];
        if ([seller.seller_info.selectAll isEqualToString:@"true"])
        {
            sellerCount++;
        }
    }
    if (sellerCount == self.arrayCart.count)
    {
        // 所有商品全选
        self.btnTotal.selected = YES;
    }
    else
    {
        self.btnTotal.selected = NO;
    }
}

// 点击cell上的delete btn触发的操作
- (void)cartDeleteButtonTouched:(id)cell withButtonTag:(int)tag
{
    CartCell *cartCell = (CartCell *)cell;
    NSIndexPath *indexPath = [self.tableviewCart indexPathForCell:cartCell];
    CartSellerGoodsModel *allGoodsInSeller = [self.arrayCart objectAtIndex:indexPath.section];  // 商家
    CartGoodsModel *goods = [allGoodsInSeller.goods objectAtIndex:indexPath.row];               // 指定商品
    NSLog(@"section:%d, row:%d", indexPath.section, indexPath.row);
    
    // 获取商品id组合
    NSString *productStr = [NSString stringWithFormat:@"goods_%@_%@", goods.goods_id, goods.product_id];
    NSMutableArray *productArr = [[NSMutableArray alloc] initWithObjects:productStr, nil];
    // 删除请求
    [InterfaceManager deleteProductInCart:productArr completion:^(BOOL isSucceed, NSString *message, id data) {
        if (isSucceed) {
            NSLog(@"删除商品成功");
            /*
             {"status":"success","msg":"删除成功!","data":""}
             */
            [self toast:(NSString *)[data objectForKey:@"msg"]];
            // 刷新界面
            NSMutableArray *newGoods = [NSMutableArray arrayWithArray:allGoodsInSeller.goods];
            [newGoods removeObjectAtIndex:indexPath.row];   // 数据源中删除指定索引处的元素
            if (newGoods.count == 0)
            {
                // 当前商户也需要一起删除
                [self.arrayCart removeObjectAtIndex:indexPath.section];
                [self.arrayFooter removeObjectAtIndex:indexPath.section];
            }
            else
            {
                // 当前商户下还有其它商品
                allGoodsInSeller.goods = (NSArray<CartGoodsModel> *)newGoods;
                
                // 更新当前指定商品所属的商户数据
                [self calculateSeller:allGoodsInSeller];
                
                // 更新footer
                UIView *view = [self.arrayFooter objectAtIndex:indexPath.section];
                UIView *footerview = [view viewWithTag:indexPath.section];
                if (footerview == nil)
                {
                    NSLog(@"footerview为空...<%d-%d>", indexPath.section, indexPath.row);
                    return;
                }
                UILabel *lblNum = (UILabel *)[footerview viewWithTag:kFooterTag];
                lblNum.text = allGoodsInSeller.items_quantity;
                UILabel *lblPrice = (UILabel *)[footerview viewWithTag:kFooterTag+1];
                lblPrice.text = allGoodsInSeller.subtotal;
            }
            self.cart.seller = (NSArray<CartSellerGoodsModel> *)self.arrayCart;
            if (self.arrayCart.count == 0)
            {
                // 无商户时,即购物车中无商品...
                self.viewBottom.hidden = YES;
                self.viewNoData.hidden = NO;
            }
            [self calculateTotalPrice]; // 计算总价
            [self.tableviewCart reloadData];
        }else {
            NSLog(@"删除商品失败:%@", message);
            [self toast:@"删除商品失败"];
        }
    }];
}

// textfield激活
- (void)cartCellBeginEdit:(id)cell
{
    NSLog(@">>>cartCellBeginEdit...<<<");
    self.indexpathActive = [self.tableviewCart indexPathForCell:(CartCell *)cell];
    NSLog(@"current cell is active:<section=%d, row=%d>", self.indexpathActive.section, self.indexpathActive.row);
}

// textfield未激活
- (void)cartCellEndEdit:(id)cell
{
    NSLog(@"...cartCellEndEdit...~!@");
    CartCell *cartCell = (CartCell *)cell;
    NSIndexPath *indexP = [self.tableviewCart indexPathForCell:cartCell];
    NSLog(@"current cell is active:<section=%d, row=%d>", indexP.section, indexP.row);
    NSString *numberStr = cartCell.txtfieldNumber.text;
    int number = [numberStr integerValue];
    if (number <= 0)
    {
        cartCell.txtfieldNumber.text = cartCell.lblNumber.text;
    }
    else
    {
        cartCell.lblNumber.text = [NSString stringWithFormat:@"%d", number];
        cartCell.txtfieldNumber.text = cartCell.lblNumber.text;
        // 更新数据源
        CartSellerGoodsModel *allGoodsInSeller = [self.arrayCart objectAtIndex:indexP.section];  // 商家
        CartGoodsModel *goods = [allGoodsInSeller.goods objectAtIndex:indexP.row];               // 指定商品
        // 1. 更新当前指定商品数据
        goods.quantity = cartCell.txtfieldNumber.text;  // 更新当前商品的数量
        CGFloat total = [goods.price floatValue] * number;  // 当前商品的总价
        goods.subtotal = [NSString stringWithFormat:@"%.2f", total];    // 更新当前商品的总价
        // 2.更新当前指定商品所属的商户数据
        [self calculateSeller:allGoodsInSeller];
        NSLog(@"<seller>...number:%@, price:%.2f", allGoodsInSeller.items_quantity, [allGoodsInSeller.subtotal floatValue]);
        self.cart.seller = (NSArray<CartSellerGoodsModel> *)self.arrayCart;
        // 3.计算总价
        [self calculateTotalPrice];
//        [self.tableviewCart reloadData];
//        return;
        
        // 4.更新footerview上的数据显示
//        UIView *footerview = [self.tableviewCart footerViewForSection:indexP.section];
        UIView *view = [self.arrayFooter objectAtIndex:indexP.section];
        UIView *footerview = [view viewWithTag:indexP.section];
        if (footerview == nil)
        {
            NSLog(@"footerview为空...<%d-%d>", indexP.section, indexP.row);
            return;
        }
        UILabel *lblNum = (UILabel *)[footerview viewWithTag:kFooterTag];
        lblNum.text = allGoodsInSeller.items_quantity;
        UILabel *lblPrice = (UILabel *)[footerview viewWithTag:kFooterTag+1];
        lblPrice.text = allGoodsInSeller.subtotal;
    }
}

// 更新当前seller信息
- (void)calculateSeller:(CartSellerGoodsModel *)seller
{
    int number = 0;
    float price = 0.0;
    for (int i = 0; i < seller.goods.count; i++)
    {
        CartGoodsModel *goods = [seller.goods objectAtIndex:i];
        if ([goods.selected isEqualToString:@"true"] == YES)
        {
            int num = [goods.quantity intValue];
            CGFloat pri = [goods.price floatValue];
            number += num;
            price += (pri*num);
        }
    }
    seller.items_quantity = [NSString stringWithFormat:@"%d", number];
    seller.subtotal = [NSString stringWithFormat:@"%.2f", price];
}

// 计算总价
- (void)calculateTotalPrice
{
    float totalPrice = 0.0;
    for (int i = 0; i < self.arrayCart.count; i++)
    {
        CartSellerGoodsModel *seller = [self.arrayCart objectAtIndex:i];  // 商家
        if ([seller.seller_info.selected isEqualToString:@"true"] == YES)
        {
            totalPrice += [seller.subtotal floatValue];
        }
    }
    self.cart.total = [NSString stringWithFormat:@"%.2f", totalPrice];
    self.lblTotal.text = self.cart.total;
}


#pragma mark - SectionAction
// 点击section header上的btn触发的操作
// 不使用。。。
- (void)sectionHeaderButtonTouched:(int)section withTag:(int)tag
{
    NSLog(@"section:%d, tag:%d", section, tag);
    //
}

// 全选、全不选
- (void)sectionHeaderSelectButtonTouched:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = (int)(btn.tag) - kSectionAll;
    NSLog(@"btn tag:%d", tag);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:tag];
    CartSellerGoodsModel *allGoodsInSeller = [self.arrayCart objectAtIndex:indexPath.section];  // 商家
    //CartGoodsModel *goods = [allGoodsInSeller.goods objectAtIndex:indexPath.row];               // 指定商品
    // 动态改变当前btn的选中状态
    if (btn.selected == YES)
    {
        // 全不选
        btn.selected = NO;
        allGoodsInSeller.seller_info.selected = @"false";
        allGoodsInSeller.seller_info.selectAll = @"false";
    }
    else
    {
        // 全选
        btn.selected = YES;
        allGoodsInSeller.seller_info.selected = @"true";
        allGoodsInSeller.seller_info.selectAll = @"true";
    }
    // 动态改变当前seller下所有商品的选中状态
    for (int i = 0; i < allGoodsInSeller.goods.count; i++)
    {
        CartGoodsModel *goods = [allGoodsInSeller.goods objectAtIndex:i];
        goods.selected = allGoodsInSeller.seller_info.selectAll;
    }
    // 价格
    if (btn.selected == YES)
    {
        // 加价
        // 减去之前的价格和数量，重新加上新的
        CGFloat priceBefore = [allGoodsInSeller.subtotal floatValue];
        //int countBefore = [allGoodsInSeller.items_quantity intValue];
        CGFloat priceNow = 0.0; // 当前总价<针对当前商家>
        int countNow = 0;       // 当前总数量<针对当前商家>
        int pCount = allGoodsInSeller.goods.count;
        for (int i = 0; i < pCount; i++)
        {
            CartGoodsModel *goods = [allGoodsInSeller.goods objectAtIndex:i];
            priceNow += [goods.subtotal floatValue];    // count * price
            countNow += [goods.quantity intValue];
        }
        // 直接更新当前商家状态
        allGoodsInSeller.items_quantity = [NSString stringWithFormat:@"%d", countNow];
        allGoodsInSeller.subtotal = [NSString stringWithFormat:@"%.2f", priceNow];
        // 更新总价
        CGFloat totalPrice = [self.cart.total floatValue] - priceBefore + priceNow;
        self.cart.total = [NSString stringWithFormat:@"%.2f", totalPrice];
        self.lblTotal.text = [NSString stringWithFormat:@"%.2f 元", totalPrice];
        if (totalPrice > 0.00)
        {
            self.btnPay.enabled = YES;
        }
    }
    else
    {
        // 减价
        // 减去之前的价格和数量
        CGFloat priceBefore = [allGoodsInSeller.subtotal floatValue];
        // 直接更新当前商家状态
        allGoodsInSeller.items_quantity = @"0";
        allGoodsInSeller.subtotal = @"0.00 元";
        // 更新总价
        CGFloat totalPrice = [self.cart.total floatValue] - priceBefore;
        self.cart.total = [NSString stringWithFormat:@"%.2f", totalPrice];
        self.lblTotal.text = [NSString stringWithFormat:@"%.2f 元", totalPrice];
        if (totalPrice == 0.00)
        {
            self.btnPay.enabled = NO;
        }
    }
    [self.tableviewCart reloadData];
    
    // 判断界面下方总的”全选“按钮状态
    int sellerCount = 0;
    for (int i = 0; i < self.arrayCart.count; i++)
    {
        CartSellerGoodsModel *seller = [self.arrayCart objectAtIndex:i];
        if ([seller.seller_info.selectAll isEqualToString:@"true"])
        {
            sellerCount++;
        }
    }
    if (sellerCount == self.arrayCart.count)
    {
        // 所有商品全选
        self.btnTotal.selected = YES;
    }
    else
    {
        self.btnTotal.selected = NO;
    }
}

// 编辑
- (void)sectionHeaderDeleteButtonTouched:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = (int)(btn.tag) - kSectionEdit;
    NSLog(@"btn tag:%d", tag);
    CartSellerGoodsModel *allGoodsInSeller = [self.arrayCart objectAtIndex:tag];
    if (btn.selected == YES)
    {
        btn.selected = NO;
        allGoodsInSeller.isEditting = @"NO";
    }
    else
    {
        btn.selected = YES;
        allGoodsInSeller.isEditting = @"YES";
    }
    [self.tableviewCart reloadData];
}


#pragma mark - BottomViewAction
// 全选
- (IBAction)selectedAllGoods
{
    if (self.btnTotal.selected == YES)
    {
        self.btnTotal.selected = NO;
        self.btnPay.enabled = NO;
        self.cart.total = @"0"; // 总价
        self.lblTotal.text = [NSString stringWithFormat:@"%.2f 元", [self.cart.total floatValue]];
        
        // 刷新
        for (int i = 0; i < self.arrayCart.count; i++)
        {
            CartSellerGoodsModel *seller = [self.arrayCart objectAtIndex:i];
            seller.seller_info.selected = @"false";
            seller.seller_info.selectAll = @"false";
            for (int i = 0; i < seller.goods.count; i++)
            {
                CartGoodsModel *goods = [seller.goods objectAtIndex:i];
                goods.selected = seller.seller_info.selectAll;
            }
            seller.items_quantity = @"0";
            seller.subtotal = @"0";
        }
        [self.tableviewCart reloadData];
    }
    else
    {
        CGFloat priceTotl = 0.0;    // 总价
        // 刷新
        for (int i = 0; i < self.arrayCart.count; i++)
        {
            CartSellerGoodsModel *seller = [self.arrayCart objectAtIndex:i];
            seller.seller_info.selected = @"true";
            seller.seller_info.selectAll = @"true";
            int count = 0;
            CGFloat price = 0.0;
            for (int i = 0; i < seller.goods.count; i++)
            {
                CartGoodsModel *goods = [seller.goods objectAtIndex:i];
                goods.selected = seller.seller_info.selectAll;
                count += [goods.quantity intValue];
                price += [goods.subtotal floatValue];
            }
            seller.items_quantity = [NSString stringWithFormat:@"%d", count];
            seller.subtotal = [NSString stringWithFormat:@"%.2f", price];
            priceTotl += price;
        }
        
        [self.tableviewCart reloadData];
        
        self.btnTotal.selected = YES;
        self.btnPay.enabled = YES;
        self.cart.total = [NSString stringWithFormat:@"%.2f", priceTotl]; // 总价
        self.lblTotal.text = [NSString stringWithFormat:@"%.2f 元", [self.cart.total floatValue]];
    }
}

// 提交购物车
- (IBAction)jumpToPay
{
    // 如果无商品被选中,则不可提交购物车
    float totalPrice = 0.0;
    for (int i = 0; i < self.arrayCart.count; i++)
    {
        CartSellerGoodsModel *seller = [self.arrayCart objectAtIndex:i];  // 商家
        if ([seller.seller_info.selected isEqualToString:@"true"] == YES)
        {
            totalPrice += [seller.subtotal floatValue];
        }
    }
    if (totalPrice == 0.0)
    {
        return;
    }
    
    // 需传递的参数实体
    CartSubmitRequestModel *submit = [[CartSubmitRequestModel alloc] init];
    submit.member_id = [[UserManager shareInstant] getMemberId];
    // 应该保存用户的默认地址id和支付方式id
    //submit.addr_id = @"";
    //submit.payment_app_id = @"";
    
    NSMutableArray *arraySeller = [[NSMutableArray alloc] init];    // 保存所有seller
    for (int i = 0; i < self.arrayCart.count; i++)
    {
        CartSellerGoodsModel *seller = [self.arrayCart objectAtIndex:i];  // 商家
        if ([seller.seller_info.selected isEqualToString:@"true"] == YES && [seller.items_quantity intValue] > 0)
        {   // 当前商家下有被选中的商品,才会进行后续处理
            CartSubmitSellerModel *sellerSubmit = [[CartSubmitSellerModel alloc] init];
            sellerSubmit.seller_id = seller.seller_info.seller_id;
            sellerSubmit.shipping_id = nil;
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
                    NSLog(@"当前goods<%@>未被选中...seller<%@>", goods.name, seller.seller_info.seller_name);
                }
            }   // for
            sellerSubmit.goods = (NSArray<CartSumbitGoodsModel> *)arrayGoods;
            [arraySeller addObject:sellerSubmit];
        }
        else
        {
            NSLog(@"当前seller<%@>下无选中商品", seller.seller_info.seller_name);
        }
    }   // for
    submit.seller = (NSArray<CartSubmitSellerModel> *)arraySeller;
    
    CartSubmitViewController *submitVC = [[CartSubmitViewController alloc] initWithNibName:@"CartSubmitViewController" bundle:nil];
    submitVC.cartSubmitReq = submit;
    submitVC.type = 1;  // 购物车购买
    //[submitVC requestCartSubmit];
    [self.tabBarController.navigationController pushViewController:submitVC animated:YES];
    
//    // 提交
//    [InterfaceManager submitShoppingCart:submit completion:^(BOOL isSucceed, NSString *message, id data) {
//        if (isSucceed) {
//            NSLog(@"提交购物车成功");
//            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
//            NSError *error = nil;
//            CartResponseModel *cartResponse = [[CartResponseModel alloc] initWithDictionary:dataDic error:&error];
//            if (error)
//            {
//                NSLog(@"json解析失败");
//            }
//            else
//            {
//                NSLog(@"seller count:%d, total:%@", cartResponse.aCart.count, cartResponse.total);
//            }
//        }else {
//            NSLog(@"提交购物车失败:%@", message);
//        }
//    }];
    
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
    
    CGFloat scrollHeight = _viewRect.size.height + 52 - keyboardHeight;
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        CGRect myRect = _viewRect;
        myRect.size.height = scrollHeight;
        self.tableviewCart.frame = myRect;
    } completion:^(BOOL finished) {
        CartCell *cell = (CartCell *)[self.tableviewCart cellForRowAtIndexPath:self.indexpathActive];
        [self.tableviewCart scrollRectToVisible:cell.frame animated:YES];
        // tableview滑到最下面
        //[self.tableviewCart setContentOffset:CGPointMake(0, -(scrollHeight-self.tableview.contentSize.height))];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillHide");
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        //self.tableviewCart.frame = _viewRect;
        CGRect rect = CGRectMake(0, 20, 320, kScreenHeight - 20 - 52 - 49);
        self.tableviewCart.frame = rect;
    } completion:^(BOOL finished) {
        //
    }];
    
}



@end
