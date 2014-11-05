//
//  PayAndMemoView.m
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "PayAndMemoView.h"

@implementation PayAndMemoView

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

+ (PayAndMemoView *)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PayAndMemoView" owner:nil options:nil] objectAtIndex:0];
}

- (void)settingView:(id)data
{
    UIImage *imgCell = [UIImage imageNamed:@"bg_cell"];
    imgCell = [imgCell resizableImageWithCapInsets:UIEdgeInsetsMake(6, 2, 6, 2)];
    self.imgviewPay.image = imgCell;
    self.imgviewMemo.image = imgCell;
    self.imgviewMoney.image = imgCell;
    
    [self.btnPay setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg_press"] forState:UIControlStateHighlighted];
    [self.btnPay setBackgroundImage:[UIImage imageNamed:@"btn_Cell_bg"] forState:UIControlStateNormal];
    
    UIImage *img = [UIImage imageNamed:@"btn_memo"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(8, 16, 8, 16)];
    self.imgviewTxt.image = img;
    
    self.txtviewMemo.returnKeyType = UIReturnKeyDone;
}

- (IBAction)paymentBtnTouched:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectPayment)] == YES)
    {
        [self.delegate selectPayment];
    }
}

- (void)hideKeyBoard
{
    [_txtviewMemo resignFirstResponder];
}


#pragma mark - UITextViewDelegate
//
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.lblTip.hidden = YES;
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (_txtviewMemo.text == nil
        || [_txtviewMemo.text isEqualToString:@""] == YES
        || _txtviewMemo.text.length == 0)
    {
        _lblTip.hidden = NO;
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(saveMemoContent)] == YES)
    {
        [self.delegate saveMemoContent];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""])
    {
        return YES;
    }
    
    NSUInteger length = text.length;
    if (range.length != 1 && [text isEqualToString:@"\n"] == YES)
    {
        // hide keyboard
        [self hideKeyBoard];
        return NO;
    }
    else if (range.location + length >= 200)
    {
        //[self toast:@"最大输入长度500个字符"];
        // 使用通知
        return NO;
    }
    else
    {
        return YES;
    }
}


@end
