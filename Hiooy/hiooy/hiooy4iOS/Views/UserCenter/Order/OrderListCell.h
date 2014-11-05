//
//  OrderListCell.h
//  hiooy
//
//  Created by retain on 14-5-7.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *viewLine;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblPrice;
@property (nonatomic, weak) IBOutlet UILabel *lblNumber;

+ (OrderListCell *)cellFromNib;
- (void)settingCell:(id)data;

@end
