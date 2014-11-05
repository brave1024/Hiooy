//
//  GrouponTableViewCell.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-3.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "GrouponTableViewCell.h"
#import "ActivityItemModel.h"

@implementation GrouponTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (GrouponTableViewCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"GrouponTableViewCell" owner:self options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)data
{
    ActivityItemModel *item = (ActivityItemModel *)data;
    [self.imgviewPic setImageWithURL:[NSURL URLWithString:item.image_url] placeholderImage:[UIImage imageNamed:kImageNameDefault]];
    self.lblName.text = item.seller_name;
    self.lblTitle.text = item.name;
    self.lblMarketPrice.text = [NSString stringWithFormat:@"%.2f元", [item.old_price floatValue]];
    self.lblPrice.text = [NSString stringWithFormat:@"%.2f元", [item.price floatValue]];
    self.lblBuy.text = [NSString stringWithFormat:@"已售%d", [item.start_value intValue]];  // 已售数量
    
    self.lblMarketPrice.lineType = LineTypeMiddle;
    self.lblMarketPrice.lineColor = [UIColor darkGrayColor];
}


@end
