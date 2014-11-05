//
//  HeaderView.h
//  WorldAngle
//
//  Created by Xia Zhiyong on 14-4-5.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegte;

@interface HeaderView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imgviewBg;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIButton *btnShow;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) id<HeaderViewDelegte> delegate_;

+ (HeaderView *)viewFromNib;
- (void)settingHeaderView;
- (void)settingViewWithStatus:(BOOL)open andSection:(int)sIndex;

- (IBAction)showOrHideContent:(id)sender;
- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end


/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol HeaderViewDelegte <NSObject>

@optional
- (void)sectionHeaderView:(HeaderView *)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(HeaderView *)sectionHeaderView sectionClosed:(NSInteger)section;

@end