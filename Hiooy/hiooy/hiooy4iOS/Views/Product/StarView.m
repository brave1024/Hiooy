//
//  StarView.m
//  KKMYForU
//
//  Created by 黄磊 on 13-11-15.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//

#import "StarView.h"

#define GapBetweenStars 8  // 间隔

@interface StarView ()


@property (nonatomic, strong) NSArray *buttonArray;

@end

@implementation StarView

#define kStarColor @"star_color"      // star_05
#define kStarNoneColor @"star_none"  // star_06

@synthesize curStar = _curStar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _type = 0;
        [self configeSelf];
    }
    return self;
}

- (void)awakeFromNib
{
    _type = self.tag;
    [self configeSelf];
}

- (void)configeSelf
{
    [self setBackgroundColor:[UIColor clearColor]];
    // 初始化5个星星
    _gapBetweenStars = GapBetweenStars;
    UIImage *imageNormal = [UIImage imageNamed:@"star_01"];
    UIImage *imageHalf = nil;
    switch (_type)
    {
        case 2: // 黄黑
            imageNormal = [UIImage imageNamed:@"star_04"];
            imageHalf = [UIImage imageNamed:@"star_07"];
            break;
        case 1: // 黄白
            imageHalf = [UIImage imageNamed:@"star_02"];
            break;
        case 0: // 可点击,黄白
            imageNormal = [UIImage imageNamed:kStarNoneColor];
            break;
        default:
            break;
    }
    
    UIImage *imageActive = nil;
    if (_type == 0)
    {
        imageActive = [UIImage imageNamed:kStarColor];
    }
    else
    {
        imageActive = [UIImage imageNamed:@"star_03"];
    }
    
    NSMutableArray *aButtonArray = [[NSMutableArray alloc] init];
    CGRect rect = self.bounds;
    //    rect.size.width = 16;
    //    rect.size.height = 16;
    float height = rect.size.height;
    rect.size.width = height;
    CGRect buttonRect = rect;
    for (int i = 0; i < 5; i ++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:buttonRect];
        [button setImage:imageNormal forState:UIControlStateNormal];
        [button setImage:imageHalf forState:UIControlStateHighlighted];
        [button setImage:imageActive forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [aButtonArray addObject:button];
        [self addSubview:button];
        buttonRect.origin.x += (height + _gapBetweenStars);
    }
    _buttonArray = [NSArray arrayWithArray:aButtonArray];
    if (_type >= 1)
    {
        [self setUserInteractionEnabled:NO];
    }
    
}

- (void)setCurStar:(int)curStar
{
    if (curStar < 0 || curStar > 10)
    {
        LogError(@"starNum 不再可接受范围: %d", curStar);
        return;
    }
    if (_curStar == curStar) {
        return;
    }
    int isHalf = curStar % 2;
    int curIndex = _curStar / 2;
    int newIndex = curStar / 2;
    if (_curStar < curStar)
    {
        for (int i = curIndex; i < newIndex; i++)
        {
            UIButton *button = [_buttonArray objectAtIndex:i];
            [button setHighlighted:NO];
            [button setSelected:YES];
        }
    }
    else if (_curStar > curStar)
    {
        for (int i = curIndex - 1; i >= newIndex; i--)
        {
            UIButton *button = [_buttonArray objectAtIndex:i];
            [button setHighlighted:NO];
            [button setSelected:NO];
        }
    }
    if (_type >= 1)
    {
        if (isHalf)
        {
            UIButton *button = [_buttonArray objectAtIndex:newIndex];
            [button setSelected:NO];
            [button setHighlighted:YES];
        }
    }
    _curStar = curStar;
}

- (void)setType:(NSInteger)type
{
    if (_type != type)
    {
        UIImage *imageHalf = nil;
        UIImage *imageNormal = nil;
        UIImage *imageActive = nil;
        if (type == 0)
        {
            imageActive = [UIImage imageNamed:kStarColor];
            imageNormal = [UIImage imageNamed:kStarNoneColor];
            [self setUserInteractionEnabled:YES];
        }
        else if (type == 1)
        {
            imageActive = [UIImage imageNamed:@"star_03"];
            imageHalf = [UIImage imageNamed:@"star_02"];
            imageNormal = [UIImage imageNamed:@"star_06"];
            [self setUserInteractionEnabled:NO];
        }
        else if (type == 2)
        {
            imageActive = [UIImage imageNamed:@"star_03"];
            imageNormal = [UIImage imageNamed:@"star_04"];
            imageHalf = [UIImage imageNamed:@"star_07"];
        }
        else
        {
            return;
        }
        for (UIButton *button in _buttonArray)
        {
            [button setImage:imageNormal forState:UIControlStateNormal];
            [button setImage:imageHalf forState:UIControlStateHighlighted];
            [button setImage:imageActive forState:UIControlStateSelected];
        }
        _type = type;
    }
}

- (void)setGapBetweenStars:(int)gapBetweenStars
{
    CGRect buttonRect = [[_buttonArray objectAtIndex:0] frame];
    CGFloat width = buttonRect.size.width;
    _gapBetweenStars = gapBetweenStars;
    buttonRect.origin.x += (width + _gapBetweenStars);
    for (int i = 1; i < 5; i ++)
    {
        UIButton *button = [_buttonArray objectAtIndex:i];
        [button setFrame:buttonRect];
        buttonRect.origin.x += (width + _gapBetweenStars);
    }
    [self setNeedsDisplay];
}

- (void)setButtonEnabled:(BOOL)enabled
{
    for (UIButton *btn in _buttonArray)
    {
        btn.enabled = enabled;
    }
}


#pragma mark - Action

- (void)buttonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self setCurStar:2 * (button.tag + 1)];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
