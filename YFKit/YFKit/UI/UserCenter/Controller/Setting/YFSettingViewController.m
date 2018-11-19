//
//  YFSettingViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/9.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSettingViewController.h"
#import "YFSettingTableViewCell.h"
#import "YFResetPassWordViewController.h"
#import "YFFeedbackViewController.h"
#import "YFAboutViewController.h"
#import "YFLoginViewController.h"
#import "YFForgetPassWordViewController.h"
#import "YFPrivacyViewController.h"

@interface YFSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) NSArray *dataArr;
@property (nonatomic, strong, nonnull)  UIButton *SignOutBtn;
@end

@implementation YFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title                                  = @"设置";
    self.dataArr                                = [NSArray getSettingArray];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFSettingTableViewCell *cell             = [tableView dequeueReusableCellWithIdentifier:@"YFSettingTableViewCell" forIndexPath:indexPath];
    cell.title.text                          = self.dataArr[indexPath.section][indexPath.row];
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            cell.accessoryType               = UITableViewCellAccessoryNone;
            cell.version.hidden              = NO;
            cell.version.text                = [NSString stringWithFormat:@"V%@",[NSString getAppVersion]];
        }else{
            cell.accessoryType               = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (indexPath.section == 0){
        cell.accessoryType                   = UITableViewCellAccessoryNone;
        cell.version.hidden                  = NO;
        cell.version.text                    = isLogin ? self.userName : @"";
        cell.version.textColor               = UIColorFromRGB(0x7D7E7E);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 2 ? CGFLOAT_MIN : 10.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //重置密码
            YFForgetPassWordViewController *forget      = [YFForgetPassWordViewController new];
            forget.title                                = @"重置密码";
            [self.navigationController pushViewController:forget animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //意见反馈
            YFFeedbackViewController *reset             = [[YFFeedbackViewController alloc]initWithNibName:@"YFFeedbackViewController" bundle:nil];
            reset.hidesBottomBarWhenPushed              = YES;
            [self.navigationController pushViewController:reset animated:YES];
        }else if (indexPath.row == 1){
            //隐私政策
            YFPrivacyViewController *privacy            = [YFPrivacyViewController new];
            privacy.hidesBottomBarWhenPushed            = YES;
            [self.navigationController pushViewController:privacy animated:YES];
        }else if (indexPath.row == 2){
            //关于我们
            YFAboutViewController *about                = [YFAboutViewController new];
            about.hidesBottomBarWhenPushed              = YES;
            [self.navigationController pushViewController:about animated:YES];
        }
    }
}

#pragma mark tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor              = UIColorFromRGB(0xF7F7F7);
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.rowHeight                    = 48;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight           = 0;
        _tableView.separatorStyle               = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"YFSettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFSettingTableViewCell"];
        [_tableView addSubview:self.SignOutBtn];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark 退出登录
-(UIButton *)SignOutBtn{
    if (!_SignOutBtn) {
        _SignOutBtn                              = [UIButton buttonWithType:UIButtonTypeCustom];
        _SignOutBtn.frame                        = CGRectMake(20, self.tableView.height-94, ScreenWidth-40, 44);
        [_SignOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        _SignOutBtn.layer.cornerRadius           = 2;
        [_SignOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        @weakify(self)
        [[_SignOutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self showAlertViewControllerTitle:wenxinTitle Message:@"您确定要退出?" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
                
            } confirmBlock:^{
                [UserData userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
        _SignOutBtn.titleLabel.font              = [UIFont systemFontOfSize:18];
        _SignOutBtn.backgroundColor              = UIColorFromRGB(0xFF6601);
    }
    return _SignOutBtn;
}


@end
