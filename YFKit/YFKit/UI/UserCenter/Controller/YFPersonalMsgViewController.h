//
//  YFPersonalMsgViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/5/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"
typedef NS_ENUM(NSInteger, KSImageManagerType) {
    KSImageManagerTypeYYWebImage,
    KSImageManagerTypeSDWebImage
};
@interface YFPersonalMsgViewController : YFBaseViewController
@property (nonatomic, assign) KSPhotoBrowserInteractiveDismissalStyle dismissalStyle;
@property (nonatomic, assign) KSPhotoBrowserBackgroundStyle backgroundStyle;
@property (nonatomic, assign) KSPhotoBrowserPageIndicatorStyle pageindicatorStyle;
@property (nonatomic, assign) KSPhotoBrowserImageLoadingStyle loadingStyle;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) KSImageManagerType imageManagerType;
@end
