//
//  YFItemCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFCarTypeModel;
@class YFChooseAddressModel;
@interface YFItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
/**当前是选的省 or 市 or 区 , 选中的第几个 如果是第一个需要特殊处理*/
@property (nonatomic, assign) NSInteger selectIndex,selectRow;
@property (nonatomic, strong) YFCarTypeModel *model;
@property (nonatomic, strong) YFChooseAddressModel *AddressModel;
@end
