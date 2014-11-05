//
//  SecondKillDetailViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-5.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "SecondKillDetailViewController.h"

@interface SecondKillDetailViewController ()

@end

@implementation SecondKillDetailViewController

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
    
    self.navigationItem.title = @"团购";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navController showBackButtonWith:self];
    
    [self requestSecondKillDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestSecondKillDetail
{
    [self startLoading:kLoading];
    
    [InterfaceManager getGroupOnDetail:self.activityItem.act_id completion:^(BOOL isSucceed, NSString *message, id data) {
        [self stopLoading];
        if (isSucceed == YES)
        {
            NSLog(@"获取秒杀详情信息成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];
            NSDictionary *dic = [dataDic objectForKey:@"purchase"];
            NSError *error = nil;
            self.activityDetail = [[ActivityDetailModel alloc] initWithDictionary:dic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析错误:%@", error);
            }
            else
            {
                NSLog(@"name:%@", self.activityDetail.name);
            }
        }
        else
        {
            [self toast:message];
        }
    }];
}


@end
