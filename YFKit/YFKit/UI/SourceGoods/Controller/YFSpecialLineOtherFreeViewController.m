//
//  YFSpecialLineOtherFreeViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/9/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineOtherFreeViewController.h"
#import "YFSpecialLineAdjustFreeView.h"
#import "YFSpecialLineModel.h"

@interface YFSpecialLineOtherFreeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *adjustPrice;//声明价值
@property (weak, nonatomic) IBOutlet UILabel *adjustServiceFree;//保价费
@property (weak, nonatomic) IBOutlet UILabel *collectionPrice;//代收货款
@property (weak, nonatomic) IBOutlet UILabel *collectionServiceFree;//手续费
@property (weak, nonatomic) IBOutlet UITextField *informationTF;//信息费
@property (weak, nonatomic) IBOutlet UITextField *takeGoodsTF;//提货费
@property (weak, nonatomic) IBOutlet UITextField *giveGoodsTF;//送货费
@property (weak, nonatomic) IBOutlet UITextField *returnOrderTF;//回单费
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;//确定
@property (nonatomic, strong) YFSpecialInterestRateModel *interestModel;//利率 Model
//*声明价值  代收货款 保价费和手续费*/
@property (nonatomic, assign) double adjustTotalPrice,collectionTotalPrice,adjustMoney,collectionMoney;
@property (nonatomic, strong, nullable) YFSpecialLineAdjustFreeView *adjustFreeView;//填写费用
@property (nonatomic, assign) BOOL isHaveDian;//输入框是否有小数点
@end

@implementation YFSpecialLineOtherFreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                                  = @"其他费用";
    self.view.backgroundColor                   = UIColorFromRGB(0xF5F5F5);
    SKViewsBorder(self.saveBtn, 3, 0, NavColor);
    if (self.specilLineModel) {
        //重新赋值
        [self reassignment];
    }else{
        self.adjustMoney                        = self.collectionMoney = self.adjustTotalPrice = self.collectionTotalPrice = 0.00;
    }
    self.informationTF.delegate                 = self;
    self.takeGoodsTF.delegate                   = self;
    self.returnOrderTF.delegate                 = self;
    self.giveGoodsTF.delegate                   = self;
    //验证8位数字
    [self inputValidation];
    
    //得到利率
    [self getInterest];
}

#pragma mark 得到利率
- (void)getInterest{
    @weakify(self)
    [WKRequest isHiddenActivityView:YES];
    [WKRequest getWithURLString:@"app/special/interest/rate.do" parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.interestModel                  = [YFSpecialInterestRateModel mj_objectWithKeyValues:baseModel.data];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 重新赋值
- (void)reassignment{
    //声明价值
    self.adjustPrice.text                        = [NSString stringWithFormat:@"%@元",self.specilLineModel.adjustTotalPrice];
    //保价费
    self.adjustServiceFree.text                  = [NSString stringWithFormat:@"保价费%.2f元",[self.specilLineModel.adjustMoney doubleValue]];
    self.adjustMoney                             = [self.specilLineModel.adjustMoney doubleValue];
    //代收汇款
    self.collectionPrice.text                    = [NSString stringWithFormat:@"%@元",self.specilLineModel.collectionTotalPrice];
    //手续费
    self.collectionServiceFree.text              = [NSString stringWithFormat:@"手续费%.2f元",[self.specilLineModel.collectionMoney doubleValue]];
    self.collectionMoney                         = [self.specilLineModel.collectionMoney doubleValue];
    //信息费
    self.informationTF.text                      = [self.specilLineModel.informationTF isEqualToString:@"0.00"] ? @"" : self.specilLineModel.informationTF;
    //提货费
    self.takeGoodsTF.text                        = [self.specilLineModel.takeGoodsTF isEqualToString:@"0.00"] ? @"" : self.specilLineModel.takeGoodsTF;
    //送货费
    self.giveGoodsTF.text                        = [self.specilLineModel.giveGoodsTF isEqualToString:@"0.00"] ? @"" : self.specilLineModel.giveGoodsTF;
    //装卸费
    self.returnOrderTF.text                      = [self.specilLineModel.returnOrderTF isEqualToString:@"0.00"] ? @"" : self.specilLineModel.returnOrderTF;
}

#pragma mark 输入验证 最多8位数
- (void)inputValidation{
    //信息费
    @weakify(self)
    [[self.informationTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string                         = [NSString stringWithFormat:@"%@",x];
        if (string.length > 6) {
            self.informationTF.text              = [string substringWithRange:NSMakeRange(0, 6)];
        }
    }];
    //提货费
    [[self.takeGoodsTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string                         = [NSString stringWithFormat:@"%@",x];
        if (string.length > 6) {
            self.takeGoodsTF.text                = [string substringWithRange:NSMakeRange(0, 6)];
        }
    }];
    //送货费
    [[self.giveGoodsTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string                         = [NSString stringWithFormat:@"%@",x];
        if (string.length > 6) {
            self.giveGoodsTF.text                = [string substringWithRange:NSMakeRange(0, 6)];
        }
    }];
    //回单费
    [[self.returnOrderTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string                         = [NSString stringWithFormat:@"%@",x];
        if (string.length > 6) {
            self.returnOrderTF.text              = [string substringWithRange:NSMakeRange(0, 6)];
        }
    }];
    
}

#pragma mark 点击d声明价值 和代收货款的方法
- (IBAction)clickPriceView:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    if (point.x < ScreenWidth/2) {
        //声明价值
        [self chooseGoodsName:OtherFreeValueType];
    }else{
        //代收货款
        [self chooseGoodsName:OtherFreeCollectionType];
    }
}

#pragma mark 填写费用
-(void)chooseGoodsName:(OtherFreeType)type{
    self.adjustFreeView.rateModel                         = self.interestModel;
    self.adjustFreeView.hidden                            = NO;
    self.adjustFreeView.otherFreeType                     = type;
    if (type == OtherFreeValueType) {
        self.adjustFreeView.textFree                      = [NSString stringWithFormat:@"%.f",self.adjustTotalPrice];
    }else{
        self.adjustFreeView.textFree                      = [NSString stringWithFormat:@"%.f",self.collectionTotalPrice];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.adjustFreeView.backgroundColor               = [UIColor colorWithWhite:0.000 alpha:0.299];
        self.adjustFreeView.y                             = -280;
    }];
}

- (YFSpecialLineAdjustFreeView *)adjustFreeView{
    if (!_adjustFreeView) {
        _adjustFreeView                                   = [[[NSBundle mainBundle] loadNibNamed:@"YFSpecialLineAdjustFreeView" owner:nil options:nil] lastObject];
        _adjustFreeView.frame                             = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 280);
        @weakify(self)
        _adjustFreeView.freeInformationBlock              = ^(OtherFreeType freeType, NSString *price, NSString *serviceFree){
            @strongify(self)
            if (freeType == OtherFreeValueType) {
                self.adjustPrice.text                     = [NSString stringWithFormat:@"%@元",price];
                self.adjustServiceFree.text               = [NSString stringWithFormat:@"保价费%@元",serviceFree];
                self.adjustTotalPrice                     = [price doubleValue];
                self.adjustMoney                          = [serviceFree doubleValue];
            }else{
                self.collectionPrice.text                 = [NSString stringWithFormat:@"%@元",price];
                self.collectionServiceFree.text           = [NSString stringWithFormat:@"手续费%@元",serviceFree];
                self.collectionTotalPrice                 = [price doubleValue];
                self.collectionMoney                      = [serviceFree doubleValue];
            }
        };
        [YFWindow addSubview:_adjustFreeView];
    }
    return _adjustFreeView;
}

- (IBAction)clickSaveBtn:(id)sender {
    DLog(@"%f------%f ----- %@-----%@------%@-------%@",self.adjustMoney,self.collectionMoney,self.informationTF.text,self.takeGoodsTF.text,self.giveGoodsTF.text,self.returnOrderTF.text);
    //组合所有数据
    NSMutableDictionary *parms                             = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms safeSetObject:@(self.adjustTotalPrice) forKey:@"adjustTotalPrice"];
    [parms safeSetObject:@(self.collectionTotalPrice) forKey:@"collectionTotalPrice"];
    [parms safeSetObject:@(self.adjustMoney) forKey:@"adjustMoney"];
    [parms safeSetObject:@(self.collectionMoney) forKey:@"collectionMoney"];
    [parms safeSetObject:self.informationTF.text forKey:@"informationTF"];
    [parms safeSetObject:self.takeGoodsTF.text forKey:@"takeGoodsTF"];
    [parms safeSetObject:self.giveGoodsTF.text forKey:@"giveGoodsTF"];
    [parms safeSetObject:self.returnOrderTF.text forKey:@"returnOrderTF"];
    //转为 model
    self.specilLineModel                                    = [YFSpecialLineModel mj_objectWithKeyValues:parms];
    //计算所有费用总和
    double sum = self.adjustMoney + self.collectionMoney + [self.takeGoodsTF.text doubleValue] + [self.giveGoodsTF.text doubleValue] + [self.returnOrderTF.text doubleValue];
    !self.allOtherFreeBlock ? : self.allOtherFreeBlock(self.specilLineModel, sum);
    [self goBack];
}

#pragma mark UITableViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        self.isHaveDian = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0)
            {
                if(single == '.')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.')
            {
                if(!self.isHaveDian)//text中还没有小数点
                {
                    self.isHaveDian = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (self.isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{
            //输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //TODO: 页面appear 禁用
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //TODO: 页面Disappear 启用
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

@end
