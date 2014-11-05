//
//  SliderViewController.m
//  hiooy
//
//  Created by 黄磊 on 14-3-17.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "SliderViewController.h"

#define VALID_ACTIVE_EDGE 0        // 激活滑动边缘宽度
#define ACTIVE_MIN_DX 15
#define ACTIVE_MAX_DY 10
#define MIN_SPEED 1
#define OFFSET_LEFT_DX 80          // 显示左边视图时，中间视图可露出的宽度
#define OFFSET_RIGHT_DX 0           // 显示右边视图时，中间视图可露出的宽度
#define ANIMATE_DURATION 0.2        // 滑动时间


@implementation UIViewController (SlideViewController)

- (SliderViewController *)sliderViewController
{
    UIViewController *viewController = self.parentViewController;
    while (!(viewController == nil || [viewController isKindOfClass:[SliderViewController class]]))
    {
        viewController = viewController.parentViewController;
    }
    
    return (SliderViewController *)viewController;
}

- (void)viewWillShow
{
    
}

@end


@interface SliderViewController ()

@property (nonatomic, assign) float curActiveEdge;

@property (nonatomic, strong) UIView *curTraceView;     // 当前需要滑动的view
@property (nonatomic, strong) UIButton *btnShader;      // centerView的遮罩
@property (nonatomic, assign) BOOL canTrace;            // 用于判断是否允许滑动
@property (nonatomic, assign) BOOL isTraceActive;       // 用于判断是否已经启动滑动

@property (nonatomic, assign) NSTimeInterval timeFirstTouch;      // centerView的遮罩

@property (nonatomic, assign) CGPoint startPoint;       // 滑动的开始位子
@property (nonatomic, assign) CGPoint prevPoint;        // 上一个点
@property (nonatomic, assign) int willSliderTo;         // 激活时的判断，1表示将想右滑，－1表示将向左滑

@property (nonatomic, strong) UIView *viewShader;

@end


@implementation SliderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.curDisplayView = kDisplayCenterView;
        _canShowRight = YES;
        _isTraceActive = NO;
        _canTrace = NO;
        _activeEdge = VALID_ACTIVE_EDGE;
    }
    return self;
}

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [self initWithNibName:NSStringFromClass([SliderViewController class]) bundle:nil];
    if (self)
    {
        NSUInteger theCount = [viewControllers count];
        if (theCount == 0)
        {
            
        }
        else if (theCount == 1)
        {
            UIViewController *theViewController = [viewControllers objectAtIndex:0];
            [self setCenterViewController:theViewController];
        }
        else
        {
            UIViewController *theLeftController = [viewControllers objectAtIndex:0];
            [self setLeftViewController:theLeftController];
            UIViewController *theCenterController = [viewControllers objectAtIndex:1];
            [self setCenterViewController:theCenterController];
            if (theCount > 2)
            {
                UIViewController *theRightController = [viewControllers objectAtIndex:2];
                [self setRightViewController:theRightController];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect theRect = self.view.bounds;
    if (_leftViewController)
    {
        [_leftViewController.view setFrame:theRect];
        [_viewLeft addSubview:_leftViewController.view];
        [self addChildViewController:_leftViewController];
    }
    
    if (_centerViewController)
    {
        [_centerViewController.view setFrame:theRect];
        [_viewCenter addSubview:_centerViewController.view];
        [self addChildViewController:_centerViewController];
    }
    if (_rightViewController)
    {
        [_rightViewController.view setFrame:theRect];
        [_viewRight insertSubview:_rightViewController.view belowSubview:_viewCenter];
        [self addChildViewController:_rightViewController];
    } else {
        _canShowRight = NO;
    }
//    _btnShader = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnShader setFrame:theRect];
//    [_btnShader setAlpha:0.0];
//    [_btnShader setHidden:YES];
//    [_btnShader setBackgroundColor:[UIColor grayColor]];
//    [_btnShader addTarget:self action:@selector(showCenterView) forControlEvents:UIControlEventTouchUpInside];
//    [_viewCenter addSubview:_btnShader];
    
    // 添加边缘遮罩
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, height)];
    [viewLeft setBackgroundColor:[UIColor clearColor]];
    UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(width - 10, 0, 10, height)];
    [viewRight setBackgroundColor:[UIColor clearColor]];
    [self.viewCenter addSubview:viewLeft];
    [self.viewCenter addSubview:viewRight];
    
    // 添加遮罩
    _viewShader = [[UIView alloc] initWithFrame:self.view.bounds];
    [_viewShader setBackgroundColor:[UIColor grayColor]];
    [_viewShader setHidden:YES];
    [_viewShader setAlpha:0.0];
    [self.viewCenter addSubview:_viewShader];
    
    _curActiveEdge = _activeEdge;
    
    _curDisplayView = kDisplayCenterView;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch Action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:_viewCenter];
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    if (_curDisplayView != 0) {
        _timeFirstTouch = [NSDate timeIntervalSinceReferenceDate];
    }
    if (point.x >= 0 && point.x < _curActiveEdge) {
        //
        _canTrace = YES;
        _isTraceActive = NO;
        _startPoint = point;
        _prevPoint = point;
        _curTraceView = _viewRight;
        if (_curDisplayView == 0) {
            _willSliderTo = 1;
        } else {
            _willSliderTo = -1;
        }
    } else if (_canShowRight && screenWidth > point.x && screenWidth - point.x < _curActiveEdge) {
        _canTrace = YES;
        _isTraceActive = NO;
        _startPoint = point;
        _prevPoint = point;
        _curTraceView = _viewCenter;
        if (_curDisplayView == 0) {
            _willSliderTo = -1;
        } else {
            _willSliderTo = 1;
        }
    } else {
        _canTrace = NO;
        _isTraceActive = NO;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_canTrace) {
        CGPoint point = [[touches anyObject] locationInView:self.view];
        float dx = point.x - _prevPoint.x;
        
        if (_isTraceActive) {
            // 跟踪
            CGRect rect = _curTraceView.frame;
            CGFloat originX = rect.origin.x;
            rect.origin.x += dx;
            [self setShaderTo:rect.origin.x];
            if (originX * rect.origin.x <= 0) {
                rect.origin.x = 0;
            }
            [_curTraceView setFrame:rect];
        } else {
            // 判断激活条件
            float dy = abs(point.y - _prevPoint.y);
            float curDx = dx * _willSliderTo;
            if (dy < ACTIVE_MAX_DY) {
                if (curDx > 0) {
                    // 激活方向正确
                    
                    _isTraceActive = YES;
                    CGRect rect = _curTraceView.frame;
                    rect.origin.x += dx;
                    CGFloat originX = rect.origin.x;
                    rect.origin.x += dx;
                    [_viewShader setHidden:NO];
                    [self setShaderTo:rect.origin.x];
                    if (originX * rect.origin.x <= 0) {
                        rect.origin.x = 0;
                    }
                    [_curTraceView setFrame:rect];
                }
                
            }
        }
        _prevPoint = point;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isTraceActive) {
        CGRect rect = _curTraceView.frame;
        CGFloat deviceWidth = self.view.bounds.size.width;
        CGPoint point = [[touches anyObject] locationInView:self.view];
        float dx = point.x - _prevPoint.x;
        
        if (abs(dx) > MIN_SPEED) {
            NSLog(@"SPEED");
            [self showViewWithDirection:dx];
        } else {
            // 判断位子，
            if (abs(rect.origin.x) / deviceWidth < 0.5) {
                [self showCenterView];
            } else {
                [self showViewWithDirection:point.x - _startPoint.x];
            }
        }
    } else {
        if (_curDisplayView != 0) {
            NSTimeInterval curTime = [NSDate timeIntervalSinceReferenceDate];
            CGPoint point = [[touches anyObject] locationInView:_viewCenter];
            float curx = point.x;
            if (curTime - _timeFirstTouch < 0.2 && curx <= kScreenWidth) {
                [self showCenterView];
            }
        }
    }
    _canTrace = NO;
    _isTraceActive = NO;
}

- (void)setShaderTo:(float)dx
{
    float alpha = 0.0;
    if (dx >= 0) {
        alpha = 0.7 * dx / (kScreenWidth - OFFSET_LEFT_DX);
    } else {
        alpha = - 0.7 * dx / (kScreenWidth - OFFSET_RIGHT_DX);
    }
    [_viewShader setAlpha:alpha];
}

- (void)showViewWithDirection:(float)direction
{
    if ([_curTraceView isEqual:_viewRight]) {
        if (direction > 0) {
            [self showLeftView];
        } else {
            [self showCenterView];
        }
    } else if ([_curTraceView isEqual:_viewCenter]) {
        if (direction > 0) {
            [self showCenterView];
        } else {
            [self showRightView];
        }
    }
}

#pragma mark - Private

- (void)borderAnimateToFrame:(CGRect)rect animations:(BOOL)animations
{
    if (animations)
    {
        [UIView animateWithDuration:0.3f animations:^{
            [_borderView setFrame:rect];
        }];
    }
    else
    {
        [_borderView setFrame:rect];
    }
}

#pragma mark - Action

- (void)showLeftView
{
    [_viewShader setHidden:NO];
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        CGRect rect = [self.view bounds];
        rect.origin.x = rect.size.width - OFFSET_LEFT_DX;
        [_viewRight setFrame:rect];
        [_viewShader setAlpha:0.7];
    } completion:^(BOOL finished) {
        _curDisplayView = kDisplayLeftView;
        _curActiveEdge = OFFSET_LEFT_DX;
    }];
    return;
}

- (void)showCenterView
{
//    [self showCenterViewAnimations:YES];
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        CGRect rect = [self.view bounds];
        [_viewCenter setFrame:rect];
        [_viewRight setFrame:rect];
        [_viewShader setAlpha:0.0];
    } completion:^(BOOL finished) {
        _curDisplayView = kDisplayCenterView;
        [_viewShader setHidden:YES];
        _curActiveEdge = _activeEdge;
    }];
    return;
}

- (void)showRightView
{
    //[_viewShader setHidden:NO];
    [_viewShader setHidden:YES];    // modified by Xia Zhiyong
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        CGRect rect = [self.view bounds];
        rect.origin.x = -rect.size.width + OFFSET_RIGHT_DX;
        [_viewCenter setFrame:rect];
        [_viewShader setAlpha:0.7];
    } completion:^(BOOL finished) {
        _curDisplayView = kDisplayRightView;
        _curActiveEdge = OFFSET_RIGHT_DX;
    }];
    return;
}

- (void)showCenterViewAnimations:(BOOL)animations
{
    if (_curDisplayView != 0 && _centerViewController)
    {
        _curDisplayView = kDisplayCenterView;
        CGRect rect = _borderView.frame;
        rect.origin.x = -rect.size.width / 3;
        [self borderAnimateToFrame:rect animations:animations];
        [self giveNoticeTo:_centerViewController];
    }
}

- (void)giveNoticeTo:(UIViewController *)viewController
{
    UIViewController *aVC = viewController;
    if ([aVC.childViewControllers count] > 0)
    {
        aVC = [aVC.childViewControllers lastObject];
    }
    if (aVC && [aVC respondsToSelector:@selector(viewWillShow)])
    {
        [aVC viewWillShow];
    }
}


@end
