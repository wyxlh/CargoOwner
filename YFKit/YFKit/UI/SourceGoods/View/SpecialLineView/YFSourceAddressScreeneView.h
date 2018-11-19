//
//  YFSourceAddressScreeneView.h
//  YFKit
//
//  Created by 王宇 on 2018/8/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSourceAddressScreeneView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
NS_ASSUME_NONNULL_BEGIN
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong, nullable) UICollectionView *collectionView;
/**
 车型车长数据源 proArr
 */
@property (nonatomic, strong) NSArray *startProArr,*endProArr,*headTitleArr;
/**
 选中的省
 */
@property (nonatomic, copy)   NSString *selectProName;
/**
 市Array
 */
@property (nonatomic, strong) NSMutableArray *cityArr;
/**
 选中的市
 */
@property (nonatomic, copy)   NSString *selectCityName;
/**
 区Array
 */
@property (nonatomic, strong) NSMutableArray *areaArr;
/**
 选中的区
 */
@property (nonatomic, copy)   NSString *selectAreaName;
/**
 目的地完整地址(拼接的)
 */
@property (nonatomic, strong) NSMutableArray *completeEndArr;
/**
 历史
 */
@property (nonatomic, strong) NSMutableArray *selectStartArr,*historyStartArr,*selctEndArr,*historyEndArr;
/**
 记录选中的省和市
 */
@property (nonatomic, assign) NSInteger selectProIndex, selectCityIndex;

/**
 重置选中状态 NSString 是出发地 用的,NSArray是目的地用的
 */
@property (nonatomic, copy) void (^resetSelectTypeBlock)(NSString *, NSMutableArray *);

/**
 判断是否出发地
 */
@property (nonatomic, assign) BOOL isStart;

@property (nonatomic, assign) BOOL isEqualSelect;

/**
 消失
 */
- (void)disappear;

/**
 显示
 */
- (void)showView;
NS_ASSUME_NONNULL_END
@end
