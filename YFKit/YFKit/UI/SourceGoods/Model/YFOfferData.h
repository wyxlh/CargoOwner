//
//  YFOfferData.h
//  YFKit
//
//  Created by 王宇 on 2018/5/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFReleseDetailModel.h"

@interface YFOfferData : NSObject
@property (nonatomic, strong) YFReleseDetailModel *detailModel;
/**
 货源选中的页面
 */
@property (nonatomic, assign) NSInteger selectCtrl;

/**
 成功取消订单的数量
 */
@property (nonatomic, assign) NSInteger cancelOrderSuccessCount;
+ (YFOfferData *)shareInstace;
@end
