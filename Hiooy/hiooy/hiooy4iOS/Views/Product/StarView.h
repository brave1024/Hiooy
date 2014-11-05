//
//  StarView.h
//  KKMYForU
//
//  Created by 黄磊 on 13-11-15.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView

// 当前激活的星星个数
@property (nonatomic, assign) int curStar;
// 用于设置两个星星间的间距
@property (nonatomic, assign) int gapBetweenStars;
// 控间的类型：0表示可点击的星星，没有半新；1便是只能显示的星星，可以有半心
@property (nonatomic, assign) NSInteger type;

- (void)setButtonEnabled:(BOOL)enabled;

@end
