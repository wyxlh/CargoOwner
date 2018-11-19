//
//  YFChooseAddressListViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/6/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFChooseAddressListViewController.h"
#import "YFAddressListViewController.h"
#import "YFEditAddressViewController.h"
#import "YFCreateAddressView.h"
#import "YFChooseAddressListTableViewCell.h"
#import "YFAddressModel.h"

@interface YFChooseAddressListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFCreateAddressView *rfooterView;
@property (nonatomic, strong, nullable) NSArray *dataArr;
@property (nonatomic, strong, nullable) YFNullView *nullView;
@property (nonatomic, strong, nullable) YFAddressModel *aModel;
@property (nonatomic, strong, nullable) YFConsignerModel *cModel;
@end

@implementation YFChooseAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                               = @"地址管理";
    [self addRightTitleBtn:@"管理"];
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
                for (YFConsignerModel*cModel in self.dataArr) {
                    //先把所有数据isDefault 都设置为你No
                    cModel.isSelect         = NO;
                    if ([self.addressId isEqualToString:cModel.Id]) {
                        //如果上面传下来的Id 和这个Id 一样就设为 YES
                        cModel.isSelect    = YES;
                        self.cModel        = cModel;
                    }
                }
            }else{
                self.dataArr                = [YFAddressModel mj_objectArrayWithKeyValuesArray:baseModel.data];
                for (YFAddressModel*aModel in self.dataArr) {
                    //先把所有数据isDefault 都设置为你No
                    aModel.isSelect         = NO;
                    if ([self.addressId isEqualToString:aModel.Id]) {
                        //如果上面传下来的Id 和这个Id 一样就设为 YES
                        aModel.isSelect     = YES;
                        self.aModel         = aModel;
                    }
                }
            }
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
        [self.tableView reloadData];
        if (self.dataArr.count == 0) {
            self.nullView.hidden             = NO;
            self.rightTitleBtn.hidden        = YES;
        }else{
            self.rightTitleBtn.hidden        = NO;
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)rightTitleButtonClick:(UIButton *)sender{
    YFAddressListViewController *list        = [YFAddressListViewController new];
    list.isConsignor                         = self.isConsignor;
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFChooseAddressListTableViewCell *cell      = [tableView dequeueReusableCellWithIdentifier:@"YFChooseAddressListTableViewCell" forIndexPath:indexPath];
    cell.chooseAddressType                      = self.chooseAddressType;
    if (self.isConsignor) {
        cell.Cmodel                             = self.dataArr[indexPath.section];
        cell.selectBtn.userInteractionEnabled   = NO;
    }else{
        cell.model                              = self.dataArr[indexPath.section];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0.01f : 1.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isConsignor) {
        YFConsignerModel *Cmodel                = self.dataArr[indexPath.section];
        if ([NSString isBlankString:Cmodel.consignerAddr] && self.chooseAddressType == AssignOrderType) {
            [YFToast showMessage:@"请填写详细地址" inView:self.view];
            return;
        }
        self.cModel                             = Cmodel;
        !self.backCaddressBlock ? : self.backCaddressBlock(Cmodel);
    }else{
        YFAddressModel *Amodel                  = self.dataArr[indexPath.section];
        if ([NSString isBlankString:Amodel.receiverAddr] && self.chooseAddressType == AssignOrderType) {
            return;
        }
        self.aModel                             = Amodel;
        !self.backAddressBlock ? : self.backAddressBlock(Amodel);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 返回
- (void)goBack{
    if (self.isConsignor && self.cModel) {
        //如果是出发地并且self.cModel 有值的时候
        !self.backCaddressBlock ? : self.backCaddressBlock(self.cModel);
    }else if (!self.isConsignor && self.aModel){
        //如果是目的地并且self.aModel有值的时候
        !self.backAddressBlock ? : self.backAddressBlock(self.aModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
        [_tableView registerNib:[UINib nibWithNibName:@"YFChooseAddressListTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFChooseAddressListTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
