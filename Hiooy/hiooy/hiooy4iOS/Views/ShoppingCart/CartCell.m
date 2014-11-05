//
//  CartCell.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-27.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "CartCell.h"
#import "CartGoodsModel.h"

@implementation CartCell
@synthesize delegate;

#define kBtnTag 100

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

+ (CartCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CartCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)cellData withStatus:(NSString *)status
{
    // 注册隐藏键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard) name:kHideKeyboardInCart object:nil];
    // 注册隐藏其它cell中键盘的通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardOther:) name:kHideKeyboardInOtherCells object:nil];
    
    CartGoodsModel *goods = (CartGoodsModel *)cellData;
    //self.goodsId = goods.goods_id;
    [self.imgviewPic setImageWithURL:[NSURL URLWithString:goods.image_url] placeholderImage:[UIImage imageNamed:kImageNameDefault]];
    self.lblTitle.text = goods.name;
    self.lblPrice.text = [NSString stringWithFormat:@"¥ %.2f", [goods.price floatValue]];
    self.lblNumber.text = goods.quantity;
    self.lblType.hidden = YES;
    self.txtfieldNumber.text = [NSString stringWithFormat:@"%d", [goods.quantity intValue]];
     // 设置
    [self.btnSelect setImage:[UIImage imageNamed:@"radioUnselect"] forState:UIControlStateNormal];
    [self.btnSelect setImage:[UIImage imageNamed:@"radioSelect"] forState:UIControlStateSelected];
    if ([goods.selected isEqualToString:@"true"] == YES)
    {
        self.btnSelect.selected = YES;
    }
    else
    {
        self.btnSelect.selected = NO;
    }
    if (status == nil || [status isEqualToString:@""] == YES)
    {
        // 默认为未展示
        self.viewContent.hidden = NO;
        self.viewEdit.hidden = YES;
    }
    else
    {
        if ([status isEqualToString:@"YES"] == YES)
        {
            self.viewContent.hidden = YES;
            self.viewEdit.hidden = NO;
        }
        else
        {
            self.viewContent.hidden = NO;
            self.viewEdit.hidden = YES;
        }
    }
}

- (IBAction)btnTouch:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = (int)(btn.tag);
    if (tag == kBtnTag)             // 选中
    {
        if (delegate != nil && [delegate respondsToSelector:@selector(cartSelectButtonTouched:withButtonTag:)] == YES)
        {
            [delegate cartSelectButtonTouched:self withButtonTag:tag];
        }
    }
    else if (tag == kBtnTag+1)      // 删除
    {
        if (delegate != nil && [delegate respondsToSelector:@selector(cartDeleteButtonTouched:withButtonTag:)] == YES)
        {
            [delegate cartDeleteButtonTouched:self withButtonTag:tag];
        }
    }
}

- (void)hideKeyboard
{
    [self.txtfieldNumber resignFirstResponder];
}

//- (void)hideKeyboardOther:(NSNotification *)notification
//{
//    NSString *nid = (NSString *)notification.object;
//    if ([nid isEqualToString:self.goodsId] == YES)
//    {
//        self.isEditting = YES;
//        [self.txtfieldNumber becomeFirstResponder];
//    }
//    else
//    {
//        [self.txtfieldNumber resignFirstResponder];
//    }
//}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (self.isEditting == YES)
//    {
//        //
//    }
//    else
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kHideKeyboardInOtherCells object:self.goodsId];
//    }
    if (delegate != nil && [delegate respondsToSelector:@selector(cartCellBeginEdit:)] == YES)
    {
        [delegate cartCellBeginEdit:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //self.isEditting = NO;
    if (delegate != nil && [delegate respondsToSelector:@selector(cartCellEndEdit:)] == YES)
    {
        [delegate cartCellEndEdit:self];
    }
    return YES;
}


@end
