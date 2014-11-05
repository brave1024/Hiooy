//
//  CommentProductViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "CommentProductViewController.h"
#import "CommentView.h"

@interface CommentProductViewController ()
@property CGRect viewRect;
@end

@implementation CommentProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"评价商品";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.scrollview.backgroundColor = [UIColor clearColor];
    
    UIImage *img = [UIImage imageNamed:@"input_bg"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    self.imgviewBg.image = img;
    
    UIImage *img_ = [UIImage imageNamed:@"btn_red"];
    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnSubmit setBackgroundImage:img_ forState:UIControlStateNormal];
    
    self.lblSeller.text = self.product.seller_name;
    self.lblTime.text = self.product.createtime;
    
    [self.btnNoName setImage:[UIImage imageNamed:@"radioUnselect.png"] forState:UIControlStateNormal];
    [self.btnNoName setImage:[UIImage imageNamed:@"radioSelect.png"] forState:UIControlStateSelected];
    self.btnNoName.selected = NO;
    
    self.viewRect = self.scrollview.frame;
    
    [self requestProductInfoForComment];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 请求待评价商品界面数据
- (void)requestProductInfoForComment
{
    [self startLoading:kLoading];
    
    [InterfaceManager userCommentProduct:self.product.product_id withOrder:self.product.order_id completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSLog(@"获取待收货订单成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            self.goodsItem = [[CommentGoodsInfoModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            else
            {
                NSLog(@"order count:%d", self.goodsItem.comment_goods_type.count);
                if (self.goodsItem.comment_goods_type == nil || self.goodsItem.comment_goods_type.count == 0)
                {
                    //
                    return;
                }
                [self showCommentData];
            }
        }
        else
        {
            [self toast:message];
            NSLog(@"%@", message);
        }
    }];
}

- (IBAction)hideUserName:(id)sender
{
//    if (self.btnNoName.selected == YES)
//    {
//        self.btnNoName.selected = NO;
//    }
//    else
//    {
//        self.btnNoName.selected = YES;
//    }
    self.btnNoName.selected = !self.btnNoName.selected;
}

// 提交商品评价内容
- (IBAction)submitComment:(id)sender
{
    [self.txtviewContent resignFirstResponder];
    
    if ([TextVerifyHelper checkContent:self.txtviewContent.text] == NO)
    {
        [self toast:@"评价内容不能为空"];
        return;
    }
    
    // 需打星星评分
    if ([self checkStarNumber] == NO)
    {
        [self toast:@"请评星级"];
        return;
    }
    
    [self startLoading:kLoading];
    
    CommentSubmitModel *submit = [[CommentSubmitModel alloc] init];
    submit.member_id = [[UserManager shareInstant] getMemberId];
    submit.comment = self.txtviewContent.text;
    submit.goods_id = self.product.goods_id;
    submit.product_id = self.product.product_id;
    submit.order_id = self.product.order_id;
    submit.contact = nil;
    // 是否匿名
    if (self.btnNoName.selected == YES)
    {
        submit.hidden_name = @"YES";
    }
    else
    {
        submit.hidden_name = nil;
    }
    // 星级
    // "point_type":{"1":{"point":"5"},"2":{"point":"3"},"3":{"point":"4"}}
    submit.point_type = [self createPointString];
    NSLog(@"point:%@", submit.point_type);
    
    /*
    {
        "status": "success",
        "msg": "",
        "data": "感谢您的分享,管理员审核后会自动显示!"
    }
    */
    [InterfaceManager submitProductComment:submit completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed)
        {
            NSString *str = [(NSDictionary *)data objectForKey:@"data"];
            if (str == nil || [str isEqualToString:@""] == YES)
            {
                [self toast:message];
            }
            else
            {
                [self toast:str];
            }
            // 刷新待评价商品列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProductComment object:nil];
            // 刷新个人中心数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserCenter object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self toast:message];
        }
    }];
    
}

- (BOOL)checkStarNumber
{
    BOOL hasAllStar = YES;
    for (int i = 0; i < self.goodsItem.comment_goods_type.count; i++)
    {
        NSArray *arrView = [self.viewScore subviews];
        CommentView *commentView = nil;
        for (UIView *view in arrView)
        {
            if ([view isKindOfClass:[CommentView class]] == YES)
            {
                if (view.tag == i)
                {
                    commentView = (CommentView *)view;
                }
            }
        }
        int score = commentView.star.curStar / 2;
        if (score == 0)
        {
            hasAllStar = NO;
            break;
        }
    }
    
    return hasAllStar;
}

- (NSString *)createPointString
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < self.goodsItem.comment_goods_type.count; i++)
    {
        CommentTypeModel *comment = [self.goodsItem.comment_goods_type objectAtIndex:i];
        
        NSArray *arrView = [self.viewScore subviews];
        CommentView *commentView = nil;
        for (UIView *view in arrView)
        {
            if ([view isKindOfClass:[CommentView class]] == YES)
            {
                if (view.tag == i)
                {
                    commentView = (CommentView *)view;
                }
            }
        }
        
        int score = commentView.star.curStar / 2;
        NSDictionary *myDic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", score] forKey:@"point"];
        
        [dic setObject:myDic forKey:comment.type_id];
    }
    NSDictionary *finalDic = [NSDictionary dictionaryWithObject:dic forKey:@"point_type"];
    return [finalDic convertToJsonString];
}

- (void)showCommentData
{
    int count = self.goodsItem.comment_goods_type.count;
    CGFloat myHeight = 42*count;
    
    self.viewScore.frame = CGRectMake(0, 10+116, 320, myHeight+10);
    [self.scrollview addSubview:self.viewScore];
    
    for (int i = 0; i < count; i++)
    {
        CommentView *view = [CommentView viewFromNib];
        view.frame = CGRectMake(0, 42*i, 320, 42);
        view.tag = i;
        [view settingView:[self.goodsItem.comment_goods_type objectAtIndex:i]];
        [self.viewScore addSubview:view];
    }
    
    self.viewSubmit.frame = CGRectMake(0, self.viewScore.frame.origin.y + self.viewScore.frame.size.height, 320, 228);
    [self.scrollview addSubview:self.viewSubmit];
    
    //
    [self.imgviewPic setImageWithURL:[NSURL URLWithString:self.goodsItem.goods_info.image_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        //
    }];
    self.lblName.text = self.goodsItem.goods_info.name;
    
    self.scrollview.contentSize = CGSizeMake(320, self.viewSubmit.frame.origin.y + self.viewSubmit.frame.size.height + 10);
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.lblTip.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *str = textView.text;
    if (str == nil || [str isEqualToString:@""] == YES)
    {
        self.lblTip.hidden = NO;
    }
    else
    {
        self.lblTip.hidden = YES;
    }
    
    if (textView.text != nil && textView.text.length > kMaxLength)
    {
        textView.text = [textView.text substringToIndex:kMaxLength];
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//
//    if (range.length != 1 && [text isEqualToString:@"\n"] == YES)
//    {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
//
//}

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
        [textView resignFirstResponder];
        return NO;
    }
    else if (range.location + length >= kMaxLength)
    {
        [self toast:@"最大输入长度140个字符"];
        return NO;
    }
    else
    {
        return YES;
    }
}


#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillShow");
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height; // 获取键盘高度
    //NSLog(@"<keyboardHeight:%f>",keyboardHeight);
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;   // 键盘动画时间
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat scrollHeight = kScreenHeight - 64 - keyboardHeight;
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        CGRect myRect = _viewRect;
        myRect.size.height = scrollHeight;
        self.scrollview.frame = myRect;
        [self.scrollview scrollRectToVisible:CGRectMake(0, self.viewSubmit.frame.origin.y, 320, 120) animated:YES];
    } completion:^(BOOL finished) {
        //
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillHide");
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        //CGRect rect = CGRectMake(0, 0, 320, 271);
        self.scrollview.frame = self.viewRect;
    } completion:^(BOOL finished) {
        //
    }];
    
}




@end
