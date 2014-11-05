//
//  SettingBtnCell.m
//  KKMYForU
//
//  Created by 黄磊 on 13-11-20.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//

#import "SettingBtnCell.h"

@interface SettingBtnCell ()

@property (nonatomic, strong) NSString *keyForCell;

@end

@implementation SettingBtnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = (SettingBtnCell *)[[[NSBundle mainBundle] loadNibNamed:@"SettingBtnCell"
                                                            owner:self
                                                          options:nil] objectAtIndex:0];
    if (self)
    {
        // Initialization code
        //        [self setBackgroundColor:[UIColor blackColor]];
        [self SettingBtnCell];
    }
    return self;
}

- (void)SettingBtnCell
{
    [self.lblTitle setTextColor:[UIColor colorFromHexRGB:@"3b3b3b"]];
    [self.lblRight setTextColor:[UIColor colorFromHexRGB:@"777777"]];
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
    
    CGRect rightRect = _lblRight.frame;
    rightRect.origin.x = rightRect.origin.x + 10;
    [_lblRight setFrame:rightRect];
    
    CGRect imageRect = _imgviewRight.frame;
    imageRect.origin.x = imageRect.origin.x + 10;
    [_imgviewRight setFrame:imageRect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (_delegate && [_delegate respondsToSelector:@selector(clickCellWithKey:)]) {
//        [_delegate clickCellWithKey:_keyForCell];
    }
    // Configure the view for the selected state
}

- (void)configWithData:(id)data
{
    NSDictionary *aDic = (NSDictionary *)data;
    [_lblTitle setText:[aDic objectForKey:@"cellTitle"]];
    NSString *subTitle = [aDic objectForKey:@"subTitleUpdate"];
    if (subTitle == nil)
    {
        subTitle = [aDic objectForKey:@"subTitle"];
    }
    [_lblRight setText:subTitle];
    // 设置是否可点击
    if ([aDic objectForKey:@"disable"] && [[aDic objectForKey:@"disable"] boolValue] == NO)
    {
        [self setUserInteractionEnabled:YES];
        [_imgviewRight setHidden:NO];
    }
    else
    {
        [self setUserInteractionEnabled:NO];
        [_imgviewRight setHidden:YES];
    }
    
    _keyForCell = [aDic objectForKey:@"keyForCell"];
    
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
