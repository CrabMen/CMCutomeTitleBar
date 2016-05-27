//
//  requestCover.m
//  CMCustomeTitleBar
//
//  Created by CrabMan on 16/5/27.
//  Copyright © 2016年 CrabMan. All rights reserved.
//

#import "requestCover.h"

@interface requestCover ()

@property (nonatomic,strong) UIImageView *animationView;


@end

@implementation requestCover

-(UIImageView *)animationView {
    if (!_animationView) {
        _animationView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CMScreenW/2, CMScreenW/2)];
        
        self.animationView.center = self.center;
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i <= 10; i++) {
            
            NSString *imageName = [NSString stringWithFormat:@"%d.png",i];
            UIImage *image = [UIImage imageNamed:imageName];
            [images addObject:image];
        }
        
        self.animationView.animationRepeatCount = MAXFLOAT;
        self.animationView.animationImages = images;
        self.animationView.animationDuration = 1;
        [ self.animationView startAnimating];
        
    }

        
    return _animationView;
}


+ (instancetype)show {


    return [[self alloc]init];

}

-(instancetype)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, CMScreenW, CMScreenH);
        self.backgroundColor = [UIColor whiteColor];

        
        
        [self addSubview:self.animationView];
    }
    return self;
}
@end
