//
//  YFBiddingListModel.m
//  YFKit
//
//  Created by 王宇 on 2018/5/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBiddingListModel.h"

@implementation YFBiddingListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}


+(NSDictionary *)mj_objectClassInArray{
    return @{@"priceList":@"PriceListModel"};
}


@end

@implementation PriceListModel


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}


@end
