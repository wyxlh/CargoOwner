//
//  YFSpecialLineListModel.m
//  YFKit
//
//  Created by 王宇 on 2018/9/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineListModel.h"

@implementation YFSpecialLineListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"goodsModel":@"YFSpecialGoodsModel"};
}

@end

@implementation YFSpecialGoodsModel



@end
