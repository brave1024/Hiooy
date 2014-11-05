//
//  AddressView.m
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "AddressView.h"

@implementation AddressView

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

+ (AddressView *)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"AddressView" owner:nil options:nil] objectAtIndex:0];
}

- (void)settingView:(id)data
{
    self.lblTip.hidden = YES;
    
    self.imgviewPic.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"addr_topbg"]];
    
    [self.btnAddr setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg_press"] forState:UIControlStateHighlighted];
    [self.btnAddr setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg"] forState:UIControlStateNormal];
}

- (IBAction)addressBtnTouched:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectAddress)] == YES)
    {
        [self.delegate selectAddress];
    }
}


@end
