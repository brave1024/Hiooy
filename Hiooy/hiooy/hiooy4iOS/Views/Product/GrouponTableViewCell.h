//
//  GrouponTableViewCell.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-3.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomLineLabel.h"

@interface GrouponTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UICustomLineLabel *lblMarketPrice;
@property (nonatomic, strong) IBOutlet UILabel *lblPrice;
@property (nonatomic, strong) IBOutlet UILabel *lblBuy;   // 已售数量

+ (GrouponTableViewCell *)cellFromNib;
- (void)settingCell:(id)data;

@end
