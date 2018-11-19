//
//  YFCartTypeView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFCarTypeModel.h"
@interface YFCartTypeView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <YFCarTypeModel *> *typeArr,*lengthArr;//车型,车长
@property (nonatomic, copy) NSString *carType,*carlength;//车型,车长
@property (nonatomic, assign) NSInteger selectTypeIndex,selectLengthIndex;//选中的是哪一行
@property (nonatomic, copy) void(^callBackCarTypeBlock)(NSString *,NSString *);
/**
 刷新
 */
-(void)refresh;
@end
