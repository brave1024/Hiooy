//
//  AddrInfoCell.m
//  hiooy
//
//  Created by 黄磊 on 14-3-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "AddrInfoCell.h"
//#import "AddrInfoModel.h"
#import "AddressModel.h"

@interface AddrInfoCell ()

@property (nonatomic, assign) BOOL isDefault;

@end

@implementation AddrInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = (AddrInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"AddrInfoCell"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    self.viewTop.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)235/255 blue:(CGFloat)242/255 alpha:1];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithData:(id)data
{
    AddressModel *addrInfo = (AddressModel *)data;
    if (addrInfo.is_default && [addrInfo.is_default boolValue])
    {
        [_btnDefault setImage:[UIImage imageNamed:@"radioSelect"] forState:UIControlStateNormal];
        _isDefault = YES;
    }
    else
    {
        [_btnDefault setImage:[UIImage imageNamed:@"radioUnselect"] forState:UIControlStateNormal];
        _isDefault = NO;
    }
    [_lblRegion setText:addrInfo.area];
    [_lblAddr setText:addrInfo.addr];
    //[_lblUser setText:[NSString stringWithFormat:@"%@ %@", addrInfo.name, addrInfo.tel]];
    [_lblUser setText:addrInfo.name];
    [_lblMobile setText:addrInfo.phone.mobile];
    [_lblTel setText:addrInfo.phone.tel];
//    if (addrInfo.phone == nil || addrInfo.phone.mobile == nil || [addrInfo.phone.mobile isEqualToString:@""] == YES)
//    {
//        [_lblMobile setText:@""];
//    }
//    else
//    {
//        [_lblMobile setText:addrInfo.phone.mobile];
//    }
//    if (addrInfo.phone == nil || addrInfo.phone.tel == nil || [addrInfo.phone.tel isEqualToString:@""] == YES)
//    {
//        [_lblTel setText:@""];
//    }
//    else
//    {
//        [_lblTel setText:addrInfo.phone.tel];
//    }
}

- (IBAction)setDefault:(id)sender {
    if (!_isDefault) {
        if ([_delegate respondsToSelector:@selector(setDefaultCellAtIndex:)]) {
            [_delegate setDefaultCellAtIndex:_cellIndex];
        }
    }
}

- (IBAction)editAddr:(id)sender {
    if ([_delegate respondsToSelector:@selector(editCellAtIndex:)]) {
        [_delegate editCellAtIndex:_cellIndex];
    }
}

- (IBAction)deleteAddr:(id)sender {
    if ([_delegate respondsToSelector:@selector(deleteCellAtIndex:)]) {
        [_delegate deleteCellAtIndex:_cellIndex];
    }
}


@end
