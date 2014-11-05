//
//  SecondKillTableViewCell.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-3.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomLineLabel.h"

@interface SecondKillTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UICustomLineLabel *lblMarketPrice;
@property (nonatomic, strong) IBOutlet UILabel *lblPrice;
//@property (nonatomic, strong) IBOutlet UILabel *lblStartTime;
@property (nonatomic, strong) IBOutlet UIButton *btnBuy;
@property (nonatomic, strong) IBOutlet UILabel *lblHour;
@property (nonatomic, strong) IBOutlet UILabel *lblMinute;
@property (nonatomic, strong) IBOutlet UILabel *lblSecond;

@property (nonatomic, strong) IBOutlet UIView *viewDiscount;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewDiscount;
@property (nonatomic, strong) IBOutlet UILabel *lblDiscount;

@property (nonatomic, strong) NSTimer *timer;
@property long rTime;

+ (SecondKillTableViewCell *)cellFromNib;
- (void)settingCell:(id)data;

@end

