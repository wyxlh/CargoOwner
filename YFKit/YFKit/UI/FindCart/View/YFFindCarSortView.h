//
//  YFFindCarSortView.h
//  YFKit
//
//  Created by 王宇 on 2018/6/25.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFFindCarSortView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong, nullable) UICollectionView *collectionView;
/**
 车型车长数据源
 */
@property (nonatomic, strong) NSArray *typeDataArr,*lengthDatArr,*headTitleArr;
/**
已选车型 和历史车型
 */
@property (nonatomic, strong) NSMutableArray *selectTypeArr,*historyTypeArr,*selctLengthArr,*historyLengthArr;

/**
 重置选中状态
 */
@property (nonatomic, copy) void (^resetSelectTypeBlock)(NSMutableArray *);

/**
 判断是否是车型 反之为车长
 */
@property (nonatomic, assign) BOOL isCarType;

/**
 消失
 */
- (void)disappear;

/**
 显示
 */
- (void)showView;

/**
 重置
 */
- (void)resetData;
@end
