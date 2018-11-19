//
//  UIImage+Extension.h
//  YFKit
//
//  Created by 王宇 on 2018/10/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

/**
 传入一个 RGB 颜色值

 @param color color description
 @return return value description
 */
+ (UIImage *)imageWithBgColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
