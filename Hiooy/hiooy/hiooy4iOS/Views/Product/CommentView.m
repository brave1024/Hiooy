//
//  CommentView.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "CommentView.h"
#import "CommentTypeModel.h"

@implementation CommentView

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

+ (CommentView *)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:self options:nil] objectAtIndex:0];
}

- (void)settingView:(id)data
{
    CommentTypeModel *comment = (CommentTypeModel *)data;
    self.lblTitle.text = comment.name;
    //self.star.curStar = [comment.is_total_point intValue]*2;
    self.star.curStar = 0;  // 默认无星
}


@end
