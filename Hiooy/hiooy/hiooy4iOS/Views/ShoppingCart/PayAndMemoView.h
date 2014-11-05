//
//  PayAndMemoView.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayAndMemoViewDelegate <NSObject>

- (void)selectPayment;
- (void)saveMemoContent;

@end

@interface PayAndMemoView : UIView <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewPay;
@property (nonatomic, weak) IBOutlet UIButton *btnPay;

@property (nonatomic, weak) IBOutlet UILabel *lblDiscount;
@property (nonatomic, weak) IBOutlet UILabel *lblMoney;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewMoney;

@property (nonatomic, weak) IBOutlet UILabel *lblTip;
@property (nonatomic, weak) IBOutlet UITextView *txtviewMemo;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewMemo;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewTxt;

@property (nonatomic, assign) id<PayAndMemoViewDelegate> delegate;

+ (PayAndMemoView *)viewFromNib;
- (void)settingView:(id)data;
- (IBAction)paymentBtnTouched:(id)sender;
- (void)hideKeyBoard;

@end
