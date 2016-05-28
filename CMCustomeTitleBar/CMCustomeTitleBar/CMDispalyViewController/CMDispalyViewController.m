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
        _selectedColor = [UIColor colorWithRed:_endR?_endR:1 green:_endG blue:_endB alpha:1];
    } else {
        
        _selectedColor = [UIColor redColor];
    }
    return _selectedColor;
}

//重写titleMargin getter方法获得间距
- (CGFloat)titleMargin {
    
    NSArray *titles = [self.childViewControllers valueForKeyPath:@"title"];
    CGFloat totalLabelWidth = 0;
    
    if (totalLabelWidth == 0) {
        for (NSString *title in titles) {
            
            CGFloat labelWidth = [self setUpLabelWidthAccordingToTitle:title].size.width;
            
            totalLabelWidth += labelWidth;
        }
    }
  
    
    if (totalLabelWidth  >= CMScreenW) {
        _titleMargin = margin;
        
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
    } else {
        
        CGFloat titleMargin = (CMScreenW - self.labesTotalWidth)/(self.childViewControllers.count + 1);
        
        _titleMargin = titleMargin < margin ? margin : titleMargin;
        
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
    }

    return _titleMargin;
}


-(NSMutableArray *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}


/**
 懒加载：选中标题
 */

-(void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (self.titleLabels.count) {
        UILabel *label = self.titleLabels[selectedIndex];
        
        [self clickLabel:[label.gestureRecognizers lastObject]];
    }


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


-(UIView *)underLine {

    if (!_underLine) {
        UIView *underLineView = [UIView new];
        underLineView.backgroundColor = _underLineColor ? _underLineColor : [UIColor redColor];
        
        [self.titleScrollView addSubview:underLineView];
        
        _underLine = underLineView;
    }
    
    return _isShowUnderLine ? _underLine : nil;

}

-(UIView *)coverView {

    if (!_coverView) {
        
        UIView *coverView = [UIView new];
        
        coverView.backgroundColor = _coverColor ? _coverColor : [UIColor lightGrayColor];
        
        coverView.layer.cornerRadius = _coverCornerRadius ? _coverCornerRadius : CMCoverCornerRadius;
        
        [self.titleScrollView insertSubview:coverView atIndex:0
        ];
        _coverView = coverView;
    }
    return _isShowTitleCover?_coverView:nil;
    
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

#pragma mark --- 视图声明周期方法

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
        
        
        [self setUpAllTitles];
        
        
    }
}



#pragma mark --- 设置标题

/**
 设置标题label的位置和内容
 */
- (void)setUpAllTitles {
    CGFloat labelX = 0;
    CGFloat labelW = 0;
    NSArray *titles = [self.childViewControllers valueForKeyPath:@"title"];
    
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
       
      
        
        
        //设置label 的宽度
        labelW = [self setUpLabelWidthAccordingToTitle:titles[i]].size.width;
        label.frame = CGRectMake(labelX, 0, labelW, CMTitleScrollViewH);
        
        
        //设置label可以与用户交互
        label.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLabel:)];
        [label addGestureRecognizer:tap];
        //监听标题的点击事件
        
        [self.titleLabels addObject:label];
        [self.titleScrollView addSubview:label];
        
        //设置标题的默认点击位置,默认是0
        if (i == _selectedIndex) {
            [self clickLabel:tap];
        }
    }
    //设置标题的滚动视图的contentSize
    UILabel *lastLabel = [self.titleLabels lastObject];
   
    //设置默认点击label
    self.titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), 0);
    
    //设置内容滚动视图的contentSize
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * CMScreenW, 0);
    

}


#pragma mark --- 标题点击效果

/**
 标题的点击方法
 */
- (void)clickLabel:(UITapGestureRecognizer *)tap {
    // 记录是否点击标题,通过这个属性防止标题二次偏移
    _isClickTitle = YES;
    
    // 获取对应标题label
    UILabel *label = (UILabel *)tap.view;
    
    // 选中label
    [self selectLabel:label];
    
    
    self.contentScrollView.contentOffset = CGPointMake(label.tag * CMScreenW, 0);
    
    // 记录上一次偏移量,因为点击的时候不会调用scrollView代理记录，因此需要主动记录
    _lastOffsetX = label.tag * CMScreenW;
    
    // 添加控制器
    UIViewController *vc = self.childViewControllers[label.tag];
    
    // 判断控制器的view有没有加载，没有就加载，加载完在发送通知
    if (vc.view) {
        
        // 发出通知点击标题通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CMDisplayViewClickOrScrollDidFinshNote  object:vc];
        
        // 发出重复点击标题通知
        if (_selIndex == label.tag) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CMDisplayViewRepeatClickTitleNote object:vc];
        }
    }
    
    _selIndex = label.tag;
    
    // 点击事件处理完成
    _isClickTitle = NO;
    
}

/**
 选中标题Label的设置
 */
- (void)selectLabel:(UILabel *)label {
    
    
    for (CMDisplayTitleLabel *labelView in self.titleLabels) {
        
        if (label == labelView) continue;
        
        
        labelView.transform = CGAffineTransformIdentity;

        labelView.textColor = self.normalColor;
        
        if (_isShowTitleGradient && _titleColorGradientStyle == CMTitleColorGradientStyleFill) {
            
            labelView.fillColor = self.normalColor;
            
            labelView.progress = 1;
        }
        
    }
    
    // 标题缩放
    if (_isShowTitleScale ) {
        
        CGFloat scaleTransform = _titleScale?_titleScale:CMTitleTransformScale;
        
        label.transform = CGAffineTransformMakeScale(scaleTransform, scaleTransform);
    }

    
    label.textColor = self.selectedColor;
    
    // 设置标题居中
    [self setLabelTitleCenter:label];
    
    //设置遮罩
    [self setUpCoverView:label];
    
    //设置下标位置
    [self setUpUnderLine:label];
    
}



/**
 根据label的内容动态获得label的bounds
 */
- (CGRect)setUpLabelWidthAccordingToTitle:(NSString *)title {
   
    //如果没有设置vc的title，设置抛异常
    if ([title isKindOfClass:[NSNull class]]) {
        NSException *exception = [NSException exceptionWithName:@"CMDisplayViewControllerException" reason:@"未设置对应的childController的title属性" userInfo:nil];
        [exception raise];
    }
    _titleFont = _titleFont ? _titleFont : CMTitleFont;
    CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    
    return titleBounds;
}


/**
 让选中的按钮居中显示
 */
- (void)setLabelTitleCenter:(UILabel *)label
{
    
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = label.center.x - CMScreenW * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - CMScreenW + _titleMargin;
    
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 滚动区域
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}


/**
 设置 遮罩
 */
-(void) setUpCoverView:(UILabel *)label {
    
   CGRect titleBounds = [self setUpLabelWidthAccordingToTitle:label.text];
    
    CGFloat border = 5;
    CGFloat coverH = titleBounds.size.height + 2 * border;
    CGFloat coverW = titleBounds.size.width + 2 * border;
    
    self.coverView.y = (label.height - coverH) * 0.5;
    self.coverView.height = coverH;
    
    //最开始的时候不需要动画(即x等于0的时候)
    if (self.coverView.x ) {
        self.coverView.width = coverW;
        
        self.coverView.x = label.x - border;
    } else {
        
        
        [UIView animateWithDuration:0.25 animations:^{
            self.coverView.width = coverW;
            
            self.coverView.x = label.x - border;
            
        }];
        
    }
    
    
}


// 设置下标的位置
- (void)setUpUnderLine:(UILabel *)label
{
    // 获取文字尺寸
    CGRect titleBounds = [self setUpLabelWidthAccordingToTitle:label.text];
    CGFloat underLineH = _underLineH ? _underLineH : CMUnderLineH;
    
    self.underLine.y = label.height - underLineH;
    self.underLine.height = underLineH;
    
    
    // 最开始不需要动画
    if (self.underLine.x == 0) {
        self.underLine.width = titleBounds.size.width;
        
        self.underLine.x = label.x;
       
    } else {
    
        // 点击时候需要动画
        [UIView animateWithDuration:0.25 animations:^{
            self.underLine.width = titleBounds.size.width;
            self.underLine.x = label.x;
            }];
    }
    
}




#pragma mark --- 标题各效果渐变

/**
 设置标题的颜色渐变
 */
- (void)setUpTitleColorGradientWithOffset:(CGFloat)offsetX rightLabel:(CMDisplayTitleLabel *)rightLabel leftLabel:(CMDisplayTitleLabel *)leftLabel {

    if (_isShowTitleGradient == NO) return;
    
    NSLog(@"颜色渐变效果被调用");
    
    // 获取右边缩放
    CGFloat rightSacle = offsetX / CMScreenW - leftLabel.tag;
    
    // 获取左边缩放比例
    CGFloat leftScale = 1 - rightSacle;
    
    // RGB渐变
    if (_titleColorGradientStyle == CMTitleColorGradientStyleRGB) {
        
        CGFloat r = _endR - _startR;
        CGFloat g = _endG - _startG;
        CGFloat b = _endB - _startB;
        
        // rightColor
        // 1 0 0
        UIColor *rightColor = [UIColor colorWithRed:_startR + r * rightSacle green:_startG + g * rightSacle blue:_startB + b * rightSacle alpha:1];
        
        // 0.3 0 0
        // 1 -> 0.3
        // leftColor
        UIColor *leftColor = [UIColor colorWithRed:_startR +  r * leftScale  green:_startG +  g * leftScale  blue:_startB +  b * leftScale alpha:1];
        
        // 右边颜色
        rightLabel.textColor = rightColor;
        
        // 左边颜色
        leftLabel.textColor = leftColor;
        
        return;
    }
    
    // 填充渐变
    if (_titleColorGradientStyle == CMTitleColorGradientStyleFill) {
        
        // 获取移动距离
        CGFloat offsetDelta = offsetX - _lastOffsetX;
        
        if (offsetDelta > 0) { // 往右边
            
            
            rightLabel.fillColor = self.selectedColor;
            rightLabel.progress = rightSacle;
            
            leftLabel.fillColor = self.normalColor;
            leftLabel.progress = rightSacle;
            
        } else if(offsetDelta < 0){ // 往左边
            
            rightLabel.textColor = self.normalColor;
            rightLabel.fillColor = self.selectedColor;
            rightLabel.progress = rightSacle;
            
            leftLabel.textColor = self.selectedColor;
            leftLabel.fillColor = self.normalColor;
            leftLabel.progress = rightSacle;
            
        }
    }

}


/**
 标题缩放
 */
- (void)setUpTitleScaleWithOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel {
    if (_isShowTitleScale == NO) return;
    //获取右边的缩放
    CGFloat rightScale = offsetX / CMScreenW - leftLabel.tag;
    
    CGFloat leftScale = 1 - rightScale;
    
    //左右按钮缩放计算
    CGFloat scaleTransform = _titleScale?_titleScale:CMTitleTransformScale;
    
    scaleTransform -= 1;
    //
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * scaleTransform + 1, leftScale * scaleTransform + 1);
    
    rightLabel.transform = CGAffineTransformMakeScale(rightScale * scaleTransform + 1, rightScale * scaleTransform +1);
    
    
}



/**
 设置遮罩偏移即遮罩的x
 */
- (void)setUpCoverOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel {

//通过判断isClickTitle的属性来防止二次偏移
    
    if (_isClickTitle) return;
    
    //获取两个标题x的距离
    CGFloat deltaX = rightLabel.x - leftLabel.x;
    
    //标题宽度的差值
    CGFloat deltaWidth = [self setUpLabelWidthAccordingToTitle:rightLabel.text].size.width - [self setUpLabelWidthAccordingToTitle:leftLabel.text].size.width;
    
    //移动距离
    CGFloat deltaOffSet = offsetX -_lastOffsetX;
    
    /*计算当前的偏移量
    deltaOffSet / CMScreen = coverTransformX / deltaX;
     
     计算宽度偏增量
      deltaOffSet / CMScreen = coverWidth / deltaWidth;
     */
    
    CGFloat coverTransformX = deltaOffSet * deltaX / CMScreenW;
    
    // 宽度递增偏移量
    CGFloat coverWidth = deltaOffSet * deltaWidth / CMScreenW;

    self.coverView.width += coverWidth;
    self.coverView.x += coverTransformX;
}

/**
 设置下标偏移
 */
- (void)setUpUnderLineOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel {
    if (_isClickTitle) return;
    
    //获取两个标题x的距离
    CGFloat deltaX = rightLabel.x - leftLabel.x;
    
    //标题宽度的差值
    CGFloat deltaWidth = [self setUpLabelWidthAccordingToTitle:rightLabel.text].size.width - [self setUpLabelWidthAccordingToTitle:leftLabel.text].size.width;
    
    //移动距离
    CGFloat deltaOffSet = offsetX -_lastOffsetX;
    
    /*计算当前的偏移量
     deltaOffSet / CMScreen = underLineTransformX / deltaX;
     
     计算宽度偏增量
     deltaOffSet / CMScreen = underLineWidth / deltaWidth;
     */
    
    CGFloat underLineTransformX = deltaOffSet * deltaX / CMScreenW;
    
    // 宽度递增偏移量
    CGFloat underLineWidth = deltaOffSet * deltaWidth / CMScreenW;

    self.underLine.width += underLineWidth;
    self.underLine.x += underLineTransformX;
    
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
    [self selectLabel:self.titleLabels[i]];
    
    
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
    
    //设置遮罩偏移
    [self setUpCoverOffset:offSetX rightLabel:rightLabel leftLabel:leftLabel];
    
    //设置标题渐变
    [self setUpTitleColorGradientWithOffset:offSetX rightLabel:rightLabel leftLabel:leftLabel];
    
    if (_isDelayScroll == NO) { // 延迟滚动，不需要移动下标
        
        [self setUpUnderLineOffset:offSetX rightLabel:rightLabel leftLabel:leftLabel];
    }
    //记录上一次的偏移量
    _lastOffsetX = offSetX;
    
}

@end
