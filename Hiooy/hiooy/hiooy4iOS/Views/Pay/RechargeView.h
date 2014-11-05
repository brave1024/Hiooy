//
//  RechargeView.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-27.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  预存款充值界面中的支付方式选择视图

#import <UIKit/UIKit.h>

@protocol RechargeViewDelegate <NSObject>

- (void)payMethodSelected:(int)tag;

@end

@interface RechargeView : UIView

@property (nonatomic, weak) IBOutlet UIButton *btnSelect;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;

@property (nonatomic, assign) id<RechargeViewDelegate> delegate;

+ (RechargeView *)viewFromNib;
- (void)settingView:(id)data;
- (IBAction)selectRechargeMethod:(id)sender;

@end
