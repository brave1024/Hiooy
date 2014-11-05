//
//  CategoryViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-10.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "CategoryViewController.h"
#import "InterfaceManager.h"
#import "CategorySubViewController.h"

@interface CategoryViewController ()
@property int openSectionIndex;
@property BOOL hasData;
@end

@implementation CategoryViewController

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
    
    self.navigationItem.title = @"商品分类";
    
    _openSectionIndex = NSNotFound;
    
    self.arrayCategory = [[NSMutableArray alloc] init];
    
    kAppDelegate.currentSelectedIndex = 1;
    self.hasData = NO;  // 默认为无数据
    
    // 获取顶级分类
    //[self requestProductCategory];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 当第一次进入此界面无网络时,请求不到数据;则下次再进入时,需重复请求
    if (self.hasData == NO)
    {
        // 获取顶级分类
        [self requestProductCategory];
    }
}

// 获取商品分类列表
- (void)requestProductCategory
{
    [self startLoading:kLoading];
    
    [InterfaceManager getProductCategory:nil withPage:nil completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed) {
            NSLog(@"获取商品分类成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            self.categoryList = [[ProductCatListModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败");
                return;
            }
            self.navigationItem.title = self.categoryList.title;
            [self createSectionInfoArray];
            [self.tableview reloadData];
            self.hasData = YES;
//            ProductCatItemModel *item = [productList.cat_lists objectAtIndex:0];
//            NSLog(@"id:%@, name:%@", item.cat_id, item.cat_name);
        }else {
            NSLog(@"获取商品分类失败:%@", message);
            [self toast:message];
            self.hasData = NO;
        }
    }];
}

- (void)createSectionInfoArray
{
    for (int i = 0; i < self.categoryList.cat_lists.count; i++)
    {
        ProductCatItemModel *item = [self.categoryList.cat_lists objectAtIndex:i];
        SectionInfo *section = [[SectionInfo alloc] init];
        section.categoryItem = item;
        [self.arrayCategory addObject:section];
    }
}


#pragma mark - UITableViewDelegate

// 有几大类,就有几个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayCategory.count;
}

// 根据当前section是否展开来判断row的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    SectionInfo *sectionInfo = [self.arrayCategory objectAtIndex:section];
    if (sectionInfo.categoryItem.sub == nil)
    {
        count = 0;
    }
    else
    {
        count = sectionInfo.categoryItem.sub.count;
    }
    return sectionInfo.open ? count : 0;
}

// 动态返回各cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
    /*
    SectionInfo *section = [self.arrayCategory objectAtIndex:indexPath.section];
    ProductCatItemModel *item = (ProductCatItemModel *)section.categoryItem;
    
    // 计算高度
    UIFont *font = [UIFont fontWithName:@"JXiHei" size:15];
    CGSize size = CGSizeMake(300, 1000);
    CGSize contentSie = [item.cat_name sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"height:%f, content:%@", contentSie.height, item.cat_name);
    return contentSie.height + 35 + 10;
     */
}

// 生成section之headerview
- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    // Create the section header views lazily.
    SectionInfo *sectionInfo = [self.arrayCategory objectAtIndex:section];
    if (!sectionInfo.headerView)
    {
        // 当前section之headerview高度应动态计算,暂时固定
        HeaderView *headerView = [HeaderView viewFromNib];
        headerView.delegate_ = self;
        [headerView settingHeaderView];
        [headerView settingViewWithStatus:sectionInfo.open andSection:section];
        headerView.lblTitle.text = sectionInfo.categoryItem.cat_name;
        [headerView.imgviewPic setImageWithURL:[NSURL URLWithString:sectionInfo.categoryItem.image_url] placeholderImage:nil];
        sectionInfo.headerView = headerView;
    }
    return sectionInfo.headerView;
}

// 设置各个section的高度<固定>
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}

// 设置各cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CetegoryCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        //cell = [CategoryCell cellFromNib];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 设置子cell
    SectionInfo *section = [self.arrayCategory objectAtIndex:indexPath.section];
    ProductCatItemModel *item = (ProductCatItemModel *)section.categoryItem;
    
    int row = indexPath.row;
    ProductCatItemModel *subItem = [item.sub objectAtIndex:row];
    //[cell.imageView setImageWithURL:[NSURL URLWithString:item.image_url] placeholderImage:nil];
    cell.textLabel.text = subItem.cat_name;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

// cell可点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 获取子分类
    SectionInfo *section = [self.arrayCategory objectAtIndex:indexPath.section];
    ProductCatItemModel *item = [section.categoryItem.sub objectAtIndex:indexPath.row];
    
    CategorySubViewController *subCategoryVC = [[CategorySubViewController alloc] initWithNibName:@"CategorySubViewController" bundle:nil];
    subCategoryVC.categoryItem = item;
    [self.tabBarController.navigationController pushViewController:subCategoryVC animated:YES];
    //[self.navigationController pushViewController:subCategoryVC animated:YES];
}


#pragma mark Section Header Delegate

- (void)sectionHeaderView:(HeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened
{
    SectionInfo *sectionInfo = [self.arrayCategory objectAtIndex:sectionOpened];
    sectionInfo.open = YES;
    NSLog(@"sectionOpened:%d", sectionOpened);
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    //NSInteger countOfRowsToInsert = sectionInfo.categoryItem.sub.count;
    NSInteger countOfRowsToInsert = 0;
    if (sectionInfo.categoryItem.sub == nil)
    {
        countOfRowsToInsert = 0;
    }
    else
    {
        countOfRowsToInsert = sectionInfo.categoryItem.sub.count;
    }
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init]; // insertArray
    for (NSInteger i = 0; i < countOfRowsToInsert; i++)
    {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init]; // deleteArray
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound)
    {
        SectionInfo *previousOpenSection = [self.arrayCategory objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        //NSInteger countOfRowsToDelete = previousOpenSection.categoryItem.sub.count;
        NSInteger countOfRowsToDelete = 0;
        if (previousOpenSection.categoryItem.sub == nil)
        {
            countOfRowsToDelete = 0;
        }
        else
        {
            countOfRowsToDelete = previousOpenSection.categoryItem.sub.count;
        }
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex)
    {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else
    {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.tableview beginUpdates];
    [self.tableview insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableview deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableview endUpdates];
    self.openSectionIndex = sectionOpened;
    LogTrace(@"section open at index %d ...!@", sectionOpened);
}

- (void)sectionHeaderView:(HeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
{
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    SectionInfo *sectionInfo = [self.arrayCategory objectAtIndex:sectionClosed];
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableview numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0)
    {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init]; // deleteArray
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableview deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        //[self.tableview endUpdates];
    }
    self.openSectionIndex = NSNotFound;
    LogTrace(@"section close at index : %d ...!@", sectionClosed);
}



@end
