//
//  OrderHeadView.h
//  hiooy
//
//  Created by retain on 14-5-7.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHeadView : UIView

@property (nonatomic, weak) IBOutlet UILabel *lblOrderId;
@property (nonatomic, weak) IBOutlet UILabel *lblOrderTime;
@property (nonatomic, weak) IBOutlet UILabel *lblOrderStatus;
@property (nonatomic, weak) IBOutlet UILabel *lblOrderSeller;

+ (OrderHeadView *)viewFromNib;
- (void)settingView:(id)data;

@end
