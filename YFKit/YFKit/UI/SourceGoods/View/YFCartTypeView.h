//
//  YFCartTypeView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFCartTypeView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *typeArr,*lengthArr;//车型,车长
@end
