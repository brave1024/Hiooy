//
//  ProductCommentViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ProductCommentViewController.h"
#import "CommentCell.h"

@interface ProductCommentViewController ()

@end

@implementation ProductCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"评价列表";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.arrayComment = [NSMutableArray arrayWithArray:self.product.comments.list];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// 动态计算cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 108;
    
    // 计算高度
    CommentDetailModel *item = [self.arrayComment objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize size = CGSizeMake(260, 1000);
    //NSString *strTest = @"东西很好哦，真心赞一个，朋友们都很喜欢，呵呵，快递也不错，速度非常快，昨天发的货，今天下午就到了，神速哦，哈哈。后面还会再光顾的，祝掌柜的生意兴隆、财源广进。。。";
    //CGSize contentSie = [strTest sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGSize contentSie = [item.comment sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return contentSie.height + 72;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrayComment.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"commentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [CommentCell cellFromNib];
    }
    
    // Configure the cell...
    CommentDetailModel *item = [self.arrayComment objectAtIndex:indexPath.row];
    
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize size = CGSizeMake(260, 1000);
    //NSString *strTest = @"东西很好哦，真心赞一个，朋友们都很喜欢，呵呵，快递也不错，速度非常快，昨天发的货，今天下午就到了，神速哦，哈哈。后面还会再光顾的，祝掌柜的生意兴隆、财源广进。。。";
    //CGSize contentSie = [strTest sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGSize contentSie = [item.comment sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    cell.lblContent.frame = CGRectMake(53, 40, 260, contentSie.height);
    
    cell.lblName.text = item.member_name;
    cell.lblContent.text = item.comment;
    //cell.lblContent.text = strTest;
    [cell.imgviewPic setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:[UIImage imageNamed:kImageNameDefault]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




@end
