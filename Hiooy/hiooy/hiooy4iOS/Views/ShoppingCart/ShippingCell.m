//
//  ShippingCell.m
//  hiooy
//
//  Created by retain on 14-4-25.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ShippingCell.h"

@implementation ShippingCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ShippingCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ShippingCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)data
{
    CartResponseShippingModel *shipping = (CartResponseShippingModel *)data;
    if ([shipping.choosed isEqualToString:@"true"] == YES)
    {
        self.imgviewSelected.hidden = NO;
    }
    else
    {
        self.imgviewSelected.hidden = YES;
    }
    self.lblName.text = shipping.dt_name;
    if (shipping.money == nil || [shipping.money isEqualToString:@""] == YES)
    {
        self.lblPrice.hidden = YES;
    }
    else
    {
        self.lblPrice.text = [NSString stringWithFormat:@"¥ %@", shipping.money];
    }
}



@end
