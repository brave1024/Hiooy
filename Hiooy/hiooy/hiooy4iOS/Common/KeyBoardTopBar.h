//
//  KeyBoardTopBar.h
//  MarkTravel
//
//  Created by Xia Zhiyong on 13-10-1.
//  Copyright (c) 2013年 ags. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol KeyBoardTopBarDelegate <NSObject>
//- (void)keyboardHideEvent;
//@end

@interface KeyBoardTopBar : NSObject {
    
    UIToolbar       *view;                       //工具条
    NSArray         *textFields;                 //输入框数组
    BOOL            allowShowPreAndNext;         //是否显示上一项、下一项
    BOOL            isInNavigationController;    //是否在导航视图中
    UIBarButtonItem *prevButtonItem;             //上一项按钮
    UIBarButtonItem *nextButtonItem;             //下一项按钮
    UIBarButtonItem *hiddenButtonItem;           //隐藏按钮
    UIBarButtonItem *spaceButtonItem;            //空白按钮
    UITextField     *currentTextField;           //当前输入框
    //float           keyboardHeight;              //键盘高度
    
}


@property (nonatomic,retain) UIToolbar *view;

- (id)init;
- (void)setAllowShowPreAndNext:(BOOL)isShow;
- (void)setIsInNavigationController:(BOOL)isbool;
- (void)setTextFieldsArray:(NSArray *)array;
- (void)ShowPrevious;
- (void)ShowNext;
- (void)showBar:(UITextField *)textField;
- (void)HiddenKeyBoard;

@end