//
//  SecondKillTableViewCell.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-3.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "SecondKillTableViewCell.h"
#import "ActivityItemModel.h"

//static long rTime = 0;

@implementation SecondKillTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (SecondKillTableViewCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SecondKillTableViewCell" owner:self options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)data
{
    ActivityItemModel *item = (ActivityItemModel *)data;
    [self.imgviewPic setImageWithURL:[NSURL URLWithString:item.image_url] placeholderImage:[UIImage imageNamed:kImageNameDefault]];
    self.lblName.text = item.seller_name;
    self.lblTitle.text = item.name;
    self.lblMarketPrice.text = [NSString stringWithFormat:@"%.2f元", [item.old_price floatValue]];
    self.lblPrice.text = [NSString stringWithFormat:@"%.2f元", [item.price floatValue]];
    //self.lblStartTime.text = item.start_time;
    
    self.lblMarketPrice.lineType = LineTypeMiddle;
    self.lblMarketPrice.lineColor = [UIColor darkGrayColor];
    
    // 剩余时间
//    if (self.rTime == 0)
//    {
//        self.rTime = (long)[item.remain_time longLongValue];
//    }

    UIImage *img_ = [UIImage imageNamed:@"btn_seckill"];
    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(8, 12, 8, 12)];
    [self.btnBuy setBackgroundImage:img_ forState:UIControlStateNormal];
    self.btnBuy.enabled = NO;
    self.btnBuy.hidden = YES;   // 不再显示当前购买按钮
    
    UIImage *img = [UIImage imageNamed:@"ico_statebg"];
    //img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(5, 6, 5, 6)];
    self.imgviewDiscount.image = img;
    self.viewDiscount.hidden = NO;
    
    if ([item.state isEqualToString:@"1"] == YES)           // 未开始
    {
        self.lblDiscount.text = @"未开始";
        self.btnBuy.enabled = NO;
        
        self.lblHour.text = @"";
        self.lblMinute.text = @"";
        self.lblSecond.text = @"";
    }
    else if ([item.state isEqualToString:@"2"] == YES)      // 进行中
    {
        self.lblDiscount.text = @"进行中";
        self.btnBuy.enabled = YES;
        
        self.rTime = (long)[item.remain_time longLongValue];
        if (self.rTime <= 0)
        {
            //NSLog(@"秒杀活动已截止...");
            self.lblHour.text = @"";
            self.lblMinute.text = @"";
            self.lblSecond.text = @"";
            self.lblDiscount.text = @"已结束";
            self.btnBuy.enabled = NO;
            return;
        }
        
        int timePass = [item.passTime intValue];    // 已流逝的时间
        if (self.rTime - timePass <= 0)
        {
            //NSLog(@"秒杀活动已截止...");
            self.lblHour.text = @"";
            self.lblMinute.text = @"";
            self.lblSecond.text = @"";
            self.lblDiscount.text = @"已结束";
            self.btnBuy.enabled = NO;
            return;
        }
        
        self.rTime = labs(self.rTime);
        long remindTime = self.rTime - [item.passTime intValue];
        //NSLog(@"剩余秒数:%ld", remindTime);
        self.lblDiscount.text = @"进行中";
        
        int seconds = remindTime % 60;
        int minutes = (remindTime / 60) % 60;
        int hours = remindTime / 3600;
        self.lblHour.text = [self checkNumber:hours];
        self.lblMinute.text = [self checkNumber:minutes];
        self.lblSecond.text = [self checkNumber:seconds];
    }
    else if ([item.state isEqualToString:@"2"] == YES)      // 已结束
    {
        self.lblDiscount.text = @"已结束";
        self.lblHour.text = @"";
        self.lblMinute.text = @"";
        self.lblSecond.text = @"";
        self.btnBuy.enabled = NO;
    }
    else                                                    // 其它
    {
        self.lblDiscount.text = @"";
    }
        
    /****************************************************/
    
    /*
    self.rTime = labs(self.rTime);
    NSLog(@"剩余秒数:%ld", self.rTime);
//    NSString *timeStr = [self timeFormatted:self.rTime];
//    NSLog(@"剩余时间:%@", timeStr);
    
    int seconds = self.rTime % 60;
    int minutes = (self.rTime / 60) % 60;
    int hours = self.rTime / 3600;
    self.lblHour.text = [self checkNumber:hours];
    self.lblMinute.text = [self checkNumber:minutes];
    self.lblSecond.text = [self checkNumber:seconds];
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(showTimeChanged) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
     */
}

//- (NSString *)timeFormatted:(int)totalSeconds
//{
//    int seconds = totalSeconds % 60;
//    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
//    
//    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
//}

- (NSString *)checkNumber:(int)number
{
    if (number < 10)
    {
        return [NSString stringWithFormat:@"0%d", number];
    }
    else
    {
        return [NSString stringWithFormat:@"%d", number];
    }
}

- (void)showTimeChanged
{
    if (self.rTime == 0)
    {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    self.rTime--;
    
    int seconds = self.rTime % 60;
    int minutes = (self.rTime / 60) % 60;
    int hours = self.rTime / 3600;
    self.lblHour.text = [self checkNumber:hours];
    self.lblMinute.text = [self checkNumber:minutes];
    self.lblSecond.text = [self checkNumber:seconds];
}


@end
