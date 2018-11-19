//
//  YFOfferData.m
//  YFKit
//
//  Created by 王宇 on 2018/5/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOfferData.h"

@implementation YFOfferData

+ (YFOfferData *)shareInstace{
    __strong static YFOfferData *offerData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        offerData = [[YFOfferData alloc]init];
    });
    return offerData;
}

@end
