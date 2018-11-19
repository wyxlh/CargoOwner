//
//  JMUpdataImage.h
//  SKKit
//
//  Created by 王宇 on 16/7/16.
//  Copyright © 2016年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMUpdataImage : UIView

-(void)updateLogo:(UIViewController*)ViewController;

-(void)camera:(UIViewController*)ViewController;

@property (nonatomic,copy)void(^callBackImage)(NSString *,UIImage *);

/**
 判断是否是上传头像
 */
@property (nonatomic,assign) BOOL isUpUserLogo;
@end
