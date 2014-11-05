//
//  ShippingCell.h
//  hiooy
//
//  Created by retain on 14-4-25.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartResponseShippingModel.h"

@interface ShippingCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblPrice;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewSelected;

+ (ShippingCell *)cellFromNib;
- (void)settingCell:(id)data;

@end
