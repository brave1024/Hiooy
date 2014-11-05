//
//  ProductTypeView.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ProductTypeView.h"
#import "ProductTypeModel.h"
#import "ActivityProductModel.h"

@implementation ProductTypeView

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

+ (ProductTypeView *)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ProductTypeView" owner:self options:nil] objectAtIndex:0];
}

- (void)settingView:(id)data
{
    if ([data isKindOfClass:[ActivityProductModel class]])
    {
        ActivityProductModel *product = (ActivityProductModel *)data;
        if ([product.isSelected intValue] == 1)
        {
            UIImage *img = [UIImage imageNamed:@"frame_red"];
            img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(7, 15, 7, 15)];
            self.imgviewPic.image = img;
        }
        else
        {
            UIImage *img = [UIImage imageNamed:@"frame_gray"];
            img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(7, 15, 7, 15)];
            self.imgviewPic.image = img;
        }
        
        return;
    }
    
    ProductTypeModel *product = (ProductTypeModel *)data;
    if ([product.isSelected intValue] == 1)
    {
        UIImage *img = [UIImage imageNamed:@"frame_red"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(7, 15, 7, 15)];
        self.imgviewPic.image = img;
    }
    else
    {
        UIImage *img = [UIImage imageNamed:@"frame_gray"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(7, 15, 7, 15)];
        self.imgviewPic.image = img;
    }
}


@end
