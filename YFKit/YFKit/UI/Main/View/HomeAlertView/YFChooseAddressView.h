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
 省
 */
@property (nonatomic, strong) NSMutableArray *proArr;

/**
 选中的省
 */
@property (nonatomic, copy)   NSString *selectProName;
/**
 市
 */
@property (nonatomic, strong) NSMutableArray *cityArr;

@property (nonatomic, strong) NSDictionary *AllCityDict;

/**
 选中的市
 */
@property (nonatomic, copy)   NSString *selectCityName;
/**
 区
 */
@property (nonatomic, strong) NSMutableArray *areaArr;
/**
 选中的区
 */
@property (nonatomic, copy)   NSString *selectAreaName;
/**
 重置
 */
-(void)resetData;

@property (nonatomic, copy) void (^chooseDetailAddressBlock)(NSString *);
NS_ASSUME_NONNULL_END
@end
