//
//  ProductDetailViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-15.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品详情界面

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "ProductDetailModel.h"

@interface ProductDetailViewController : BaseViewController <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) ProductModel *productModel;           // 上个界面传过来的<商品列表中的item>
@property (nonatomic, strong) ProductDetailModel *productDetail;    // 当前界面请求的<商品详情>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollProduct;

//
@property (nonatomic, strong) IBOutlet UIView *viewBase;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblPriceMarket;
@property (nonatomic, strong) IBOutlet UILabel *lblPrice;
@property (nonatomic, strong) IBOutlet UILabel *lblStore;   
@property (nonatomic, strong) IBOutlet UIButton *btnCollect;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewBaseBG;

//
@property (nonatomic, strong) IBOutlet UIView *viewType;
@property (nonatomic, strong) IBOutlet UILabel *lblType;
@property (nonatomic, strong) IBOutlet UIButton *btnType;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewTypeBG;

//
@property (nonatomic, strong) IBOutlet UIView *viewDetail;
@property (nonatomic, strong) IBOutlet UILabel *lblDetail;
@property (nonatomic, strong) IBOutlet UIButton *btnDetail;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewDetailBG;

//
@property (nonatomic, strong) IBOutlet UIView *viewComment;
@property (nonatomic, strong) IBOutlet UILabel *lblComment;
@property (nonatomic, strong) IBOutlet UILabel *lblCommentNumber;
@property (nonatomic, strong) IBOutlet UIButton *btnComment;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewCommentBG;

//
@property (nonatomic, strong) IBOutlet UIView *viewSeller;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewSeller;
@property (nonatomic, strong) IBOutlet UILabel *lblSeller;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewSellerBG;

//
@property (nonatomic, strong) IBOutlet UIView *viewPic;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollPic;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewPicBG;

//
@property (nonatomic, strong) IBOutlet UIView *viewBottom;
@property (nonatomic, strong) IBOutlet UIButton *btnPay;
@property (nonatomic, strong) IBOutlet UIButton *btnCart;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewBottomBG;

// 类型选择
@property (nonatomic, strong) IBOutlet UIView *viewSelect;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewPicS;
@property (nonatomic, strong) IBOutlet UILabel *lblNameS;
@property (nonatomic, strong) IBOutlet UILabel *lblPriceS;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollviewS;
@property (nonatomic, strong) IBOutlet UIView *viewTypeS;
@property (nonatomic, strong) IBOutlet UIView *viewNumberS;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldNumberS;
@property (nonatomic, strong) IBOutlet UIButton *btnMinus;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewMinus;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewAdd;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewNumber;
@property (nonatomic, strong) IBOutlet UIButton *btnPayS;
@property (nonatomic, strong) IBOutlet UIButton *btnCartS;

@property (nonatomic, assign) BOOL fromCart;    // 来自购物车界面

@property (nonatomic, strong) NSMutableArray *arrayEdit;      // 存放视图中可编辑的控件
@property (nonatomic, strong) KeyBoardTopBar *keyboardbar;    //

- (IBAction)collectProduct:(id)sender;
- (IBAction)payOrCartAction:(id)sender;
- (IBAction)showAndSelectProductType:(id)sender;
- (IBAction)selectTypeViewAction:(id)sender;

@end


