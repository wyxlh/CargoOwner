//
//  NSArray+AddressMsg.m
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "NSArray+AddressMsg.h"


@implementation NSArray (AddressMsg)

#pragma mark 读取本地JSON文件
+ (NSArray *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

/**
 获取车型
 */
+ (NSArray *)getCartType {
    return @[ @{@"name":@"不限",@"isSelect":@0},
              @{@"name":@"厢式货车",@"isSelect":@0},
              @{@"name":@"厢式挂车",@"isSelect":@0},
              @{@"name":@"平板挂车",@"isSelect":@0},
              @{@"name":@"高栏车",@"isSelect":@0},
              @{@"name":@"高栏挂车",@"isSelect":@0},
              @{@"name":@"平板车",@"isSelect":@0},
              @{@"name":@"城配面包车",@"isSelect":@0},
              @{@"name":@"城配金杯车",@"isSelect":@0},
              @{@"name":@"普通货车",@"isSelect":@0},
              @{@"name":@"罐式货车",@"isSelect":@0},
              @{@"name":@"牵引车",@"isSelect":@0},
              @{@"name":@"普通挂车",@"isSelect":@0},
              @{@"name":@"罐式挂车",@"isSelect":@0},
              @{@"name":@"集装箱挂车",@"isSelect":@0},
              @{@"name":@"仓栏式货车",@"isSelect":@0},
              @{@"name":@"封闭货车",@"isSelect":@0},
              @{@"name":@"平板货车",@"isSelect":@0},
              @{@"name":@"集装箱车",@"isSelect":@0},
              @{@"name":@"自卸货车",@"isSelect":@0},
              @{@"name":@"特殊结构货车",@"isSelect":@0},
              @{@"name":@"专项作业车",@"isSelect":@0},
              @{@"name":@"车辆运输车",@"isSelect":@0},
              @{@"name":@"车辆运输车(单排)",@"isSelect":@0},
              @{@"name":@"其他车型",@"isSelect":@0}];
}
/**
 获取车长
 */
+ (NSArray *)getCarLength {
    return @[@{@"name":@"不限",@"isSelect":@0},@{@"name":@"2.5米",@"isSelect":@0},
             @{@"name":@"4.2米",@"isSelect":@0},@{@"name":@"5米",@"isSelect":@0},
             @{@"name":@"5.2米",@"isSelect":@0},@{@"name":@"6.2米",@"isSelect":@0},
             @{@"name":@"6.8米",@"isSelect":@0},@{@"name":@"7.2米",@"isSelect":@0},
             @{@"name":@"7.6米",@"isSelect":@0},@{@"name":@"8.2米",@"isSelect":@0},
             @{@"name":@"8.6米",@"isSelect":@0},@{@"name":@"9.6米",@"isSelect":@0},
             @{@"name":@"12.5米",@"isSelect":@0},@{@"name":@"13米",@"isSelect":@0},
             @{@"name":@"13.5米",@"isSelect":@0},@{@"name":@"14米",@"isSelect":@0},
             @{@"name":@"15米",@"isSelect":@0},@{@"name":@"16.5米",@"isSelect":@0},
             @{@"name":@"17.5米",@"isSelect":@0},@{@"name":@"18米",@"isSelect":@0},
             @{@"name":@"18.5米",@"isSelect":@0}];
}
/**
 获取货品名称
 */
+ (NSArray *)getGoodsName{
    return @[@{@"name":@"衣服",@"isSelect":@0},@{@"name":@"食品",@"isSelect":@0},
             @{@"name":@"设备",@"isSelect":@0},@{@"name":@"配件",@"isSelect":@0},
             @{@"name":@"百货",@"isSelect":@0},@{@"name":@"日化",@"isSelect":@0},
             @{@"name":@"饮料",@"isSelect":@0},@{@"name":@"建材",@"isSelect":@0},
             @{@"name":@"家具",@"isSelect":@0},@{@"name":@"钢材",@"isSelect":@0}];
}

/**
  获取其他要求
 */
+ (NSArray *)getOtherRequirement{
    return @[@{@"name":@"一装一卸",@"isSelect":@0},@{@"name":@"一装两卸",@"isSelect":@0},
             @{@"name":@"一装多卸",@"isSelect":@0},@{@"name":@"两装一卸",@"isSelect":@0},
             @{@"name":@"两装两卸",@"isSelect":@0},@{@"name":@"多装多卸",@"isSelect":@0}];
}

/**
 获取首页的 title 图片 和 placeholder
 @{@"title":@"指定司机",@"imgName":@"AppointPeople",@"placeholder":@"选择好友(非必填)",@"isCheck":@0} 发布货源的时候不要
 */
+ (NSArray *)getHomeData{
    return @[@[@{@"title":@"出发地",@"imgName":@"Originating",@"placeholder":@"点击选择",@"isCheck":@0},
               @{@"title":@"目的地",@"imgName":@"End",@"placeholder":@"点击选择",@"isCheck":@0}],
             @[@{@"title":@"货品类型",@"imgName":@"goodName",@"placeholder":@"点击选择",@"isCheck":@0},
               @{@"title":@"货物重量/体积/件数",@"imgName":@"weight",@"placeholder":@"点击选择",@"isCheck":@0}],
             @[@{@"title":@"车型车长",@"imgName":@"car",@"placeholder":@"点击选择",@"isCheck":@0},
               @{@"title":@"装货时间",@"imgName":@"loadingTime",@"placeholder":@"点击选择",@"isCheck":@0},
               @{@"title":@"期望运费",@"imgName":@"free",@"placeholder":@"非必填项",@"isCheck":@0},
               @{@"title":@"其他要求",@"imgName":@"more",@"placeholder":@"装卸要求、其他等",@"isCheck":@0}]];
}

/**
 获取订单的 title 图片 和 placeholder
 */
+(NSArray *)getOrderData{
    return @[@[@{@"title":@"请选择发货地址和联系人",@"imgName":@"Originating",@"placeholder":@"",@"isCheck":@0},
               @{@"title":@"请选择收货地址和联系人",@"imgName":@"End",@"placeholder":@"",@"isCheck":@0}],
             @[@{@"title":@"货品类型",@"imgName":@"goodName",@"placeholder":@"点击选择",@"isCheck":@0},
               @{@"title":@"货物重量/体积/件数",@"imgName":@"weight",@"placeholder":@"点击选择",@"isCheck":@0}],
             @[@{@"title":@"车型车长",@"imgName":@"car",@"placeholder":@"点击选择",@"isCheck":@0},
               @{@"title":@"装货时间",@"imgName":@"loadingTime",@"placeholder":@"点击选择",@"isCheck":@0},
               @{@"title":@"实际运费",@"imgName":@"free",@"placeholder":@"必填",@"isCheck":@0},
               @{@"title":@"其他要求",@"imgName":@"more",@"placeholder":@"装卸要求、其他等",@"isCheck":@0},
               @{@"title":@"指定司机",@"imgName":@"AppointPeople",@"placeholder":@"选择好友(必填)",@"isCheck":@0}]];
}

/**
 获取专线开单的 title 图片 和 placeholder
 */
+ (NSArray *)getSpecialLineData{
    return @[@[@{@"title":@"请选择发货地址和联系人",@"imgName":@"Originating",@"placeholder":@"",@"isCheck":@0,@"countNumTF":@"",@"weightTF":@"",@"volumeTF":@"",@"freeTF":@""},
               @{@"title":@"请选择收货地址和联系人",@"imgName":@"End",@"placeholder":@"",@"isCheck":@0,@"countNumTF":@"",@"weightTF":@"",@"volumeTF":@"",@"freeTF":@""}],
             @[@{@"title":@"货品",@"imgName":@"goodName",@"placeholder":@"",@"isCheck":@0,@"countNumTF":@"",@"weightTF":@"",@"volumeTF":@"",@"freeTF":@""},
               @{@"title":@"货品名称",@"imgName":@"free",@"placeholder":@"点击选择",@"isCheck":@0,@"countNumTF":@"",@"weightTF":@"",@"volumeTF":@"",@"freeTF":@""}],
             @[@{@"title":@"其他费用",@"imgName":@"free",@"placeholder":@"请填写其他费用",@"isCheck":@0,@"countNumTF":@"",@"weightTF":@"",@"volumeTF":@"",@"freeTF":@""},
               @{@"title":@"付款方式",@"imgName":@"more",@"placeholder":@"请选择付款方式",@"isCheck":@0,@"countNumTF":@"",@"weightTF":@"",@"volumeTF":@"",@"freeTF":@""},
               @{@"title":@"其他要求",@"imgName":@"more",@"placeholder":@"装卸要求,付款要求,其他等",@"isCheck":@0,@"countNumTF":@"",@"weightTF":@"",@"volumeTF":@"",@"freeTF":@""}]];
}

/**
 得到当前日期的后十天
 */
+ (NSArray *)getDateArray{
    NSInteger dis                           = 10; //前后的天数
    NSDate *nowDate                         = [NSDate date];
    NSDate *theDate;
    NSTimeInterval  oneDay                  = 24*60*60*1;  //1天的长度
    //用[NSDate date]可以获取系统当前时间
    NSMutableArray *dateArr                 = [NSMutableArray new];
    for (int i = 0; i < dis; i++) {
        //之后的天数
        theDate                             = [nowDate initWithTimeIntervalSinceNow: +oneDay*i ];
        //之前的天数
        //theDate                           = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter      = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //得到时间
        NSString * currentDateStr           = [dateFormatter stringFromDate:theDate];
        //加入数组中
        [dateArr addObject:currentDateStr];
        DLog(@"%@",currentDateStr);
    }
    return dateArr;
}

/**
 得到具体时间
 */
+(NSArray *)getTimeArray{
    return @[@"全天",@"上午(6:00-12:00)",@"下午(12:00-18:00)",@"晚上(18:00-24:00)"];
}

/**
 得到最近几天的数据
 */
+(NSArray *)getNearArrat{
    return @[@"今天",@"明天",@"后天"];
}

/**
 获取首页 title
 */
+ (NSArray *)getHomeTitleArray
{
    return @[@"附近仓库",@"附近工业园",@"附近物流公司",@"附近餐饮",@"附近住宿",@"附近停车场"];
}

/**
 获取首页 image
 */
+ (NSArray *)getHomeImageArray
{
    return @[@"Warehouse",@"nearIndustry",@"nearLogistic",@"food",@"live",@"Parking"];
}

/**
 获取首页 统计标识
 */
+ (NSArray *)getHomeIdentificationArray
{
    return @[@"NearbyWareHouse",@"NearbyIndustrialPark",@"NearbyLogisticsCompany",@"NearbyFoodAndBeverage",@"NearbyAccommodation",@"NearbyParking"];
}

/**
 获取个人中心 图标 title  为了让页面好看, 这里添加了几条空数据
 */
+(NSArray *)getUserCenterArray{
    return @[@[@{@"name":@"未完成",@"imgName":@"noComplete"},
               @{@"name":@"已完成",@"imgName":@"aComplete"},
               @{@"name":@"已取消",@"imgName":@"aCancen"}],
             @[@{@"name":@"个人资料",@"imgName":@"personMsg"},
               @{@"name":@"发货人管理",@"imgName":@"Consignor"},
               @{@"name":@"收货人管理",@"imgName":@"Consignee"},
               @{@"name":@"常用司机",@"imgName":@"MaturingCar"},
               @{@"name":@"推荐分享",@"imgName":@"share"}]];
}

/**
 获取设置 title
 */
+(NSArray *)getSettingArray{
    return @[@[@"登录账户"],@[@"重置密码",@"当前版本"],@[@"意见反馈",@"隐私政策",@"关于我们"]];
}

/**
 获取司机详情的开始地点和目的地 logo
 */
+(NSArray *)getDriverLogo{
    return @[@"Originating",@"BidPeople",@"End"];
}

/**
 开始 目的地图标
 */
+(NSArray *)getOnlyRoadLogo{
    return @[@"Originating",@"End"];
}

/**
 获取时间筛选条件
 */
+(NSArray *)getTimeSortData{
    return @[@"时间升序",@"时间降序"];
}

/**
 获取价格筛选条件
 */
+(NSArray *)getMoneySortData{
    return @[@"价格升序",@"价格降序"];
}

/**
 获取登录方式
 */
+ (NSArray *)getLoginModeData{
    return @[@"个人登录",@"组织登录"];
}

/**
 获取个人信息里面身份证信息 title
 */
+(NSArray *)getPersonIDCardTitle{
    return @[@{@"title":@"身份证正面",@"path":@""},
             @{@"title":@"身份证反面",@"path":@""},
             @{@"title":@"公司名片",@"path":@""},
             @{@"title":@"公司门头照",@"path":@""}];
}

/**
 获取车型的头部数组
 */
+(NSArray *)ChooseCarTypeHeadArray{
    return @[@"已选车型",@"历史选择",@"选择车型"];
}

/**
 获取车长的头部数组
 */
+(NSArray *)ChooseCarLengthHeadArray{
    return @[@"已选车长",@"历史选择",@"选择车长"];
}

/**
 得到选择地区的 title
 */
+(NSArray *)getChooseAddressHeadTitleArr{
    return @[@"已选区域",@"历史选择",@"选择:城市"];
}

/**
 读取历史出发地数据
 */
+(NSArray *)readStartAddressData{
    NSMutableArray *array =  [YFUserDefaults objectForKey:@"historyAddressStartArr"];
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    return array;
}

/**
 得到出发地历史数据
 
 @param startAddressArray 传入的数据
 */
+(NSArray *)saveStartAddressData:(NSMutableArray *)startAddressArray{
    //得到之前的
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NSArray readStartAddressData]];
    
    for (YFChooseAddressModel *model in startAddressArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict safeSetObject:model.address forKey:@"address"];
        [dict safeSetObject:model.detailAddress forKey:@"detailAddress"];
        [dict safeSetObject:@(0) forKey:@"isSelect"];
        [array insertObject:dict atIndex:0];
    }
    //移除重复数据
    NSMutableArray *listAry = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in array) {
        if (![listAry containsObject:dict]) {
            [listAry addObject:dict];
        }
    }
    if (listAry.count > 4) {
        NSMutableArray *endArr = (NSMutableArray *)[listAry subarrayWithRange:NSMakeRange(0, 4)];
        return endArr;
    }
    return listAry;
}

/**
 读取历史目的地数据
 */
+(NSArray *)readEndAddressData{
    NSMutableArray *array =  [YFUserDefaults objectForKey:@"historyAddressEndArr"];
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    return array;
}

/**
 得到目的地的历史数据
 
 @param endAddressArray 传入的数据
 */
+(NSArray *)saveEndAddressData:(NSMutableArray *)endAddressArray{
    //得到之前的
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NSArray readEndAddressData]];
    
    for (YFChooseAddressModel *model in endAddressArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict safeSetObject:model.address forKey:@"address"];
        [dict safeSetObject:model.detailAddress forKey:@"detailAddress"];
        [dict safeSetObject:@(0) forKey:@"isSelect"];
        [array insertObject:dict atIndex:0];
    }
    //移除重复数据
    NSMutableArray *listAry = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in array) {
        if (![listAry containsObject:dict]) {
            [listAry addObject:dict];
        }
    }
    if (listAry.count > 4) {
        NSMutableArray *endArr = (NSMutableArray *)[listAry subarrayWithRange:NSMakeRange(0, 4)];
        return endArr;
    }
    return listAry;
}

/**
 读取历史车型
 */
+(NSMutableArray *)readTypeData{
    NSMutableArray *array =  [YFUserDefaults objectForKey:@"HistoryTypeArr"];
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    return array;
}

/**
 得到车型车长的历史数据

 @param selectArray 传入的数据
 */
+(NSMutableArray *)saveCarTypeData:(NSMutableArray *)selectArray{
    //得到之前的
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NSArray readTypeData]];
    
    for (YFCarTypeModel *model in selectArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict safeSetObject:model.name forKey:@"name"];
        [dict safeSetObject:@(0) forKey:@"isSelect"];
        [array insertObject:dict atIndex:0];
    }
    //移除重复数据
    NSMutableArray *listAry = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in array) {
        if (![listAry containsObject:dict]) {
            [listAry addObject:dict];
        }
    }
    if (listAry.count > 4) {
        NSMutableArray *endArr = (NSMutableArray *)[listAry subarrayWithRange:NSMakeRange(0, 4)];
        return endArr;
    }
    return listAry;
}

/**
 读取历史车长
 */
+(NSMutableArray *)readLengthData{
    NSMutableArray *array =  [YFUserDefaults objectForKey:@"HistoryLengthArr"];
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    return array;
}

/**
 得到车长的历史数据
 
 @param selectArray 传入的数据
 */
+(NSMutableArray *)saveCarLengthData:(NSMutableArray *)selectArray{
    //得到之前的
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NSArray readLengthData]];
    
    for (YFCarTypeModel *model in selectArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict safeSetObject:model.name forKey:@"name"];
        [dict safeSetObject:@(0) forKey:@"isSelect"];
        [array insertObject:dict atIndex:0];
    }
    //移除重复数据
    NSMutableArray *listAry = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in array) {
        if (![listAry containsObject:dict]) {
            [listAry addObject:dict];
        }
    }
    if (listAry.count > 4) {
        NSMutableArray *endArr = (NSMutableArray *)[listAry subarrayWithRange:NSMakeRange(0, 4)];
        return endArr;
    }
    
    return listAry;
}

/**
 获取附近 logo
 */
+(NSArray *)getNearMapLogo{
    return @[@"WarehouseDetail",@"IndustrialParkDetail",@"TransportcomDetail",@"RestaurantDetail",@"accommodationDetail",@"Parkingcar"];
}
/**
 获取取消货源的原因
 */
+ (NSArray *)cancelSourceReasonData{
    return @[@{@"name":@"行程有变,暂时不需要用车",@"isSelect":@0},
             @{@"name":@"司机迟到",@"isSelect":@0},
             @{@"name":@"司机联系不上",@"isSelect":@0},
             @{@"name":@"其他",@"isSelect":@0}];
}

@end
