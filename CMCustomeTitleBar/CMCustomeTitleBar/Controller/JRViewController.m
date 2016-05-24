//
//  JRViewController.m
//  CMCustomeTitleBar
//
//  Created by CrabMan on 16/5/24.
//  Copyright © 2016年 CrabMan. All rights reserved.
//

#import "JRViewController.h"
#import "CMChildTableViewController.h"
@interface JRViewController ()

@end

@implementation JRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"今日头条";
    self.titleColorGradientStyle = CMTitleColorGradientStyleFill;
    [self setUpAllViewController];
    
    [self refreshDisplay];
}

- (void)setUpAllViewController
{
    
    // 段子
    CMChildTableViewController *wordVc1 = [[CMChildTableViewController alloc] init];
    wordVc1.title = @"小码哥";
    [self addChildViewController:wordVc1];
    
    // 段子
    CMChildTableViewController *wordVc2 = [[CMChildTableViewController alloc] init];
    wordVc2.title = @"M了个J";
    [self addChildViewController:wordVc2];
    
    // 段子
    CMChildTableViewController *wordVc3 = [[CMChildTableViewController alloc] init];
    wordVc3.title = @"啊峥";
    [self addChildViewController:wordVc3];
    
    CMChildTableViewController *wordVc4 = [[CMChildTableViewController alloc] init];
    wordVc4.title = @"吖了个峥";
    [self addChildViewController:wordVc4];
    
    // 全部
    CMChildTableViewController *allVc = [[CMChildTableViewController alloc] init];
    allVc.title = @"全部";
    [self addChildViewController:allVc];
    
    // 视频
    CMChildTableViewController *videoVc = [[CMChildTableViewController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    // 声音
    CMChildTableViewController *voiceVc = [[CMChildTableViewController alloc] init];
    voiceVc.title = @"声音";
    [self addChildViewController:voiceVc];
    
    // 图片
    CMChildTableViewController *pictureVc = [[CMChildTableViewController alloc] init];
    pictureVc.title = @"图片";
    [self addChildViewController:pictureVc];
    
    // 段子
    CMChildTableViewController *wordVc = [[CMChildTableViewController alloc] init];
    wordVc.title = @"段子";
    [self addChildViewController:wordVc];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
