//
//  WYViewController.m
//  CMCustomeTitleBar
//
//  Created by CrabMan on 16/5/27.
//  Copyright © 2016年 CrabMan. All rights reserved.
//

#import "WYViewController.h"
#import "CMChildTableViewController.h"
@interface WYViewController ()

@end

@implementation WYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.isShowTitleScale = YES;
    self.titleColorGradientStyle = CMTitleColorGradientStyleFill;

    [self setUpAllViewController];
    
    
}


- (void)setUpAllViewController
{
    
    // 段子
    CMChildTableViewController *wordVc1 = [[ CMChildTableViewController alloc] init];
    wordVc1.title = @"安全工程概论";
    [self addChildViewController:wordVc1];
    
    // 段子
    CMChildTableViewController *wordVc2 = [[CMChildTableViewController alloc] init];
    wordVc2.title = @"安全心理学";
    [self addChildViewController:wordVc2];
    
    // 段子
    CMChildTableViewController *wordVc3 = [[CMChildTableViewController alloc] init];
    wordVc3.title = @"安全学原理";
    [self addChildViewController:wordVc3];
    // 声音
    CMChildTableViewController *voiceVc = [[CMChildTableViewController alloc] init];
    voiceVc.title = @"火炸药概论";
    [self addChildViewController:voiceVc];
    
    CMChildTableViewController *wordVc4 = [[CMChildTableViewController alloc] init];
    wordVc4.title = @"安全人机工程";
    [self addChildViewController:wordVc4];
    
    // 全部
    CMChildTableViewController *allVc = [[CMChildTableViewController alloc] init];
    allVc.title = @"电气安全";
    [self addChildViewController:allVc];
    
    // 视频
    CMChildTableViewController *videoVc = [[CMChildTableViewController alloc] init];
    videoVc.title = @"系统安全工程";
    [self addChildViewController:videoVc];
    
    
    
    // 图片
    CMChildTableViewController *pictureVc = [[CMChildTableViewController alloc] init];
    pictureVc.title = @"压力容器安全技术";
    [self addChildViewController:pictureVc];
    
    // 段子
    CMChildTableViewController *wordVc = [[CMChildTableViewController alloc] init];
    wordVc.title = @"爆破工程与安全技术";
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
