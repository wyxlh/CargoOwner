//
//  YFOtherRequirementView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFOtherRequirementView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSString *otherRequire;//选中的货品
@property (nonatomic, strong) UITextField *otherTF;//其他货品名称
@property (nonatomic, strong) NSArray *RequireArr;//数据源
@property (nonatomic, assign) NSInteger selectIndex;//选中的第几个
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;
@property (nonatomic, copy) void(^callBackCarTypeBlock)(NSString *, NSString *);
/**
 刷新
 */
-(void)refresh;
@end
