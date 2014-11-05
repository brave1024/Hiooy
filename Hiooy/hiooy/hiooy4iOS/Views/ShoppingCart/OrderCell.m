//
//  OrderCell.m
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "OrderCell.h"
#import "CartGoodsModel.h"

@implementation OrderCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (OrderCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)cellData
{
    CartGoodsModel *goods = (CartGoodsModel *)cellData;
    [self.imgviewPic setImageWithURL:[NSURL URLWithString:goods.image_url] placeholderImage:[UIImage imageNamed:kImageNameDefault]];
    self.lblTitle.text = goods.name;
    self.lblPrice.text = [NSString stringWithFormat:@"¥ %.2f", [goods.price floatValue]];
    self.lblNumber.text = goods.quantity;
    self.lblType.hidden = YES;
}


@end
