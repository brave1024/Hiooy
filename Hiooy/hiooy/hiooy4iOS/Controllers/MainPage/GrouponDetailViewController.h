//
//  GrouponDetailViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-5.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  团购详情界面

#import <UIKit/UIKit.h>
#import "ActivityItemModel.h"
#import "ActivityDetailModel.h"

@interface GrouponDetailViewController : BaseViewController <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) ActivityItemModel *activityItem;
@property (nonatomic, strong) ActivityDetailModel *productDetail;

//
@property (nonatomic, strong) IBOutlet UIScrollView *scrollProduct;

//
@property (nonatomic, strong) IBOutlet UIView *viewBase;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollPic;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblPriceMarket;
@property (nonatomic, strong) IBOutlet UILabel *lblPrice;
@property (nonatomic, strong) IBOutlet UILabel *lblStore;
//@property (nonatomic, strong) IBOutlet UIButton *btnCollect;
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
@property (nonatomic, strong) IBOutlet UIView *viewBottom;
@property (nonatomic, strong) IBOutlet UIButton *btnPay;
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

@property (nonatomic, strong) NSMutableArray *arrayEdit;      // 存放视图中可编辑的控件
@property (nonatomic, strong) KeyBoardTopBar *keyboardbar;    //

- (IBAction)payOrCartAction:(id)sender;
- (IBAction)showAndSelectProductType:(id)sender;
- (IBAction)selectTypeViewAction:(id)sender;
- (IBAction)showProductDetail:(id)sender;

@end
