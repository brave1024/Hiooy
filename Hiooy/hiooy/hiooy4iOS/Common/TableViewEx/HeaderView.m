//
//  HeaderView.m
//  WorldAngle
//
//  Created by Xia Zhiyong on 14-4-5.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView


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

+ (HeaderView *)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:nil options:nil] objectAtIndex:0];
}

- (void)settingHeaderView
{
    //
    [self.btnShow setImage:[UIImage imageNamed:@"down_msg"] forState:UIControlStateNormal];
    [self.btnShow setImage:[UIImage imageNamed:@"up_msg"] forState:UIControlStateSelected];
    self.btnShow.selected = NO;

    
}

- (void)settingViewWithStatus:(BOOL)open andSection:(int)sIndex
{
    if (open)
    {
        self.btnShow.selected = YES;
    }
    else
    {
        self.btnShow.selected = NO;
    }
    
    self.section = sIndex;
}

- (IBAction)showOrHideContent:(id)sender
{
    [self toggleOpenWithUserAction:YES];
}


- (void)toggleOpenWithUserAction:(BOOL)userAction
{
    // Toggle the disclosure button state.
    self.btnShow.selected = !self.btnShow.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction)
    {
        if (self.btnShow.selected)
        {
            if ([self.delegate_ respondsToSelector:@selector(sectionHeaderView:sectionOpened:)])
            {
                [self.delegate_ sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else
        {
            if ([self.delegate_ respondsToSelector:@selector(sectionHeaderView:sectionClosed:)])
            {
                [self.delegate_ sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}


@end
