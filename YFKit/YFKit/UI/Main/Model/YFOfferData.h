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
+ (YFOfferData *)shareInstace;
@end
