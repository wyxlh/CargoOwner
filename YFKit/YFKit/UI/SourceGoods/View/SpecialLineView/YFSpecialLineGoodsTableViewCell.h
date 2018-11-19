//
//  YFSpecialLineGoodsTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFHomeDataModel;

@interface YFSpecialLineGoodsTableViewCell : UITableViewCell<UITextFieldDelegate>
/**
 删除按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
/**
 第几个
 */
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
/**体积
 */
@property (weak, nonatomic) IBOutlet UITextField *volumeTF;
/**
 重量
 */
@property (weak, nonatomic) IBOutlet UITextField *weightTF;
/**
 件数
 */
@property (weak, nonatomic) IBOutlet UITextField *countTF;
/**
 运费
 */
@property (weak, nonatomic) IBOutlet UITextField *freeTF;
/**
 件数(件) 要设置富文本
 */
@property (weak, nonatomic) IBOutlet UILabel *countTitle;
/**
 重量 (kg)要设置富文本
 */
@property (weak, nonatomic) IBOutlet UILabel *weightTitle;
/**
 体积(方)要设置富文本
 */
@property (weak, nonatomic) IBOutlet UILabel *volumeTitle;
/**
 运费 lbl
 */
@property (weak, nonatomic) IBOutlet UILabel *feeLbl;

/**
  货品名称
 */
@property (weak, nonatomic) IBOutlet UITextField *title;
/**
 货品名称
 */
@property (weak, nonatomic) IBOutlet UIButton *goodsNameBtn;
/**
 编辑运费的时候刷新数据
 */
@property (nonatomic, copy) void(^editRefreshBlock)(void);

/**
 s输入框是否有小数点
 */
@property (nonatomic, assign) BOOL isHaveDian;

/**
判断运费是否有变化
 */
@property (nonatomic, copy) NSString *isChangeString;

@property (nonatomic, strong) YFHomeDataModel *model;

@end
