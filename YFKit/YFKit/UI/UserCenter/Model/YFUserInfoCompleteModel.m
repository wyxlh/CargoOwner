//
//  YFUserInfoCompleteModel.m
//  YFKit
//
//  Created by 王宇 on 2018/10/22.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFUserInfoCompleteModel.h"

@implementation YFUserInfoCompleteModel

+ (YFUserInfoCompleteModel *)shareInstace{
    __strong static YFUserInfoCompleteModel *completeModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        completeModel = [[YFUserInfoCompleteModel alloc]init];
    });
    return completeModel;
}
@end
