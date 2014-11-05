//
//  OrderHeadView.m
//  hiooy
//
//  Created by retain on 14-5-7.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "OrderHeadView.h"
#import "OrderItemModel.h"
#import "ProductCommentModel.h"

@implementation OrderHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (OrderHeadView *)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"OrderHeadView" owner:self options:nil] objectAtIndex:0];
}

- (void)settingView:(id)data
{
    self.backgroundColor = [UIColor clearColor];
    
    if ([data isKindOfClass:[ProductCommentModel class]] == YES)
    {
        ProductCommentModel *item = (ProductCommentModel *)data;
        self.lblOrderId.text = item.order_id;
        self.lblOrderTime.text = item.createtime;
        self.lblOrderStatus.text = @"待评价";
        self.lblOrderSeller.text = item.seller_name;
    }
    else
    {
        OrderItemModel *item = (OrderItemModel *)data;
        self.lblOrderId.text = item.order_id;
        self.lblOrderTime.text = item.createtime;
        self.lblOrderStatus.text = item.pay_status;
        self.lblOrderSeller.text = item.seller_name;
        
        // 订单实际状态：0-待付款 1-待发货 2-待签收 3-已签收 4-部分发货 5-已退货 6-部分付款 7-全额退款 8-已完成 9-已取消
        if ([item.order_type intValue] == 0)
        {
            self.lblOrderStatus.text = @"待付款";
        }
        else if (([item.order_type intValue] == 1))
        {
            self.lblOrderStatus.text = @"待发货";
        }
        else if (([item.order_type intValue] == 2))
        {
            self.lblOrderStatus.text = @"待签收";
        }
        else if (([item.order_type intValue] == 3))
        {
            self.lblOrderStatus.text = @"已签收";
        }
        else if (([item.order_type intValue] == 4))
        {
            self.lblOrderStatus.text = @"部分发货";
        }
        else if (([item.order_type intValue] == 5))
        {
            self.lblOrderStatus.text = @"已退货";
        }
        else if (([item.order_type intValue] == 6))
        {
            self.lblOrderStatus.text = @"部分付款";
        }
        else if (([item.order_type intValue] == 7))
        {
            self.lblOrderStatus.text = @"全额退款";
        }
        else if (([item.order_type intValue] == 8))
        {
            self.lblOrderStatus.text = @"已完成";
        }
        else if (([item.order_type intValue] == 9))
        {
            self.lblOrderStatus.text = @"已取消";
        }
        else
        {
            //
        }
    }
}


@end
