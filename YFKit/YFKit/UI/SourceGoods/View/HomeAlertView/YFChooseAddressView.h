//
//  YFChooseAddressView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFChooseAddressView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout>
NS_ASSUME_NONNULL_BEGIN
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger selectIndex;
/**
 省Array
 */
@property (nonatomic, strong) NSMutableArray *proArr;

/**
 选中的省
 */
@property (nonatomic, copy)   NSString *selectProName;
/**
  选中的省Code
 */
@property (nonatomic, copy)   NSString *selectProCode;
/**
 市Array
 */
@property (nonatomic, strong) NSMutableArray *cityArr;

@property (nonatomic, strong) NSDictionary *AllCityDict;

/**
 选中的市
 */
@property (nonatomic, copy)   NSString *selectCityName;
/**
  选中的市Code
 */
@property (nonatomic, copy)   NSString *selectCityCode;
/**
 区Array
 */
@property (nonatomic, strong) NSMutableArray *areaArr;
/**
 选中的区
 */
@property (nonatomic, copy)   NSString *selectAreaName;
/**
  选中的区Code
 */
@property (nonatomic, copy)   NSString *selectAreaCode;
/**
 重置
 */
-(void)resetData;

@property (nonatomic, copy) void (^chooseDetailAddressBlock)(NSString *,NSString *);
NS_ASSUME_NONNULL_END
@end
