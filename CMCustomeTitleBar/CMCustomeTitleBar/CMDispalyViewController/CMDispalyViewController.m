//
//  CMDispalyViewController.m
//  CMCustomTitleBar
//
//  Created by CrabMan on 16/5/1.
//  Copyright © 2016年 CrabMan. All rights reserved.
//

#import "CMDispalyViewController.h"
#import "CMDisplayTitleLabel.h"
#import "UIView+Frame.h"
#import "CMFlowLayout.h"
@interface CMDispalyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 整体内容View 包含标题好内容滚动视图 */
@property (nonatomic, weak) UIView *contentView;

/** 标题滚动视图 */
@property (nonatomic, weak) UIScrollView *titleScrollView;

/** 内容滚动视图 */
@property (nonatomic, weak) UICollectionView *contentScrollView;

/** 所有的标题数组 */
@property (nonatomic, strong) NSMutableArray *titleLabels;

/** 所以标题总宽度 */
@property (nonatomic, assign) CGFloat labesTotalWidth;

/** 下标视图 */
@property (nonatomic, weak) UIView *underLine;

/** 标题遮盖视图 */
@property (nonatomic, weak) UIView *coverView;

/** 记录上一次内容滚动视图偏移量 */
@property (nonatomic, assign) CGFloat lastOffsetX;

/** 记录是否点击 */
@property (nonatomic, assign) BOOL isClickTitle;

/** 记录是否在动画 */
@property (nonatomic, assign) BOOL isAniming;

/* 是否初始化 */
@property (nonatomic, assign) BOOL isInitial;

/** 标题间距 */
@property (nonatomic, assign) CGFloat titleMargin;

/** 计算上一次选中角标 */
@property (nonatomic, assign) NSInteger selIndex;

/** 用于保存选中的label */
@property (nonatomic,weak) CMDisplayTitleLabel *selectedLabel;



@end

@implementation CMDispalyViewController
-(instancetype)init {
    if (self = [super init]) {
       self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

/**
 设置标题文字正常颜色
 */
-(UIColor *)normalColor {

    if (_titleColorGradientStyle == CMTitleColorGradientStyleRGB ) {
        _normalColor = [UIColor colorWithRed:_startR green:_startG blue:_startG alpha:1];
    } else {
    
        _normalColor = [UIColor blackColor];
    }
    return _normalColor;
}
/**
 设置标题文字选中状态颜色
 */
-(UIColor *)selectedColor {
    if (_titleColorGradientStyle == CMTitleColorGradientStyleRGB ) {
        _selectedColor = [UIColor colorWithRed:_endR green:_endG blue:_endB alpha:1];
    } else {
        
        _selectedColor = [UIColor redColor];
    }
    return _selectedColor;
}

-(NSMutableArray *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

-(UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc]init];
        _contentView = contentView;
        
        [self.view addSubview:_contentView];
        
    }
    return _contentView;
}
//懒加载标题滚动视图
-(UIScrollView *)titleScrollView {
    if (!_titleScrollView) {
    
        UIScrollView *titleScrollView = [[UIScrollView alloc]init];
        titleScrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        
        
        //隐藏横向滚动条
        titleScrollView.showsHorizontalScrollIndicator = NO;
        //关闭弹动效果
        titleScrollView.bounces = NO;
        
        _titleScrollView = titleScrollView;
        
        [self.contentView addSubview:_titleScrollView];
        
    }
    return _titleScrollView;
}
//懒加载内容滚动视图
-(UICollectionView *)contentScrollView {
    if (!_contentScrollView) {
        //创建布局
        CMFlowLayout *layout = [[CMFlowLayout alloc]init];
        
        UICollectionView *contentScrollView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        contentScrollView.pagingEnabled = YES;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.bounces = NO;
        contentScrollView.delegate = self;
        contentScrollView.dataSource = self;
        _contentScrollView = contentScrollView;
        
        [self.contentView insertSubview:_contentScrollView belowSubview:self.titleScrollView];
        
    }
    return _contentScrollView;
    
}
- (void)setTitleScrollViewColor:(UIColor *)titleScrollViewColor {

    _titleScrollViewColor = titleScrollViewColor;
    self.titleScrollView.backgroundColor = _titleScrollViewColor;

}
//设置整体内容的尺寸
- (void)setUpContentViewFrame:(void (^)(UIView *))contentViewBlock {
    if (contentViewBlock) {
        contentViewBlock(self.contentView);
    }
}
//设置所有颜色的渐变属性
- (void)setUpTitleGradient:(void (^)(BOOL *, CMTitleColorGradientStyle *, CGFloat *, CGFloat *, CGFloat *, CGFloat *, CGFloat *, CGFloat *))titleGradientBlock {

    if (titleGradientBlock) {
        titleGradientBlock(&_isShowTitleGradient,&_titleColorGradientStyle,&_startR,&_startG,&_startB,&_endR,&_endG,&_endB);
    }

}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat contentY = self.navigationController?CMNavBarH:[UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat contentW = CMScreenH;
    CGFloat contentH = CMScreenH - contentY;
    
    //设置整个内容的尺寸
    if (self.contentView.height == 0) {
        self.contentView.frame = CGRectMake(0, contentY, contentW, contentH);
    }
    //设置titleScrollView 视图的frame,Y与内容视图的Y一样
    self.titleScrollView.frame = CGRectMake(0, 0, CMScreenW, CMTitleScrollViewH);
    
    //设置contentScrollView的frame
    
    CGFloat contentScrollViewH = _isFullScreen? contentH: contentH-CMTitleScrollViewH;
    CGFloat contentScrollViewY = _isFullScreen?0:CMTitleScrollViewH;
    self.contentScrollView.frame = CGRectMake(0, contentScrollViewY, CMScreenW, contentScrollViewH);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isInitial == NO) {
        _isInitial =YES;
        //注册cell
        [self.contentScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
        
        self.contentScrollView.backgroundColor = self.view.backgroundColor ;
        if (self.childViewControllers.count == 0) return;
    }
}

/**
 设置标题label的位置和内容
 */
- (void)setUpAllTitles {
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelW = 0;
    NSArray *titles = [self.childViewControllers valueForKeyPath:@"title"];
    //设置标题的间距
    [self setUpTitleLabelMargin];
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        
        UILabel *label = [[CMDisplayTitleLabel alloc]init];
        
        label.tag = i;
        
        //设置按钮的颜色
        label.textColor = self.normalColor;
        label.font = CMTitleFont;
        //将label的text与视图控制器对应
        label.text = titles[i];
        
        //设置按钮的位置(按钮的frame与前一个按钮的frame有关系)
        UILabel *lastLabel = [self.titleLabels lastObject];
        labelX = self.titleMargin + CGRectGetMaxX(lastLabel.frame);
       
        //label.backgroundColor = [UIColor greenColor];
        
        
        //设置label 的宽度
        labelW = [self setUpLabelWidthAccordingToTitle:titles[i]];
        label.frame = CGRectMake(labelX, labelY, labelW, CMTitleScrollViewH);
        
        
        //设置label可以与用户交互
        label.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLabel:)];
        [label addGestureRecognizer:tap];
        //监听标题的点击事件
        
        [self.titleLabels addObject:label];
        [self.titleScrollView addSubview:label];
        //设置标题的默认点击位置
    }
    //设置标题的滚动视图的contentSize
    UILabel *lastLabel = [self.titleLabels lastObject];
   
    //设置默认点击label
    [self setDefaultSelectedLabel:[self.titleLabels firstObject]];
    self.titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), 0);
    
    //设置内容滚动视图的contentSize
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * CMScreenW, 0);
    

}

/**
 根据label的内容动态获得label的宽度
 */
- (CGFloat)setUpLabelWidthAccordingToTitle:(NSString *)title {
   
    //如果没有设置vc的title，设置抛异常
    if ([title isKindOfClass:[NSNull class]]) {
        NSException *exception = [NSException exceptionWithName:@"CMDisplayViewControllerException" reason:@"未设置对应的childController的title属性" userInfo:nil];
        [exception raise];
    }
    CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:CMTitleFont} context:nil];
    
    
    return titleBounds.size.width;
}


/**
 根据label的个数动态设置label的间距
 */
- (void)setUpTitleLabelMargin {
    NSArray *titles = [self.childViewControllers valueForKeyPath:@"title"];
    CGFloat totalLabelWidth = 0;
    for (NSString *title in titles) {
        totalLabelWidth += [self setUpLabelWidthAccordingToTitle:title];
    }
    
    if (totalLabelWidth  >= CMScreenW) {
        self.titleMargin = margin;
        
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.titleMargin);
    } else {
        
        CGFloat titleMargin = (CMScreenW - self.labesTotalWidth)/(self.childViewControllers.count + 1);
        
        self.titleMargin = titleMargin < margin ? margin : titleMargin;
        
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.titleMargin);
    }


}

- (void)setDefaultSelectedLabel:(CMDisplayTitleLabel *)label {
    
    label.textColor = self.selectedColor;
    label.textColor = self.selectedColor;
    label.transform = CGAffineTransformMakeScale(1.4, 1.4);
    //设置label的点击偏移量
    CGFloat offset = label.center.x - self.view.width * 0.5;
    
    if (offset < 0)
    {
        offset = 0;
    }
    CGFloat maxOffset = self.titleScrollView.contentSize.width - self.view.width;
    if (offset > maxOffset)
    {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    self.selectedLabel = label;

    

}

- (void)clickLabel:(UITapGestureRecognizer *)tap {

   // self.selectedLabel.isSelected = NO;
    self.selectedLabel.textColor = self.normalColor;
    self.selectedLabel.transform = CGAffineTransformIdentity;
    
    //获取所点击的label
    CMDisplayTitleLabel *label = (CMDisplayTitleLabel *)tap.view;
    //设置选中的label的颜色
    label.textColor = self.selectedColor;
    label.transform = CGAffineTransformMakeScale(1.4, 1.4);
    //设置label的点击偏移量
    CGFloat offset = label.center.x - self.view.width * 0.5;
    
    if (offset < 0)
    {
        offset = 0;
    }
    CGFloat maxOffset = self.titleScrollView.contentSize.width+self.titleMargin - self.view.width;
    if (maxOffset < 0) {
        maxOffset = 0;
    }
    if (offset > maxOffset)
    {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    self.selectedLabel = label;
    
    
    //设置内容滚动视图
    for (int i = 0; i < self.titleLabels.count; i++) {
        CMDisplayTitleLabel *titlelabel = self.titleLabels[i];
        if (titlelabel == label) {
            CGFloat offSetX = i * CMScreenW;
            self.contentScrollView.contentOffset = CGPointMake(offSetX, 0);
        }
        
    }
}

/**
 标题缩放
 */
- (void)setUpTitleScaleWithOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel {
    if (_isShowTitleScale == NO) return;
    //获取两个标题中心点的距离
    CGFloat centerDelta = rightLabel.x - leftLabel.x;
    //
    

}


-(void)refreshDisplay {
    //清空之前所有的标题
    [self.titleLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titleLabels removeAllObjects];
    
    //刷新列表
    [self.contentScrollView reloadData];
    [self setUpAllTitles];
    
    
    
}
#pragma mark --- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViewControllers.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    //移除之前的子控件
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //添加控制器
    UIViewController *VC = self.childViewControllers[indexPath.row];
    VC.view.frame = CGRectMake(0, 0, self.contentScrollView.width, self.contentScrollView.height);
    
    [cell.contentView addSubview:VC.view];
    
    return cell;
    
}
#pragma --- UIScrollViewDelegate

/**
 scrollView减速完成
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger offSetInx = offSetX;
    NSInteger screenWInt = CMScreenW;
    NSInteger extre = offSetInx % screenWInt;
    
    if (extre > CMScreenW*0.5) {
        //往右边移动
        offSetX = offSetX + (CMScreenW - extre);
        _isAniming = YES;
        [self.contentScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    } else if (extre < CMScreenW * 0.5 && extre > 0){
        _isAniming = YES;
        offSetX = offSetX - extre;
        [self.contentScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    }
    
    //获取角标
    NSInteger i = offSetX / CMScreenW;
    
    //选中标题
    [self setDefaultSelectedLabel:self.titleLabels[i]];
    
    //取出对应控制器发出通知
    
    UIViewController *vc = self.childViewControllers[i];
    
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:CMDisplayViewClickOrScrollDidFinshNote object:vc];
    
}
/**
 监听滚动视图动画完成（可以用_isAniming属性标示动画状态）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isAniming = NO;


}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //点击动画的时候不需要设置
    if (_isAniming || self.titleLabels.count == 0) return;
    
    //获取偏移量
    CGFloat offSetX = scrollView.contentOffset.x;
    
    //获取左边角标
    NSInteger leftIndex = offSetX / CMScreenW;
    
    //左边按钮
    CMDisplayTitleLabel *leftLabel = self.titleLabels[leftIndex];
    
    //右边角标
    NSInteger rightIndex = leftIndex + 1;
    //右边角标
    CMDisplayTitleLabel *rightLabel = nil;
    
    if (rightIndex < self.titleLabels.count) {
        rightLabel = self.titleLabels[rightIndex];
    }
    //字体放大
    [self setUpTitleScaleWithOffset:offSetX rightLabel:rightLabel leftLabel:leftLabel];
    
    //设置下标偏移
    
    //设置标题渐变
    
    //记录上一次的偏移量
    
}

@end
