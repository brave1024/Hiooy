//
//  RechargeView.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-27.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "RechargeView.h"
#import "CartResponsePaymentModel.h"

@implementation RechargeView

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

+ (RechargeView *)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"RechargeView" owner:self options:nil] objectAtIndex:0];
}

- (void)settingView:(id)data
{
    [self.btnSelect setImage:[UIImage imageNamed:@"radioUnselect"] forState:UIControlStateNormal];
    [self.btnSelect setImage:[UIImage imageNamed:@"radioSelect"] forState:UIControlStateSelected];
    
    CartResponsePaymentModel *pay = (CartResponsePaymentModel *)data;
    if ([pay.choosed isEqualToString:@"true"])
    {
        self.btnSelect.selected = YES;
    }
    else
    {
        self.btnSelect.selected = NO;
    }
    
    self.lblTitle.text = pay.app_name;
}

- (IBAction)selectRechargeMethod:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(payMethodSelected:)] == YES) {
        [self.delegate payMethodSelected:self.tag-100];
    }
}


@end
