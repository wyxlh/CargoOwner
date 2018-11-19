//
//  YFAddressPickView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AdressBlock) (NSString *province,NSString *city,NSString *town, NSString *provinceID,NSString *cityID,NSString *townID);

@interface YFAddressPickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,copy)AdressBlock block;

+ (instancetype)shareInstance;

/**
 重新刷新
 */
+ (void)resetPicker;


@property (nonatomic, copy) void(^startPlaceBlock)(NSString *);

#pragma mark - get data
- (void)getPickerDataWithProvince:(NSArray *)ProvinceArr CityArr:(NSDictionary *)CityArr ProvinceId:(NSString *)province CityId:(NSString *)city DistrictId:(NSString *)district;

@end
