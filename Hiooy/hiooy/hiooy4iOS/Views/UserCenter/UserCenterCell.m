//
//  UserCenterCell.m
//  KKMYForU
//
//  Created by 黄磊 on 13-11-20.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//

#import "UserCenterCell.h"

@implementation UserCenterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = (UserCenterCell *)[[[NSBundle mainBundle] loadNibNamed:@"UserCenterCell"
                                                            owner:self
                                                          options:nil] objectAtIndex:0];
    if (self)
    {
        // Initialization code
        //        [self setBackgroundColor:[UIColor blackColor]];
        [self settingCell];
    }
    return self;
}

- (void)settingCell
{
    [self.lblTitle setTextColor:[UIColor colorFromHexRGB:@"3b3b3b"]];
    [self.lblNew setTextColor:[UIColor colorFromHexRGB:@"777777"]];
    if (__CUR_IOS_VERSION < __IPHONE_7_0)
    {
        [self resizeSubView];
    }
}

// 低于iOS7的系统需调此方法调整视图大小
- (void)resizeSubView
{
    CGRect titleRect = _lblTitle.frame;
    titleRect.origin.x = titleRect.origin.x - 5;
    [_lblTitle setFrame:titleRect];
    
    CGRect rightRect = _lblNew.frame;
    rightRect.origin.x = rightRect.origin.x + 10;
    [_lblNew setFrame:rightRect];
    
    CGRect imageRect = _imgviewNew.frame;
    imageRect.origin.x = imageRect.origin.x + 10;
    [_imgviewNew setFrame:imageRect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configWithData:(id)data
{
    NSDictionary *aDic = (NSDictionary *)data;
    [_lblTitle setText:[aDic objectForKey:@"cellTitle"]];
    
    // 设置是否可点击
    if ([aDic objectForKey:@"disable"] && [[aDic objectForKey:@"disable"] boolValue] == NO)
    {
        [self setUserInteractionEnabled:YES];
        [_imgviewNew setHidden:NO];
    }
    else
    {
        [self setUserInteractionEnabled:NO];
        [_imgviewNew setHidden:YES];
    }
    
    NSString *imgIconNormal = [aDic objectForKey:@"normalIcon"];
    [_imgviewIcon setImage:[UIImage imageNamed:imgIconNormal]];
    
    self.viewNew.hidden = YES;    // 默认是隐藏
    UIImage *img = [UIImage imageNamed:@"ico_number"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(7, 8, 7, 8)];
    self.imgviewNew.image = img;
    
    // 判断是否需要显示右边附加视图
    NSString *strNum = [aDic objectForKey:@"subTitle"];
    if (strNum)
    {
        self.lblNew.text = strNum;
        self.viewNew.hidden = NO;
        self.lblNew.textColor = [UIColor whiteColor];

    }
    
//    // 设置是否是new
//    if ([aDic objectForKey:@"isNew"] && [[aDic objectForKey:@"isNew"] boolValue] == YES)
//    {
//        CGRect imgRect = _imgviewNew.frame;
//        CGRect titleRect = _lblTitle.frame;
//        CGSize size = textSizeWithFont(_lblTitle.text, _lblTitle.font);
//        imgRect.origin.x = titleRect.origin.x + size.width + 10;
//        [_imgviewNew setFrame:imgRect];
//        [_imgviewNew setHidden:NO];
//    }
//    else
//    {
//        [_imgviewNew setHidden:YES];
//    }
    
    
}

@end
