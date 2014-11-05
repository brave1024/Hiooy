//
//  GrouponDetailViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-5.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "GrouponDetailViewController.h"
#import "LoginViewController.h"
#import "ProductTypeView.h"
#import "CartResponseModel.h"
#import "CartSubmitViewController.h"
#import "ProductInfoViewController.h"

@interface GrouponDetailViewController ()
@property (nonatomic, strong) UIView *viewBlack;
//@property int store;        // 商品库存
@property int storeNumber;  // 当前用户选中规格的商品库存
@property int selectNumber; // 用户输入的商品数
@property BOOL changeNumber;    // 表示当前键盘弹出原因是因为用户修改商品数量
@property BOOL popviewIsShow;   // 规格选择视图是否弹出
@end

@implementation GrouponDetailViewController

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
    
    self.navigationItem.title = @"详情";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navController showBackButtonWith:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)241/255 green:(CGFloat)241/255 blue:(CGFloat)241/255 alpha:1];
    self.scrollProduct.backgroundColor = [UIColor clearColor];
    self.scrollPic.backgroundColor = [UIColor clearColor];
    
    self.scrollProduct.contentSize = CGSizeMake(320, 528);
    self.scrollProduct.tag = kTag;
    
    //self.scrollPic.pagingEnabled = YES;
    //self.scrollPic.showsHorizontalScrollIndicator = NO;
    self.pageControl.hidden = NO;
    self.pageControl.currentPage = 0;
    
    UIImage *img = [UIImage imageNamed:@"btn_red"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnPay setBackgroundImage:img forState:UIControlStateNormal];
    [self.btnPay setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.btnPayS setBackgroundImage:img forState:UIControlStateNormal];
    [self.btnPayS setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    UIImage *imgCell = [UIImage imageNamed:@"bg_cell"];
    imgCell = [imgCell resizableImageWithCapInsets:UIEdgeInsetsMake(6, 2, 6, 2)];
    self.imgviewBaseBG.image = imgCell;
    self.imgviewTypeBG.image = imgCell;
    self.imgviewDetailBG.image = imgCell;
    self.imgviewBottomBG.image = imgCell;
    
    [self.btnType setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg_press"] forState:UIControlStateHighlighted];
    [self.btnType setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg"] forState:UIControlStateNormal];
    [self.btnDetail setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg_press"] forState:UIControlStateHighlighted];
    [self.btnDetail setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg"] forState:UIControlStateNormal];
    
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
    
    // 获取商品详情数据
    [self requestGrouponDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestGrouponDetail
{
    [self startLoading:kLoading];
    
    [InterfaceManager getGroupOnDetail:self.activityItem.act_id completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed == YES)
        {
            NSLog(@"获取团购详情信息成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
            NSDictionary *dic = [dataDic objectForKey:@"purchase"];
            NSError *error = nil;
            self.productDetail = [[ActivityDetailModel alloc] initWithDictionary:dic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析错误:%@", error);
            }
            else
            {
                NSLog(@"name:%@", self.productDetail.name);
                // 显示商品详情
                [self showProductContent];
            }
        }
        else
        {
            [self toast:message];
        }
    }];
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
    
    UIButton *btn = (UIButton *)sender;
    int tag = (int)btn.tag;
    if (tag == kTag)            // 购买
    {
        // 货品id
        NSString *productID = nil;
        if (self.productDetail.products.count == 1)
        {
            ActivityProductModel *item = (ActivityProductModel *)[self.productDetail.products objectAtIndex:0];
            productID = item.product_id;
        }
        else if (self.productDetail.products.count > 1)
        {
            for (ActivityProductModel *item in self.productDetail.products)
            {
                if ([item.isSelected isEqualToString:@"1"] == YES)
                {
                    productID = item.product_id;
                    break;
                }
            }
        }
        else
        {
            [self toast:@"当前商品数据错误,无法购买"];
            return;
        }
        
        if (productID == nil)
        {
            [self toast:@"当前商品数据错误,无法购买"];
            return;
        }
        
        // 若是在规格选择视图中进行立即购买或加入购物车,则需要先移除当前视图
        if (self.popviewIsShow == YES)
        {
            [self removeSelectTypeView];
        }
        
        [self startLoading:kLoading];
        
        NSString *number = @"1";
        if (self.productDetail.products.count > 1)
        {
            number = self.txtfieldNumberS.text;
        }
        
        [InterfaceManager buyGrouponProduct:self.productDetail.goods_id withProductId:productID andNumber:number completion:^(BOOL isSucceed, NSString *message, id data) {
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
                    submitVC.type = 2;  // 团购秒杀的立即购买
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
        //
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
    self.popviewIsShow = YES;
    
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

// 显示本单详情
- (IBAction)showProductDetail:(id)sender
{
    ProductInfoViewController *infoVC = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
    infoVC.productUrl = nil;
    infoVC.htmlStr = self.productDetail.intro;
    [self.navigationController pushViewController:infoVC animated:YES];
}


#pragma mark -  ShowContent

// 显示商品详情
- (void)showProductContent
{
    
    // 显示界面上方商品大图集
    int count = self.productDetail.images.count;
    if (count > 0)
    {
        self.scrollPic.contentSize = CGSizeMake(320*count, 296);
        
        // 加载广告图片
        self.pageControl.numberOfPages = count;
        self.pageControl.currentPage = 0;
        self.scrollPic.pagingEnabled = YES;
        for (int i = 0; i < count; i++)
        {
            NSString *picStr = [self.productDetail.images objectAtIndex:i];
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 296)];
            imgview.tag = i;
            imgview.contentMode = UIViewContentModeScaleAspectFit;
            [imgview setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                //
            }];
            
//            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail:)];
//            [imgview addGestureRecognizer:tapGesture];
//            imgview.userInteractionEnabled = YES;
            
            [self.scrollPic addSubview:imgview];
        }
    }

    // 显示商品名称、价格等
    self.lblName.text = self.productDetail.name;
    self.lblPriceMarket.text = [NSString stringWithFormat:@"¥ %.2f", [self.productDetail.old_price floatValue]];
    self.lblPrice.text = [NSString stringWithFormat:@"¥ %.2f", [self.productDetail.price floatValue]];
    self.storeNumber = [self.productDetail.max_buy intValue];   // 当前商品库存...<最大购买量>
    
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
            ActivityProductModel *typeModel = [self.productDetail.products objectAtIndex:0];
            self.lblStore.text = typeModel.store;
            //self.lblPrice.text = [NSString stringWithFormat:@"¥ %.2f", [typeModel.price floatValue]];
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
            // 多规格
            ActivityProductModel *product = [self.productDetail.products objectAtIndex:i];
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
        
        if (self.productDetail.images.count > 0)
        {
            NSString *picStr = [self.productDetail.images objectAtIndex:0];
            NSURL *imgUrl = [NSURL URLWithString:picStr];
            [self.imgviewPicS setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:kImageNameDefault]];
        }
        
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
    ActivityProductModel *product = [self.productDetail.products objectAtIndex:tag];
    for (ActivityProductModel *product in self.productDetail.products)
    {
        product.isSelected = @"0";
    }
    product.isSelected = @"1";  // 当前规格选中
    self.storeNumber = [product.store intValue];    // 当前商品的库存量
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
            ActivityProductModel *product = [self.productDetail.products objectAtIndex:tagP];
            [viewType settingView:product];
        }
    }
}


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


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollPic)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.frame;
        [self.pageControl setCurrentPage:offset.x/bounds.size.width];
    }
}



@end
