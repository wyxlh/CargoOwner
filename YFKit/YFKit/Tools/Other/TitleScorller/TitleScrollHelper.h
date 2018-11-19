//
//  TitleScrollHelper.h
//  titleScrollViewTest
//
//  Created by 王宇 on 16/5/17.
//  Copyright © 2016年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define mainTextColor [UIColor blackColor]
#define selectedColor [UIColor colorWithRed:0.094 green:0.204 blue:0.569 alpha:1.000]
#define titleFont [UIFont systemFontOfSize:14]
@interface TitleScrollHelper : NSObject
//计算间隔
+(CGFloat)caculateSpaceByTitleArray:(NSArray *)titleArray rect:(CGRect)rect;
//计算标题大小
+(CGSize)titleSize:(NSString *)title height:(CGFloat)height;
@end
