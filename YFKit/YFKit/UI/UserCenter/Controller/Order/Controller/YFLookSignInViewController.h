//
//  YFLookSignInViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"

typedef NS_ENUM(NSInteger, KSImageManagerType) {
    KSImageManagerTypeYYWebImage,
    KSImageManagerTypeSDWebImage
};

@interface YFLookSignInViewController : YFBaseViewController
@property (nonatomic, assign) KSPhotoBrowserInteractiveDismissalStyle dismissalStyle;
@property (nonatomic, assign) KSPhotoBrowserBackgroundStyle backgroundStyle;
@property (nonatomic, assign) KSPhotoBrowserPageIndicatorStyle pageindicatorStyle;
@property (nonatomic, assign) KSPhotoBrowserImageLoadingStyle loadingStyle;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) KSImageManagerType imageManagerType;
@property (nonatomic, copy, nullable) NSString *taskId;
@end
