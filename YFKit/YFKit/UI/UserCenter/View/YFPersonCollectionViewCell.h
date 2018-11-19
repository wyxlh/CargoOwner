//
//  YFPersonCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFPersonImageModel;
@interface YFPersonCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *IDCard;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UITextField *companyName;
/**
 是否允许编辑
 */
@property (nonatomic, assign) BOOL isUpdata;

@property (nonatomic, strong) YFPersonImageModel *model;
@end
