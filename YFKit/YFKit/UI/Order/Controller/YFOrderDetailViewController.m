//
//  YFOrderDetailViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOrderDetailViewController.h"
#import "YFOrderAddressTableViewCell.h"
#import "YFOrderDetailCarMsgTableViewCell.h"
#import "YFOrderDetailMapTableViewCell.h"
#import "YFOrderDetailLogisticsTableViewCell.h"
#import "YFOrderDetailOrderNumHeadView.h"
#import "YFOrderDetailMsgHeadView.h"
#import "YFOrderDetailModel.h"
#import "YFOrderTrajectoryModel.h"
#import "YFDriverMapDetailViewController.h"
@interface YFOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, assign) BOOL isSelect;//判断火车信息的显示与隐藏
@property (nonatomic, strong) NSArray <YFOrderTrajectoryModel *> *TrajectoryArr;//轨迹数据
@property (nonatomic, strong, nullable) YFOrderDetailModel *mainModel;
@property (nonatomic, strong, nullable) YFOrderLocationModel *loactionModel;
@end

@implementation YFOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self netWork];
}

-(void)setUI{
    self.title                                     = @"订单详情";
    self.isSelect                                  = YES;
}

#pragma mark  netWork 订单详情
-(void)netWork{
    NSMutableDictionary *parms                      = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.orderNum forKey:@"id"];
    [parms safeSetObject:self.taskId forKey:@"taskId"];
    @weakify(self)
    [WKRequest getWithURLString:@"v1/taskOrder/select.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.mainModel                           = [YFOrderDetailModel mj_objectWithKeyValues:baseModel.data];
            [self.tableView reloadData];
            [self netTrajectory];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  运单轨迹
-(void)netTrajectory{
    @weakify(self)
    [WKRequest postWithURLString:@"track/list.do" parameters:@{@"taskId":self.taskId} isJson:YES success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.TrajectoryArr                       = [YFOrderTrajectoryModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            [self.tableView reloadData];
            [self netLocation];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  实时位置
-(void)netLocation{
    @weakify(self)
    [WKRequest postWithURLString:@"track/getCurrentLocation.do" parameters:@{@"taskId":self.taskId} isJson:YES success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.loactionModel                       = [YFOrderLocationModel mj_objectWithKeyValues:baseModel.data];
            [self.tableView reloadData];
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.isSelect ? 0 : 1;
    }
    return self.mainModel.details.count + 1; //1 是地图
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //地址
        YFOrderAddressTableViewCell *cell         = [tableView dequeueReusableCellWithIdentifier:@"YFOrderAddressTableViewCell" forIndexPath:indexPath];
        cell.model                                = self.mainModel;
        return cell;
    }else if (indexPath.section == 1){
        //车辆
        YFOrderDetailCarMsgTableViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:@"YFOrderDetailCarMsgTableViewCell" forIndexPath:indexPath];
        cell.model                                = self.mainModel;
        return cell;
    }else{
        if (indexPath.row == 0) {
            //地图
            YFOrderDetailMapTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"YFOrderDetailMapTableViewCell" forIndexPath:indexPath];
            cell.location                         = self.loactionModel;
            cell.TrajectoryArr                    = self.TrajectoryArr;
            return cell;
        }
        //物流信息
        YFOrderDetailLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YFOrderDetailLogisticsTableViewCell" forIndexPath:indexPath];
        cell.index                                = indexPath.row;
        cell.model                                = self.mainModel.details[indexPath.row-1];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        YFOrderDetailOrderNumHeadView *firstView  = [[[NSBundle mainBundle] loadNibNamed:@"YFOrderDetailOrderNumHeadView" owner:nil options:nil] lastObject];
        firstView.model                           = self.mainModel;
        return firstView;
    }else{
        __weak YFOrderDetailMsgHeadView *msgView  = [[[NSBundle mainBundle] loadNibNamed:@"YFOrderDetailMsgHeadView" owner:nil options:nil] lastObject];
        msgView.index                             = section;
        [msgView.showBtn setImage:self.isSelect ? [UIImage imageNamed:@"bottom"] : [UIImage imageNamed:@"top"] forState:0];
        @weakify(self)
        msgView.showCarMsgBlock                   = ^{
            @strongify(self)
            self.isSelect                         = !self.isSelect;
            NSIndexSet *indexSetA = [[NSIndexSet alloc]initWithIndex:1];    //刷新第2段
            [tableView reloadSections:indexSetA withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        return msgView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 50.0f : 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            YFDriverMapDetailViewController *map  = [YFDriverMapDetailViewController new];
            map.location                          = self.loactionModel;
            map.TrajectoryArr                     = self.TrajectoryArr;
            map.phone                             = self.mainModel.driverMobile;
            [self.navigationController pushViewController:map animated:YES];
        }
    }
}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                                = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate                       = self;
        _tableView.dataSource                     = self;
        _tableView.backgroundColor                = [UIColor whiteColor];
        _tableView.estimatedRowHeight             = 80.0f;
        _tableView.separatorStyle                 = 0;
        _tableView.estimatedSectionFooterHeight   = 0;
        _tableView.estimatedSectionHeaderHeight   = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"YFOrderAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFOrderAddressTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFOrderDetailCarMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFOrderDetailCarMsgTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFOrderDetailMapTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFOrderDetailMapTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFOrderDetailLogisticsTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFOrderDetailLogisticsTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
@end
