//
//  OrderFootView.h
//  hiooy
//
//  Created by retain on 14-5-7.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderFootViewDelegate <NSObject>

- (void)confirmReceiveProducts:(id)view;

@end

@interface OrderFootView : UIView

@property (nonatomic, weak) IBOutlet UIView *viewLine;
@property (nonatomic, weak) IBOutlet UILabel *lblMoney;
@property (nonatomic, weak) IBOutlet UIButton *btnReceive;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewBg;
@property (nonatomic, assign) id<OrderFootViewDelegate> delegate;

+ (OrderFootView *)viewFromNib;
- (void)settingView:(id)data;
- (IBAction)btnReceiveProductsAction:(id)sender;

@end
