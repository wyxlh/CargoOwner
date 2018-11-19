//
//  YukiWebProgressLayer.h
//  YukiFramework
//
//  Created by 王宇 on 2018/1/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface YukiWebProgressLayer : CAShapeLayer
//开始加载
-(void)startLoad;
//加载完成
-(void)finishedLoadWithError:(NSError *)error;
//关闭时间
-(void)closeTimer;

- (void)webViewPathChanged:(CGFloat)estimatedProgress;
@end
