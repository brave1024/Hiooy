//
//  KeyBoardTopBar.m
//  MarkTravel
//
//  Created by Xia Zhiyong on 13-10-1.
//  Copyright (c) 2013年 ags. All rights reserved.
//

#import "KeyBoardTopBar.h"

@implementation KeyBoardTopBar
@synthesize view;

//初始化控件和变量
- (id)init {
    
    if(self = [super init]) {
        
        prevButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"前一项" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowPrevious)];
        nextButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"后一项" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowNext)];
        hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(HiddenKeyBoard)];
        spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        view = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, 320, 44)];
        //view.barStyle = UIBarStyleBlackTranslucent;
        view.barStyle = UIBarStyleDefault;
        view.items = [NSArray arrayWithObjects:prevButtonItem,nextButtonItem,spaceButtonItem,hiddenButtonItem,nil];
        allowShowPreAndNext = YES;
        textFields = nil;
        isInNavigationController = YES;
        currentTextField = nil;
        //keyboardHeight = 216;   // 动态变化...
        
    }
    
    return self;
    
}

//设置是否在导航视图中
- (void)setIsInNavigationController:(BOOL)isbool {
    
    isInNavigationController = isbool;
    
}

//显示上一项
- (void)ShowPrevious {
    
    if(textFields == nil) {
        return;
    }
    
    NSInteger num = -1;
    for(NSInteger i = 0; i < [textFields count]; i++) {
        if ([textFields objectAtIndex:i] == currentTextField) {
            num = i;
            break;
        }
    }
    if(num > 0) {
        //[[textFields objectAtIndex:num] resignFirstResponder];
        [[textFields objectAtIndex:num-1 ] becomeFirstResponder];
        [self showBar:[textFields objectAtIndex:num-1]];
    }
    
}

//显示下一项
- (void)ShowNext {
    
    if(textFields == nil) {
        return;
    }
    
    NSInteger num = -1;
    for(NSInteger i = 0; i < [textFields count]; i++) {
        if ([textFields objectAtIndex:i] == currentTextField) {
            num = i;
            break;
        }
    }
    if(num < [textFields count] - 1) {
        //[[textFields objectAtIndex:num] resignFirstResponder];
        [[textFields objectAtIndex:num+1] becomeFirstResponder];
        [self showBar:[textFields objectAtIndex:num+1]];
    }
    
}

//显示工具条
- (void)showBar:(UITextField *)textField {
    
    currentTextField = textField;
    
    if(allowShowPreAndNext) {
        [view setItems:[NSArray arrayWithObjects:prevButtonItem,nextButtonItem,spaceButtonItem,hiddenButtonItem,nil]];
    }else {
        [view setItems:[NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil]];
    }
    
    if(textFields == nil) {
        prevButtonItem.enabled = NO;
        nextButtonItem.enabled = NO;
    }else {
        NSInteger num = -1;
        for (NSInteger i = 0; i < [textFields count]; i++) {
            if ([textFields objectAtIndex:i] == currentTextField) {
                num = i;
                break;
            }
        }
        if (num > 0) {
            prevButtonItem.enabled = YES;
        }else {
            prevButtonItem.enabled = NO;
        }
        if (num < [textFields count] - 1) {
            nextButtonItem.enabled = YES;
        }else {
            nextButtonItem.enabled = NO;
        }
    }
    
//    // toolbar的y坐标
//    float coordinate_Y = kScreenHeight - 216 - 44;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        if(isInNavigationController) {
//            view.frame = CGRectMake(0, coordinate_Y-40, 320, 44);
//        }else {
//            view.frame = CGRectMake(0, coordinate_Y, 320, 44);
//        }
//    } completion:^(BOOL finished) {
//        //
//    }];
    
}

//设置输入框数组
- (void)setTextFieldsArray:(NSArray *)array {
    
    textFields = array;

}

//设置是否显示上一项和下一项按钮
- (void)setAllowShowPreAndNext:(BOOL)isShow {
    
    allowShowPreAndNext = isShow;

}

//隐藏键盘和工具条
- (void)HiddenKeyBoard {
    
    if(currentTextField != nil) {
        [currentTextField  resignFirstResponder];
    }
    
    for (id txtView in textFields) {
        if ([txtView isKindOfClass:[UITextView class]]) {
            [(UITextView *)txtView resignFirstResponder];
        }
    }
    
//    [UIView animateWithDuration:0.3 animations:^{
//        view.frame = CGRectMake(0, kScreenHeight, 320, 44);
//    } completion:^(BOOL finished) {
//        //
//    }];
    
}


@end

