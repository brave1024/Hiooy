//
//  CartCell.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-27.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  购物车cell

#import <UIKit/UIKit.h>

@protocol CartCellDelegate <NSObject>

- (void)cartSelectButtonTouched:(id)cell withButtonTag:(int)tag;
- (void)cartDeleteButtonTouched:(id)cell withButtonTag:(int)tag;
- (void)cartCellBeginEdit:(id)cell;
- (void)cartCellEndEdit:(id)cell;

@end


@interface CartCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UIButton *btnSelect;

@property (nonatomic, weak) IBOutlet UIView *viewContent;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblType;

@property (nonatomic, weak) IBOutlet UILabel *lblPrice;
@property (nonatomic, weak) IBOutlet UILabel *lblNumber;

@property (nonatomic, weak) IBOutlet UIView *viewEdit;
@property (nonatomic, weak) IBOutlet UIButton *btnDelete;
@property (nonatomic, weak) IBOutlet UITextField *txtfieldNumber;

//@property (nonatomic, weak) IBOutlet UIButton *btnAdd;
//@property (nonatomic, weak) IBOutlet UIButton *btnMinus;

@property (nonatomic, assign) id<CartCellDelegate> delegate;

//@property BOOL isEditting;
//@property (nonatomic, copy) NSString *goodsId;

+ (CartCell *)cellFromNib;
- (void)settingCell:(id)cellData withStatus:(NSString *)status;
- (IBAction)btnTouch:(id)sender;

@end
