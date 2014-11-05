//
//  OrderCell.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;

@property (nonatomic, weak) IBOutlet UIView *viewContent;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblType;

@property (nonatomic, weak) IBOutlet UILabel *lblPrice;
@property (nonatomic, weak) IBOutlet UILabel *lblNumber;

+ (OrderCell *)cellFromNib;
- (void)settingCell:(id)cellData;

@end
