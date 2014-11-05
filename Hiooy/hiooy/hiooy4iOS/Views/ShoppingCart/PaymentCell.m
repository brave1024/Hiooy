//
//  PaymentCell.m
//  hiooy
//
//  Created by retain on 14-4-25.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "PaymentCell.h"

@implementation PaymentCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (PaymentCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PaymentCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)data
{
    CartResponsePaymentModel *payment = (CartResponsePaymentModel *)data;
    if ([payment.choosed isEqualToString:@"true"] == YES)
    {
        self.imgviewSelected.hidden = NO;
    }
    else
    {
        self.imgviewSelected.hidden = YES;
    }
    self.lblName.text = payment.app_display_name;
    self.lblPrice.hidden = YES;
}


@end
