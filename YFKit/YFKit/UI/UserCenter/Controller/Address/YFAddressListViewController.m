//
//  YFAddressListViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFAddressListViewController.h"
#import "YFEditAddressViewController.h"
#import "YFAddressListTableViewCell.h"
#import "YFAddressFooterView.h"
#import "YFCreateAddressView.h"
#import "YFAddressModel.h"
@interface YFAddressListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFCreateAddressView *rfooterView;
@property (nonatomic, strong, nullable) NSArray *dataArr;
@property (nonatomic, strong, nullable) YFNullView *nullView;
@end

@implementation YFAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                              = self.isConsignor ? @"发货地址管理" : @"收货地址管理";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self netWork];
}

#pragma mark netWork
- (void)netWork{
    NSString *path                          = self.isConsignor ? @"userConsigner/list.do" : @"userReceiver/list.do";
    @weakify(self)
    [WKRequest getWithURLString:path parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        [self.nullView removeFromSuperview];
        self.nullView                       = nil;
        if (CODE_ZERO) {
            if (self.isConsignor) {
                self.dataArr                = [YFConsignerModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            }else{
                self.dataArr                = [YFAddressModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            }
            
        }else{
            
        }
        [self.tableView reloadData];
        if (self.dataArr.count == 0) {
            self.nullView.hidden             = NO;
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFAddressListTableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:@"YFAddressListTableViewCell" forIndexPath:indexPath];
    if (self.isConsignor) {
        cell.Cmodel                             = self.dataArr[indexPath.section];
    }else{
        cell.model                              = self.dataArr[indexPath.section];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YFAddressFooterView *footerView             = [[[NSBundle mainBundle] loadNibNamed:@"YFAddressFooterView" owner:nil options:nil] lastObject];
    footerView.isConsignor                      = self.isConsignor;
    if (self.isConsignor) {
        footerView.Cmodel                       = self.dataArr[section];
    }else{
        footerView.model                        = self.dataArr[section];
    }
    footerView.superVC                          = self;
    @weakify(self)
    footerView.refreshBlock                     = ^{
        @strongify(self)
        [self netWork];
    };
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0.01f : 4.0f;
}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-self.rfooterView.height) style:UITableViewStyleGrouped];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.estimatedRowHeight           = 70.0f;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle               = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"YFAddressListTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFAddressListTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark footerView
-(YFCreateAddressView *)rfooterView{
    if (!_rfooterView) {
        _rfooterView                             = [[[NSBundle mainBundle] loadNibNamed:@"YFCreateAddressView" owner:nil options:nil] lastObject];
        _rfooterView.frame                       = CGRectMake(0, ScreenHeight-NavHeight-50, ScreenWidth, 50);
        [_rfooterView.submitBtn setTitle:@"新建" forState:UIControlStateNormal];
        _rfooterView.autoresizingMask            = 0;
        @weakify(self)
        [[_rfooterView.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            YFEditAddressViewController *edit    = [YFEditAddressViewController new];
            edit.isConsignor                     = self.isConsignor;
            [self.navigationController pushViewController:edit animated:YES];
        }];
        [self.view addSubview:_rfooterView];
    }
    return _rfooterView;
}

#pragma mark  nullView
-(YFNullView *)nullView{
    if (!_nullView) {
        _nullView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFNullView" owner:nil options:nil] lastObject];
        _nullView.frame                          = CGRectMake(0, 0, ScreenWidth, self.tableView.height);
        _nullView.imgView.image                  = [UIImage imageNamed:@"noAddress"];
        [_nullView.noMoreBtn setTitle:@"暂无地址" forState:0];
        [self.tableView addSubview:_nullView];
    }
    return _nullView;
}

@end
