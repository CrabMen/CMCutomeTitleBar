//
//  CMDispalyViewController.h
//  CMCustomTitleBar
//
//  Created by CrabMan on 16/5/1.
//  Copyright © 2016年 CrabMan. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 填充样式
 1.填充颜色为RGB，根据RGB的值设置不同颜色
 2.默认的颜色填充，可以设置选中的颜色和normal颜色
 */
typedef enum : NSUInteger{
    CMTitleColorGradientStyleRGB,
    CMTitleColorGradientStyleFill,

} CMTitleColorGradientStyle;


@interface CMDispalyViewController : UIViewController

#pragma mark --- 内容视图
/**
 内容是否全屏
（YES：大小为屏幕大小，可以透过标题栏和导航栏；NO：从标题栏一下开始）
 */
@property (nonatomic,assign) BOOL isFullScreen;
/**
 根据角标，选中对应的视图控制器
 */
@property (nonatomic,assign) NSInteger selectedIndex;

/**是否可以全屏滑动*/
@property (nonatomic,assign) BOOL cm_fullScreenGesture;


- (void)setUpContentViewFrame:(void (^)(UIView *contentView))contentViewBlock ;



#pragma mark --- 标题
/**
 
 标题滚动视图背景颜色
 */
@property (nonatomic,strong) UIColor *titleScrollViewColor;

/**
 标题高度
 */
@property (nonatomic,assign) CGFloat titleHeight;


/**
 标题正常颜色
 */
@property (nonatomic,strong) UIColor *normalColor;

/**
标题选中颜色
 */
@property (nonatomic,strong) UIColor *selectedColor;


/**
 标题字体
 */
@property (nonatomic,strong) UIFont *titleFont;

/**标题栏下方分割线的颜色*/
@property (nonatomic,strong) UIColor *cm_seperaterLineColor;

/**标题分割线的高度*/
@property (nonatomic,assign) CGFloat cm_seperateLineH;




/**
  设置标题的所有属性
 */
- (void)setUpTitleEffect:(void(^)(UIColor **titleScrollViewColor,UIColor **norColor,UIColor **selColor,UIFont **titleFont,CGFloat *titleHeight))titleEffectBlock;


#pragma  mark --- 下标
/**
 是否需要下标
 */
@property (nonatomic, assign) BOOL isShowUnderLine;


/**
 是否延迟滚动下标
 */
@property (nonatomic, assign) BOOL isDelayScroll;

/**
 下标颜色
 */
@property (nonatomic, strong) UIColor *underLineColor;

/**
 下标高度
 */
@property (nonatomic, assign) CGFloat underLineH;
// 一次性设置所有下标属性
- (void)setUpUnderLineEffect:(void(^)(BOOL *isShowUnderLine,BOOL *isDelayScroll,CGFloat *underLineH,UIColor **underLineColor))underLineBlock;

#pragma mark --- 标题字体缩放
/**
 字体放大
 */
@property (nonatomic, assign) BOOL isShowTitleScale;

/**
 字体缩放比例
 */
@property (nonatomic, assign) CGFloat titleScale;

// 一次性设置所有字体缩放属性
- (void)setUpTitleScale:(void(^)(BOOL *isShowTitleScale,CGFloat *titleScale))titleScaleBlock;


#pragma mark --- 标题字体颜色渐变
/**
 字体是否渐变
 */
@property (nonatomic, assign) BOOL isShowTitleGradient;

/**
 颜色渐变样式
 */
@property (nonatomic, assign) CMTitleColorGradientStyle titleColorGradientStyle;

/**
 开始颜色,取值范围0~1
 */
@property (nonatomic, assign) CGFloat startR;

@property (nonatomic, assign) CGFloat startG;

@property (nonatomic, assign) CGFloat startB;

/**
 完成颜色,取值范围0~1
 */
@property (nonatomic, assign) CGFloat endR;

@property (nonatomic, assign) CGFloat endG;

@property (nonatomic, assign) CGFloat endB;

// 一次性设置所有颜色渐变属性
- (void)setUpTitleGradient:(void(^)(BOOL *isShowTitleGradient,CMTitleColorGradientStyle *titleColorGradientStyle,CGFloat *startR,CGFloat *startG,CGFloat *startB,CGFloat *endR,CGFloat *endG,CGFloat *endB))titleGradientBlock;


#pragma mark --- 标题文字遮罩
/**
 是否显示遮盖
 */
@property (nonatomic, assign) BOOL isShowTitleCover;

/**
 遮盖颜色
 */
@property (nonatomic, strong) UIColor *coverColor;

/**
 遮盖圆角半径
 */
@property (nonatomic, assign) CGFloat coverCornerRadius;

//一次性设置所有遮盖属性
- (void)setUpCoverEffect:(void(^)(BOOL *isShowTitleCover,UIColor **coverColor,CGFloat *coverCornerRadius))coverEffectBlock;


/**
 刷新标题和整个界面，在调用之前，必须先确定所有的子控制器。
 */
- (void)refreshDisplay;

@end
