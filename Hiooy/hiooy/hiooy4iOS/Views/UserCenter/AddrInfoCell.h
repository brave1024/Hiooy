//
//  AddrInfoCell.h
//  hiooy
//
//  Created by 黄磊 on 14-3-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddrInfoCell;

@protocol AddrInfoCellDelegate <TableViewCellDelegate>

- (void)setDefaultCellAtIndex:(NSUInteger)index;
- (void)deleteCellAtIndex:(NSUInteger)index;
- (void)editCellAtIndex:(NSUInteger)index;

@end


@interface AddrInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnDefault;    // 默认
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;       // 编辑
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;     // 删除

@property (strong, nonatomic) IBOutlet UILabel *lblRegion;      // 地区
@property (strong, nonatomic) IBOutlet UILabel *lblAddr;        // 地址详情
@property (strong, nonatomic) IBOutlet UILabel *lblUser;        // 用户姓名
@property (strong, nonatomic) IBOutlet UILabel *lblMobile;      // 手机号
@property (strong, nonatomic) IBOutlet UILabel *lblTel;         // 座机号
@property (strong, nonatomic) IBOutlet UIView *viewTop;         //

@property (assign, nonatomic) NSUInteger cellIndex;

@property (assign, nonatomic) id<AddrInfoCellDelegate> delegate;

- (IBAction)setDefault:(id)sender;
- (IBAction)editAddr:(id)sender;
- (IBAction)deleteAddr:(id)sender;

@end


