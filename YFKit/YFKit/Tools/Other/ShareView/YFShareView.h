//
//  YFShareView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/23.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YFShareContentType) {
    YFShareContentByAppType,//分享 APP
    YFShareContentBySourceType,//分享货源
};

@interface YFShareView : UIView
NS_ASSUME_NONNULL_BEGIN

- (instancetype)initWithFrame:(CGRect)frame shareType: (YFShareContentType)shareType;

/**
 title
 */
@property (nonatomic, copy) NSString *shareTitle;

/**
 分享内容
 */
@property (nonatomic, copy) NSString *shareContent;

/**
 分享图片
 */
@property (nonatomic, copy) NSString *shareImage;

/**
 分享链接
 */
@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic, strong) YFBaseViewController *superVC;
NS_ASSUME_NONNULL_END
@end
