//
//  YFGoodsDetailDriverTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/7/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFDriverDetailModel;
@class YFMayBeCarModel;

@interface YFGoodsDetailDriverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *driverName;
/**查看时*/
@property (weak, nonatomic) IBOutlet UILabel *lookTime;
/**车牌号*/
@property (weak, nonatomic) IBOutlet UILabel *carNum;
/**交易次数*/
@property (weak, nonatomic) IBOutlet UILabel *count;
/**地址*/
@property (weak, nonatomic) IBOutlet UILabel *address;
/**联系司机*/
@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;
/**指派下单*/
@property (weak, nonatomic) IBOutlet UIButton *createOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIView *btnBGView;
/*选中的第一个还是第二个*/
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong, nullable) YFDriverDetailModel *driverModel;
@property (nonatomic, strong, nullable) YFMayBeCarModel *Lmodel;
@property (nonatomic, strong, nullable) YFBaseViewController *superVC;
@end
