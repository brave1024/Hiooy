//
//  ProductDetailViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ProductCommentViewController.h"
#import "ProductInfoViewController.h"
#import "AddCartRequestModel.h"
#import "LoginViewController.h"
#import "ProductBuyRequestModel.h"
#import "CartResponseModel.h"
#import "CartSubmitViewController.h"
#import "ProductTypeView.h"

@interface ProductDetailViewController ()
@property (nonatomic, strong) UIView *viewBlack;
@property int storeNumber;  // 当前用户选中规格的商品库存
@property int selectNumber; // 用户输入的商品数
@property BOOL changeNumber;    // 表示当前键盘弹出原因是因为用户修改商品数量
@property BOOL popviewIsShow;   // 规格选择视图是否弹出
@end

@implementation ProductDetailViewController

#define kTag 100
#define kButtonTag 1000
#define kSelectTag 200

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
    
    self.navigationItem.title = @"商品详情";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)241/255 green:(CGFloat)241/255 blue:(CGFloat)241/255 alpha:1];
    self.scrollProduct.backgroundColor = [UIColor clearColor];
    self.scrollPic.backgroundColor = [UIColor clearColor];
    
    self.scrollProduct.contentSize = CGSizeMake(320, 715);
    self.scrollProduct.tag = kTag;
    
    // 不使用pagecontrol
    //self.scrollPic.pagingEnabled = YES;
    //self.scrollPic.showsHorizontalScrollIndicator = NO;
    self.pageControl.hidden = YES;
    self.scrollPic.tag = kTag + 1;
    
    self.imgviewPic.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage *img = [UIImage imageNamed:@"btn_red"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnPay setBackgroundImage:img forState:UIControlStateNormal];
    [self.btnPay setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.btnPayS setBackgroundImage:img forState:UIControlStateNormal];
    [self.btnPayS setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    UIImage *imgY = [UIImage imageNamed:@"btn_yellow"];
    imgY = [imgY resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnCart setBackgroundImage:imgY forState:UIControlStateNormal];
    [self.btnCart setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.btnCartS setBackgroundImage:imgY forState:UIControlStateNormal];
    [self.btnCartS setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    UIImage *imgCell = [UIImage imageNamed:@"bg_cell"];
    imgCell = [imgCell resizableImageWithCapInsets:UIEdgeInsetsMake(6, 2, 6, 2)];
    self.imgviewBaseBG.image = imgCell;
    self.imgviewTypeBG.image = imgCell;
    self.imgviewDetailBG.image = imgCell;
    self.imgviewCommentBG.image = imgCell;
    self.imgviewSellerBG.image = imgCell;
    self.imgviewPicBG.image = imgCell;
    self.imgviewBottomBG.image = imgCell;
    
    [self.btnDetail setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg_press"] forState:UIControlStateHighlighted];
    [self.btnDetail setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg"] forState:UIControlStateNormal];
    
    [self.btnComment setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg_press"] forState:UIControlStateHighlighted];
    [self.btnComment setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg"] forState:UIControlStateNormal];
    
    [self.btnType setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg_press"] forState:UIControlStateHighlighted];
    [self.btnType setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg"] forState:UIControlStateNormal];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    self.viewBlack = [[UIView alloc] initWithFrame:window.bounds];
    self.viewBlack.backgroundColor = [UIColor blackColor];
    self.viewBlack.alpha = 0.4;
    
    UIImage *imgFrame = [UIImage imageNamed:@"frame_gray"];
    imgFrame = [imgFrame resizableImageWithCapInsets:UIEdgeInsetsMake(7, 15, 7, 15)];
    self.imgviewMinus.image = imgFrame;
    self.imgviewAdd.image = imgFrame;
    self.imgviewNumber.image = imgFrame;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelectTypeView)];
    [self.viewBlack addGestureRecognizer:tapGesture];
    
    self.arrayEdit = [[NSMutableArray alloc] initWithObjects:self.txtfieldNumberS, nil];
    self.keyboardbar = [[KeyBoardTopBar alloc] init];
    [self.keyboardbar setAllowShowPreAndNext:NO];  // 隐藏前一项、后一项
    [self.keyboardbar setIsInNavigationController:NO];
    [self.keyboardbar setTextFieldsArray:self.arrayEdit];
    self.txtfieldNumberS.inputAccessoryView = self.keyboardbar.view;
    
    self.changeNumber = NO;
    
    if (self.fromCart == YES)
    {
        self.btnCart.enabled = NO;
    }
    
    // 获取商品详情数据
    [self requestProductDetail];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.scrollPic.delegate = nil;
    self.scrollProduct.delegate = nil;
}

- (void)showUserLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginVC.completionBlock = ^(BOOL isSucceed, NSString *message) {
        if (isSucceed) {
//            [self.tabBarController setSelectedIndex:self.view.tag];
//            self.navigationItem.title = @"购物车";
        }
    };
    NavigationViewController *navVC = [[NavigationViewController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navVC animated:YES completion:^{
        //
    }];
}


#pragma mark - Action

// 收藏
- (IBAction)collectProduct:(id)sender
{
    // 先判断是否已登录
    if ([[UserManager shareInstant] isLogin] == NO)
    {
        [self showUserLogin];
        return;
    }
    
    [self startLoading:kLoading];
        
    // 判断是否已收藏
    if ([self.productDetail.is_fav isEqualToString:@"1"])
    {
        // 已收藏,则取消收藏
        [InterfaceManager cancelProductCollection:self.productDetail.goods_id completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            if (isSucceed) {
                NSLog(@"取消收藏成功");
                /*
                 {
                 "status": "success",
                 "msg": "取消成功！",
                 "data": ""
                 }
                 */
                [self toast:[data objectForKey:@"msg"]];
                
                self.productDetail.is_fav = @"0";
                [self.btnCollect setTitle:@"收藏" forState:UIControlStateNormal];
                [self.btnCollect setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                // 刷新个人中心数据
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserCenter object:nil];
            }else {
                NSLog(@"取消收藏失败:%@", message);
                [self toast:message];
            }
        }];
    }
    else
    {
        // 未收藏,则收藏
        [InterfaceManager addProductCollection:self.productDetail.goods_id completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            if (isSucceed) {
                NSLog(@"加入收藏成功");
                /*
                {
                    "status": "success",
                    "msg": "收藏成功",
                    "data": ""
                }
                */
//                NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
//                NSError *error = nil;
                [self toast:[data objectForKey:@"msg"]];
                
                self.productDetail.is_fav = @"1";
                [self.btnCollect setTitle:@"已收藏" forState:UIControlStateNormal];
                [self.btnCollect setTitleColor:[UIColor colorWithRed:(CGFloat)146/255 green:(CGFloat)0 blue:(CGFloat)0 alpha:1] forState:UIControlStateNormal];
                // 刷新个人中心数据
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserCenter object:nil];
            }else {
                NSLog(@"加入收藏失败:%@", message);
                [self toast:message];
            }
        }];
    }
}

// 立即购买 or 加入购物车
- (IBAction)payOrCartAction:(id)sender
{
    // 请判断是否已登录
    if ([[UserManager shareInstant] isLogin] == NO)
    {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.completionBlock = ^(BOOL isSucceed, NSString *message) {
            if (isSucceed) {
//                [self dismissViewControllerAnimated:YES completion:^{
//                    //
//                }];
            }
        };
        NavigationViewController *navVC = [[NavigationViewController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navVC animated:YES completion:^{
            //
        }];
        return;
    }
    
    // 若是在规格选择视图中进行立即购买或加入购物车,则需要先移除当前视图
    if (self.popviewIsShow == YES)
    {
        [self removeSelectTypeView];
    }
    
    UIButton *btn = (UIButton *)sender;
    int tag = (int)btn.tag;
    if (tag == kTag)            // 购买
    {
        [self startLoading:kLoading];
        ProductBuyRequestModel *product = [[ProductBuyRequestModel alloc] init];
        product.member_id = [[UserManager shareInstant] getMemberId];
        product.goods_id = self.productDetail.goods_id;
        product.product_id = [(ProductTypeModel *)[self.productDetail.products objectAtIndex:0] product_id];
        product.num = @"1"; // 数量暂时定为1
        product.is_fast = @"1";
        
        // 需判断是否为多规格商品
        if (self.productDetail.products.count > 1)
        {
            product.num = self.txtfieldNumberS.text;
        }
        
        [InterfaceManager buyProductNow:product completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            if (isSucceed) {
                NSLog(@"立即购买成功");
                NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
                NSError *error = nil;
                NSLog(@"%@", dataDic);
                CartResponseModel *cartSubmitRes = [[CartResponseModel alloc] initWithDictionary:dataDic error:&error];
                if (error)
                {
                    NSLog(@"json解析失败:%@", error);
                }
                else
                {
                    NSLog(@"seller count:%d, total:%@", cartSubmitRes.aCart.count, cartSubmitRes.total);
                    CartSubmitViewController *submitVC = [[CartSubmitViewController alloc] initWithNibName:@"CartSubmitViewController" bundle:nil];
                    submitVC.cartSubmitReq = nil;
                    submitVC.type = 0;  // 立即购买
                    submitVC.cartSubmitRes = cartSubmitRes;
                    [self.navigationController pushViewController:submitVC animated:YES];
                }
            }else {
                NSLog(@"立即购买失败:%@", message);
                [self toast:message];
            }
        }];
    }
    else if (tag == kTag + 1)   // 加入购物车
    {
        [self startLoading:kLoading];
        AddCartRequestModel *cart = [[AddCartRequestModel alloc] init];
        cart.goods_id = self.productDetail.goods_id;
        cart.product_id = [(ProductTypeModel *)[self.productDetail.products objectAtIndex:0] product_id];
        cart.type = @"goods";
        cart.num = @"1";
        cart.member_id = [[UserManager shareInstant] getMemberId];
        
        // 需判断是否为多规格商品
        if (self.productDetail.products.count > 1)
        {
            cart.num = self.txtfieldNumberS.text;
        }
        
        // 加入购物车请求
        [InterfaceManager addProductToShoppingCart:cart completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            if (isSucceed) {
                NSLog(@"加入购物车成功");
//                NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
//                NSError *error = nil;
                [self toast:[data objectForKey:@"msg"]];
            }else {
                NSLog(@"加入购物车失败:%@", message);
                [self toast:message];
            }
        }];
    }
    else
    {
       //
    }
}

// 显示商品规格
- (IBAction)showAndSelectProductType:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = (int)btn.tag;
    if (tag == kButtonTag)              // 选择商品型号、尺码等
    {
        self.popviewIsShow = YES;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIWindow *window = appDelegate.window;

        UIView *view = [window viewWithTag:100];
        view.backgroundColor = [UIColor blackColor];
        
        [window addSubview:self.viewBlack];
        CGRect rect = CGRectMake(0, window.frame.size.height, 320, 382);
        self.viewSelect.frame = rect;
        [window addSubview:self.viewSelect];
        
        [UIView animateWithDuration:0.4 animations:^{
            CGAffineTransform affineScale = CGAffineTransformMakeScale(0.9, 0.9);
            CGAffineTransform affineMove = CGAffineTransformMakeTranslation(0, -17);
            window.rootViewController.view.transform = CGAffineTransformConcat(affineScale, affineMove);
            
            self.viewSelect.frame = CGRectMake(0, window.frame.size.height-382, 320, 382);
        } completion:^(BOOL finished) {
            //
        }];
        
        /***************************************************************/
        
//        [self.view addSubview:self.viewBlack];
//        [self.view bringSubviewToFront:self.viewBottom];
//        
//        CGRect rect = self.viewBottom.frame;
//        self.viewSelect.frame = CGRectMake(0, rect.origin.y-337, 320, 337);
//        [self.view addSubview:self.viewSelect];
        
        /*
        // 获取商品规格
        [InterfaceManager getProductParameters:self.productDetail.goods_id completion:^(BOOL isSucceed, NSString *message, id data) {
            if (isSucceed)
            {
                NSLog(@"获取商品规格成功");
                NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
//                NSError *error = nil;
//                self.subCategory = [[ProductSubCatListModel alloc] initWithDictionary:dataDic error:&error];
//                if (error != nil)
//                {
//                    NSLog(@"json解析失败:%@", error);
//                    return;
//                }
            }
            else
            {
                NSLog(@"获取商品规格失败");
                [self toast:message];
            }
        }];
        */
    }
    else if (tag == kButtonTag + 1)     // 查看商品详细介绍
    {
        ProductInfoViewController *infoVC = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
        infoVC.productUrl = self.productDetail.intro_url;
        infoVC.htmlStr = nil;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
    else if (tag == kButtonTag + 2)     // 查看商品评价详情
    {
        ProductCommentViewController *commentVC = [[ProductCommentViewController alloc] initWithNibName:@"ProductCommentViewController" bundle:nil];
        commentVC.product = self.productDetail;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
    else
    {
        //
    }
}

// 移除商品规格视图 or 数量 － ＋
- (IBAction)selectTypeViewAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    if (tag == kSelectTag)          // 删除
    {
        [self removeSelectTypeView];
    }
    else if (tag == kSelectTag+1)   // －
    {
        int number = [self.txtfieldNumberS.text intValue];
        number--;
        if (number > 0 && number <= self.storeNumber)
        {
            self.selectNumber = number;
            self.txtfieldNumberS.text = [NSString stringWithFormat:@"%d", number];
        }
        else
        {
            [self toast:@"数量超出范围"];
            self.txtfieldNumberS.text = [NSString stringWithFormat:@"%d", self.selectNumber];   // 超出范围,则还是显示之前的库存量
        }
    }
    else if (tag == kSelectTag+2)   // ＋
    {
        int number = [self.txtfieldNumberS.text intValue];
        number++;
        if (number > 0 && number <= self.storeNumber)
        {
            self.selectNumber = number;
            self.txtfieldNumberS.text = [NSString stringWithFormat:@"%d", number];
        }
        else
        {
            [self toast:@"数量超出范围"];
            self.txtfieldNumberS.text = [NSString stringWithFormat:@"%d", self.selectNumber];   // 超出范围,则还是显示之前的库存量
        }
    }
    else
    {
        //
    }
}

// 移除视图
- (void)removeSelectTypeView
{
    self.popviewIsShow = NO;
    
    [self.txtfieldNumberS resignFirstResponder];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    
    [UIView animateWithDuration:0.4 animations:^{
        window.rootViewController.view.transform = CGAffineTransformIdentity;
        self.viewSelect.frame = CGRectMake(0, window.frame.size.height, 320, 382);
    } completion:^(BOOL finished) {
        [self.viewSelect removeFromSuperview];
        [self.viewBlack removeFromSuperview];
        [self.scrollviewS scrollRectToVisible:CGRectMake(0, 0, 320, 20) animated:NO];
        
        UIView *view = [window viewWithTag:100];
        view.backgroundColor = [UIColor whiteColor];
    }];
}


#pragma mark - Request

- (void)requestProductDetail
{
    [self startLoading:kLoading];
    [InterfaceManager getProductDetail:self.productModel.goods_id completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSLog(@"获取商品详情成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            //NSLog(@"dataDic:%@", dataDic);
            self.productDetail = [[ProductDetailModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            NSLog(@"name:%@, comment count:%d", _productDetail.name, _productDetail.comments.list.count);
            // 显示商品详情
            [self showProductContent];
        }
        else
        {
            NSLog(@"获取商品详情失败:%@", message);
        }
    }];
}


#pragma mark -  ShowContent

// 显示商品详情
- (void)showProductContent
{
    
    // 根据商品类型<单规格 or 多规格>来动态设置ui
    //[self showOrHideProductTypeSelectView];
    
    // 显示界面上方商品大图
    NSURL *imgUrl = [NSURL URLWithString:self.productDetail.image_default.l];
    [self.imgviewPic setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:kImageNameDefault]];
    
    // 显示商品名称、价格等
    self.lblName.text = self.productDetail.name;
    self.lblPriceMarket.text = [NSString stringWithFormat:@"¥ %.2f", [self.productDetail.mktprice floatValue]];
    self.lblPrice.text = [NSString stringWithFormat:@"¥ %.2f", [self.productDetail.price floatValue]];
    
    // 显示评价条数
    if (self.productDetail.comments.count == 0)
    {
        self.lblCommentNumber.text = @"（暂无评价）";
        self.lblComment.textColor = [UIColor darkGrayColor];
        self.lblCommentNumber.textColor = [UIColor darkGrayColor];
        self.btnComment.enabled = NO;
    }
    else
    {
        self.lblCommentNumber.text = [NSString stringWithFormat:@"（%@）", self.productDetail.comments.count];
        self.lblComment.textColor = [UIColor blackColor];
        self.lblCommentNumber.textColor = [UIColor blackColor];
        self.btnComment.enabled = YES;
    }
    
    // 显示卖家信息
    NSURL *sellerImgUrl = [NSURL URLWithString:self.productDetail.seller_info.logo];
    [self.imgviewSeller setImageWithURL:sellerImgUrl placeholderImage:[UIImage imageNamed:kImageNameDefault]];
    self.lblSeller.text = self.productDetail.seller_info.name;
    
    // 显示商品图片集
    int count = self.productDetail.images.count;
    self.pageControl.numberOfPages = count;
    self.pageControl.currentPage = 0;
    //self.scrollPic.contentSize = CGSizeMake(320*count, 130);
    self.scrollPic.contentSize = CGSizeMake((130+20)*count+20, 130);
    for (int i = 0; i < count; i++)
    {
//        ProductImageModel *imgModel = [self.productDetail.images objectAtIndex:i];
//        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, 320, 130)];
//        imgview.contentMode = UIViewContentModeScaleAspectFit;
//        [imgview setImageWithURL:[NSURL URLWithString:imgModel.s] placeholderImage:[UIImage imageNamed:kImageNameDefault]];
//        imgview.tag = i;
//        [self.scrollPic addSubview:imgview];
        
        ProductImageModel *imgModel = [self.productDetail.images objectAtIndex:i];
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(20+i*(130+20), 0, 130, 130)];
        imgview.contentMode = UIViewContentModeScaleAspectFit;
        [imgview setImageWithURL:[NSURL URLWithString:imgModel.s] placeholderImage:[UIImage imageNamed:kImageNameDefault]];
        imgview.tag = i;
        [self.scrollPic addSubview:imgview];
    }
    
    // 判断当前商品是否已收藏
    if ([self.productDetail.is_fav isEqualToString:@"1"])
    {
        //[self.btnCollect setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.btnCollect setTitle:@"已收藏" forState:UIControlStateNormal];
        [self.btnCollect setTitleColor:[UIColor colorWithRed:(CGFloat)146/255 green:(CGFloat)0 blue:(CGFloat)0 alpha:1] forState:UIControlStateNormal];
    }
    else
    {
        //[self.btnCollect setImage:[UIImage imageNamed:@"btn_love"] forState:UIControlStateNormal];
        [self.btnCollect setTitle:@"收藏" forState:UIControlStateNormal];
        [self.btnCollect setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    // 判断是单规格商品 or 多规格商品
    if (self.productDetail.products == nil)
    {
        NSLog(@"返回数据错误,未返回具体商品规格信息");
        self.lblType.textColor = [UIColor darkGrayColor];
        self.btnType.enabled = NO;
    }
    else
    {
        if (self.productDetail.products.count == 0)
        {
            NSLog(@"返回数据错误,未返回具体商品规格信息");
            self.lblType.textColor = [UIColor darkGrayColor];
            self.btnType.enabled = NO;
        }
        else
        {
            if (self.productDetail.products.count == 1)
            {
                NSLog(@"单规格商品");
                self.lblType.textColor = [UIColor darkGrayColor];
                self.btnType.enabled = NO;
            }
            else
            {
                NSLog(@"多规格商品");
                self.lblType.textColor = [UIColor blackColor];
                self.btnType.enabled = YES;
                // 设置商品规格
                [self setttingTypeSelectedView];
            }
            // 默认选中第一个规格的商品
            ProductTypeModel *typeModel = [self.productDetail.products objectAtIndex:0];
            self.lblStore.text = typeModel.store;
            self.lblPrice.text = [NSString stringWithFormat:@"¥ %.2f", [typeModel.price floatValue]];
        }
    }
}

// 类型选择视图设置
- (void)setttingTypeSelectedView
{
    int count = self.productDetail.products.count;
    if (count <= 1)
    {
        // 单规格商品
    }
    else
    {
        // 多规格商品
        CGFloat typeHight = 50 + 42*count + 10;
        CGFloat totalHight = typeHight + 54;
        self.viewTypeS.frame = CGRectMake(0, 0, 320, typeHight);
        self.viewNumberS.frame = CGRectMake(0, typeHight, 320, 54);
        self.scrollviewS.contentSize = CGSizeMake(320, totalHight);
        [self.scrollviewS addSubview:self.viewTypeS];
        [self.scrollviewS addSubview:self.viewNumberS];
        
        for (int i = 0; i < self.productDetail.products.count; i++)
        {
            ProductTypeModel *product = [self.productDetail.products objectAtIndex:i];
            if (i == 0)
            {
                product.isSelected = @"1";  // 默认选中第一个
                self.storeNumber = [product.store intValue];    // 当前商品总库存
                if (self.storeNumber == 0)
                {
                    self.selectNumber = 0;
                    self.txtfieldNumberS.text = @"0";
                }
                else
                {
                    // 商品有库存时,默认数量为1
                    self.selectNumber = 1;  // 当前商品默认为选中的数量
                    self.txtfieldNumberS.text = [NSString stringWithFormat:@"%d", self.selectNumber];
                }
            }
            else
            {
                product.isSelected = @"0";
            }
            
            ProductTypeView *view = [ProductTypeView viewFromNib];
            view.frame = CGRectMake(0, 50+42*i, 320, 42);
            view.lblContent.text = product.spec_info;
            [view settingView:product];
            view.tag = kSelectTag + i;
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectType:)];
            [view addGestureRecognizer:tapGesture];
            [self.viewTypeS addSubview:view];
        }
        
        self.viewTypeS.backgroundColor = [UIColor clearColor];
        self.viewNumberS.backgroundColor = [UIColor clearColor];
        
        /*******************************************************/
        
        NSURL *imgUrl = [NSURL URLWithString:self.productDetail.image_default.s];
        [self.imgviewPicS setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:kImageNameDefault]];
        
        self.lblNameS.text = self.productDetail.name;
        self.lblPriceS.text = [NSString stringWithFormat:@"¥ %.2f", [self.productDetail.price floatValue]];
    }
}

// 选择商品规格
- (void)selectType:(UIGestureRecognizer *)tap
{
    ProductTypeView *view = (ProductTypeView *)tap.view;
    int tag = view.tag - kSelectTag;
    NSLog(@"select:%d", tag);
    
    // 刷新数据源
    ProductTypeModel *product = [self.productDetail.products objectAtIndex:tag];
    for (ProductTypeModel *product in self.productDetail.products)
    {
        product.isSelected = @"0";
    }
    product.isSelected = @"1";  // 当前规格选中
    self.storeNumber = [product.store intValue];
    self.lblStore.text = [NSString stringWithFormat:@"%d", self.storeNumber];
    if (self.storeNumber == 0)
    {
        self.selectNumber = 0;
        self.txtfieldNumberS.text = @"0";
    }
    else
    {
        // 商品有库存时,默认数量为1
        self.selectNumber = 1;  // 当前商品默认为选中的数量
        self.txtfieldNumberS.text = [NSString stringWithFormat:@"%d", self.selectNumber];
    }
    
    // 更新视图显示
    NSArray *arraryView = [self.viewTypeS subviews];
    for (UIView *view in arraryView)
    {
        if ([view isKindOfClass:[ProductTypeView class]] == YES)
        {
            ProductTypeView *viewType = (ProductTypeView *)view;
            int tagP = viewType.tag - kSelectTag;
            ProductTypeModel *product = [self.productDetail.products objectAtIndex:tagP];
            [viewType settingView:product];
        }
    }
}

// 不再使用
- (void)showOrHideProductTypeSelectView
{
    if (self.productDetail.spec_url == nil)
    {
        // 单规格商品
        // 不显示,需隐藏
        self.viewType.hidden = YES;
        
        CGRect rect = self.viewDetail.frame;
        rect.origin.y -= (50+6);
        self.viewDetail.frame = rect;
        
        rect = self.viewComment.frame;
        rect.origin.y -= (50+6);
        self.viewComment.frame = rect;
        
        rect = self.viewSeller.frame;
        rect.origin.y -= (50+6);
        self.viewSeller.frame = rect;
        
        rect = self.viewPic.frame;
        rect.origin.y -= (50+6);
        self.viewPic.frame = rect;
        
        CGSize size = self.scrollProduct.contentSize;
        size.height -= (50 + 6);
        self.scrollProduct.contentSize = size;
    }
    else
    {
        // 多规格商品
        // 显示,故不做操作
    }
}


/*
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == kTag + 1)
    {
        CGFloat pageWidth = self.scrollPic.frame.size.width;
        // 在滚动超过页面宽度的50%的时候，切换到新的页面
        // + 1 是因为paged control 是从1开始计数的 <scrollView.contentOffset.x / scrollView.frame.size.width>
        //int page = floor((self.scrollviewPic.contentOffset.x - pageWidth/2)/pageWidth) + 1;
        int page = floor((self.scrollPic.contentOffset.x + pageWidth/2)/pageWidth);
        //self.lblIndex.text = [NSString stringWithFormat:@"%d / %d", page+1, self.arrayPic.count];
        self.pageControl.currentPage = page;
    }
}
*/


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // KeyBoardTopBar的实例对象调用显示键盘方法
    [self.keyboardbar showBar:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.changeNumber = YES;
    return YES;
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    self.changeNumber = NO;
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.changeNumber = NO;
}


#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillShow");
    
//    NSDictionary *userInfo = [notification userInfo];
//    
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
//    CGFloat keyboardHeight = keyboardFrame.size.height; // 获取键盘高度
//    //NSLog(@"<keyboardHeight:%f>",keyboardHeight);
//    
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;   // 键盘动画时间
//    [animationDurationValue getValue:&animationDuration];
//    
//    CGFloat scrollHeight = _viewRect.size.height + 52 - keyboardHeight;
    
    if (self.changeNumber == NO)
    {
        return;
    }
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollviewS setContentOffset:CGPointMake(0, self.viewNumberS.frame.origin.y) animated:YES];
        //[self.scrollviewS setContentOffset:CGPointMake(0, 313) animated:YES];
    } completion:^(BOOL finished) {
        self.scrollviewS.scrollEnabled = NO;
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillHide");
    
    if (self.changeNumber == NO)
    {
        return;
    }
    
    self.changeNumber = NO;
    
    // 重新获得当前商品的购买数量
    int number = [self.txtfieldNumberS.text intValue];  // 02
    if (number > 0 && number <= self.storeNumber)
    {
        self.selectNumber = number;  // 赋值
        self.txtfieldNumberS.text = [NSString stringWithFormat:@"%d", number];
    }
    else
    {
        if (number <= 0 || number > self.storeNumber)
            self.txtfieldNumberS.text = [NSString stringWithFormat:@"%d", self.selectNumber];
        [self toast:@"数量超出范围"];
    }
    
    self.scrollviewS.scrollEnabled = YES;
    //[self.scrollviewS setContentOffset:CGPointMake(0, 0) animated:YES];
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        //[self.scrollviewS scrollRectToVisible:CGRectMake(0, self.scrollviewS.contentSize.height-50, 320, 50) animated:YES];
        [self.scrollviewS setContentOffset:CGPointMake(0, self.scrollviewS.contentSize.height-self.scrollviewS.frame.size.height) animated:YES];
    } completion:^(BOOL finished) {
        //
    }];
    
}


@end
