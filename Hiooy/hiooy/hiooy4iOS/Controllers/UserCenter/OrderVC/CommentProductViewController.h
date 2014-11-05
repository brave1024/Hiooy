//
//  CommentProductViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品评价界面

#import <UIKit/UIKit.h>
#import "ProductCommentModel.h"
#import "CommentGoodsInfoModel.h"
#import "StarView.h"

@interface CommentProductViewController : BaseViewController <UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) ProductCommentModel *product;         // 上个界面传过来的待评价商品
@property (nonatomic, strong) CommentGoodsInfoModel *goodsItem;     //

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) IBOutlet UIView *viewProduct;
@property (nonatomic, strong) IBOutlet UILabel *lblSeller;
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, strong) IBOutlet UILabel *lblName;

@property (nonatomic, strong) IBOutlet UIView *viewScore;

@property (nonatomic, strong) IBOutlet UIView *viewSubmit;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewBg;
@property (nonatomic, strong) IBOutlet UITextView *txtviewContent;
@property (nonatomic, strong) IBOutlet UILabel *lblTip;
@property (nonatomic, strong) IBOutlet UIButton *btnNoName;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;

- (IBAction)hideUserName:(id)sender;
- (IBAction)submitComment:(id)sender;

@end
