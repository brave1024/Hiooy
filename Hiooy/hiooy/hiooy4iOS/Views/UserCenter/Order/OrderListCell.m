//
//  OrderListCell.m
//  hiooy
//
//  Created by retain on 14-5-7.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "OrderListCell.h"
#import "OrderGoodsModel.h"
#import "ProductCommentModel.h"

@implementation OrderListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (OrderListCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"OrderListCell" owner:self options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)data
{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.viewLine.frame = CGRectMake(0, 0, 300, 0.5);
    self.viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)217/255 green:(CGFloat)216/255 blue:(CGFloat)219/255 alpha:1];
    
    if ([data isKindOfClass:[ProductCommentModel class]] == YES)
    {
        ProductCommentModel *product = (ProductCommentModel *)data;
        [self.imgviewPic setImageWithURL:[NSURL URLWithString:product.image_url] placeholderImage:nil];
        self.lblName.text = product.product_name;
        self.lblPrice.text = [NSString stringWithFormat:@"%.2f 元", [product.price floatValue]];
        self.lblNumber.text = product.number;
    }
    else
    {
        OrderGoodsModel *goods = (OrderGoodsModel *)data;
        [self.imgviewPic setImageWithURL:[NSURL URLWithString:goods.image_url] placeholderImage:nil];
        self.lblName.text = goods.name;
        self.lblPrice.text = [NSString stringWithFormat:@"%.2f 元", [goods.price floatValue]];
        self.lblNumber.text = goods.nums;
    }
}


@end
