//
//  MoneyRecordTableViewCell.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-23.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyRecordTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblTime;
@property (nonatomic, weak) IBOutlet UILabel *lblPay;
@property (nonatomic, weak) IBOutlet UILabel *lblType;
@property (nonatomic, weak) IBOutlet UILabel *lblTotal;

+ (MoneyRecordTableViewCell *)cellFromNib;
- (void)settingCell:(id)data;

@end
