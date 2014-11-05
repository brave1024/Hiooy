//
//  OrderFootView.m
//  hiooy
//
//  Created by retain on 14-5-7.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "OrderFootView.h"
#import "OrderItemModel.h"
#import "ProductCommentModel.h"

@implementation OrderFootView

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

+ (OrderFootView *)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"OrderFootView" owner:self options:nil] objectAtIndex:0];
}

- (void)settingView:(id)data
{
    self.backgroundColor = [UIColor clearColor];
    
    self.viewLine.frame = CGRectMake(0, 0, 300, 0.5);
    self.viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)217/255 green:(CGFloat)216/255 blue:(CGFloat)219/255 alpha:1];
    
    //self.imgviewBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flower_bg"]];
    
//    UIImage *img = [UIImage imageNamed:@"btn_red"];
//    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    UIImage *img = [UIImage imageNamed:@"red_btn"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(6, 2, 6, 2)];
    [self.btnReceive setBackgroundImage:img forState:UIControlStateNormal];
    
    UIImage *img_ = [UIImage imageNamed:@"grey_btn"];
    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(6, 2, 6, 2)];
    
    if ([data isKindOfClass:[ProductCommentModel class]] == YES)
    {
        ProductCommentModel *item = (ProductCommentModel *)data;
        CGFloat total = [item.price floatValue] * [item.number intValue];
        self.lblMoney.text = [NSString stringWithFormat:@"%.2f 元", total];
        
        [self.btnReceive setTitle:@"去评价" forState:UIControlStateNormal];
        self.btnReceive.hidden = NO;
    }
    else
    {
        // 订单实际状态：0-待付款 1-待发货 2-待签收 3-已签收 4-部分发货 5-已退货 6-部分付款 7-全额退款 8-已完成 9-已取消
        OrderItemModel *item = (OrderItemModel *)data;
        self.lblMoney.text = [NSString stringWithFormat:@"%.2f 元", [item.final_amount floatValue]];
        if ([item.order_type intValue] == 0)
        {
            [self.btnReceive setTitle:@"去结算" forState:UIControlStateNormal];
            [self.btnReceive setBackgroundImage:img forState:UIControlStateNormal];
            self.btnReceive.hidden = NO;
            self.btnReceive.enabled = YES;
        }
        else if (([item.order_type intValue] == 1))
        {
            // 暂无提醒商家发货接口
            self.btnReceive.hidden = NO;
            self.btnReceive.enabled = NO;
            [self.btnReceive setTitle:@"等待商家发货" forState:UIControlStateNormal];
            [self.btnReceive setBackgroundImage:img_ forState:UIControlStateNormal];
        }
        else if (([item.order_type intValue] == 2))
        {
            [self.btnReceive setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.btnReceive setBackgroundImage:img forState:UIControlStateNormal];
            self.btnReceive.hidden = NO;
            self.btnReceive.enabled = YES;
        }
        else if (([item.order_type intValue] == 3))
        {
            self.btnReceive.hidden = NO;
            self.btnReceive.enabled = NO;
            [self.btnReceive setTitle:@"已签收" forState:UIControlStateNormal];
            [self.btnReceive setBackgroundImage:img_ forState:UIControlStateNormal];
        }
//        else if (([item.order_type intValue] == 4))
//        {
//            
//        }
//        else if (([item.order_type intValue] == 5))
//        {
//            
//        }
//        else if (([item.order_type intValue] == 6))
//        {
//            
//        }
//        else if (([item.order_type intValue] == 7))
//        {
//            
//        }
//        else if (([item.order_type intValue] == 8))
//        {
//            
//        }
//        else if (([item.order_type intValue] == 9))
//        {
//            
//        }
        else
        {
            self.btnReceive.hidden = YES;
        }
    }
}

- (IBAction)btnReceiveProductsAction:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(confirmReceiveProducts:)] == YES)
    {
        [self.delegate confirmReceiveProducts:self];
    }
}


@end
