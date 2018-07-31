//
//  CMChildTableViewController.m
//  CMCustomTitleBar
//
//  Created by CrabMan on 16/5/5.
//  Copyright © 2016年 CrabMan. All rights reserved.
//

#import "CMChildTableViewController.h"
#import "requestCover.h"

@interface CMChildTableViewController ()
@property (nonatomic,weak) requestCover *cover;

@end

@implementation CMChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:CMDisplayViewClickOrScrollDidFinshNote object:self];
    
    // 开发中可以搞个蒙版，一开始遮住当前界面，等请求成功，在把蒙版隐藏.
    
    requestCover *cover = [requestCover show];

    [self.view addSubview:cover];

    _cover = cover;
    
    
    
}

- (void)loadData {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"%@--请求数据成功",self.title);
        
        [self.cover removeFromSuperview];
        
    });

}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@:%ld",self.title,(long)indexPath.row];
    
    return cell;
}



@end
