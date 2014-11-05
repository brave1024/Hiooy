//
//  PayProductView.m
//  hiooy
//
//  Created by retain on 14-4-28.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "PayProductView.h"

@implementation PayProductView

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

+ (PayProductView *)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PayProductView" owner:self options:nil] objectAtIndex:0];
}


@end
