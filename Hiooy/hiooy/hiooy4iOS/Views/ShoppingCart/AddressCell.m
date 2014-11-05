//
//  AddressCell.m
//  hiooy
//
//  Created by retain on 14-4-25.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (AddressCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)data
{
    CartResponseAddressModel *addr = (CartResponseAddressModel *)data;
    if ([addr.choosed isEqualToString:@"true"] == YES)
    {
        self.imgviewSelected.hidden = NO;
    }
    else
    {
        self.imgviewSelected.hidden = YES;
    }
    self.lblName.text = addr.name;
    self.lblCity.text = addr.mobile;
    self.lblStreet.text = addr.address;
}


@end
