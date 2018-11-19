//
//  YFReleaseGoodsMsgTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFHomeDataModel;
@interface YFReleaseGoodsMsgTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *weightLbl;
@property (weak, nonatomic) IBOutlet UITextField *leftTF;
@property (weak, nonatomic) IBOutlet UITextField *centerTF;
@property (weak, nonatomic) IBOutlet UITextField *rightTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherDesCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@property (nonatomic, strong) YFHomeDataModel *model;
@property (nonatomic, assign) CGFloat cellHeight;
/**
 s输入框是否有小数点
 */
@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, copy) void (^backUpdataCellHeightBlock)(CGFloat);
@end
