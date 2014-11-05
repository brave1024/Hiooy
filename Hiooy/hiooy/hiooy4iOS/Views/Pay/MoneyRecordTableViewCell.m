//
//  MoneyRecordTableViewCell.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-23.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "MoneyRecordTableViewCell.h"
#import "RecordItemModel.h"

@implementation MoneyRecordTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (MoneyRecordTableViewCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MoneyRecordTableViewCell" owner:self options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)data
{
    RecordItemModel *record = (RecordItemModel *)data;
    self.lblTime.text = record.mtime;
    self.lblType.text = record.message;
    self.lblTotal.text = [NSString stringWithFormat:@"%.2f", [record.member_advance floatValue]];
    CGFloat addNumber = [record.import_money floatValue];
    CGFloat minusNumber = [record.explode_money floatValue];
    if (addNumber > 0.0 && minusNumber == 0.0)
    {
        self.lblPay.text = [NSString stringWithFormat:@"+ %.2f", addNumber];
    }
    if (minusNumber > 0.0 && addNumber == 0.0)
    {
        self.lblPay.text = [NSString stringWithFormat:@"- %.2f", minusNumber];
    }
}


@end
