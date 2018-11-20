//
//  YFOrderListViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/3.
//  Copyright © 2018年 wy. All rights reserved.
//
#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

#import "YFOrderListViewController.h"
#import "YFReleaseListTableViewCell.h"
#import "YFReleaseListFooterView.h"
#import "YFOrderDetailViewController.h"
#import "YFOrderListModel.h"

@interface YFOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, copy,   nullable) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic, strong, nullable) NSMutableArray <YFOrderListModel *> *dataArr;
@property (nonatomic, strong, nullable) NSArray <YFListTaskFeeAdjustVoModel *> *adjustDataArr;//调整运费被拒
@property (nonatomic, assign)           NSInteger page;
@property (nonatomic, copy,   nullable) NSString *saveTaskId,*saveId,*opLocation;//确认收货需要的
@property (nonatomic, strong, nullable) YFNullView *nullView;
@end

@implementation YFOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCompleteBlock];
    
    [self configLocationManager];
    
    [self setUI];
}

-(void)setUI{
    self.page                                 = 1;
    self.dataArr                              = [NSMutableArray new];
    self.noNetView.hidden                     = YES;
}

#pragma mark netWork
-(void)netWork{
    NSMutableDictionary *parms                 = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(self.page) forKey:@"page"];
    [parms safeSetObject:@(20) forKey:@"rows"];
    [parms safeSetObject:@(1) forKey:@"type"];
    [parms safeSetObject:[NSString getAppVersion] forKey:@"version"];
    NSString *path                             = [NSString stringWithFormat:@"v1/taskOrder/%ld/listAll.do",(long)self.type];
    @weakify(self)
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        
        [self requestSuccess:baseModel];
        
    } failure:^(NSError *error) {
        @strongify(self)
        [self endRefresh];
        [self netAnomaly];
    }];
}

-(void)requestSuccess:(WKBaseModel *)baseModel{
    [self.nullView removeFromSuperview];
    self.nullView                               = nil;
    [self endRefresh];
    NSMutableArray *array                       = [NSMutableArray array];
    if (CODE_ZERO) {
        if (self.page == 1) {
            self.dataArr                        = [YFOrderListModel mj_objectArrayWithKeyValuesArray:[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"data"]];
        }else{
            array                               = [YFOrderListModel mj_objectArrayWithKeyValuesArray:[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"data"]];
            [self.dataArr addObjectsFromArray:array];
        }
        self.adjustDataArr                      = [YFListTaskFeeAdjustVoModel mj_objectArrayWithKeyValuesArray:[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"listTaskFeeAdjustVo"]];
        
        //遍历司机取消或者成功的数据
        self.adjustDataArr.count > 0 ? [self showDriverOrderMsg] : nil;
    }else{
        [YFToast showMessage:baseModel.message inView:self.view];
    }
    
    self.tableView.mj_footer.hidden              = self.dataArr.count < 10 ? YES : NO;
    
    if (array.count == 0 & self.dataArr.count != 0 & self.page != 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    [self.tableView reloadData];
    
    if (self.dataArr.count == 0) {
        self.nullView.hidden                      = NO;
    }
}

/**
 如果司机拒绝了,那么需要弹框 联系司机
 */
- (void)showDriverOrderMsg{
    for (YFListTaskFeeAdjustVoModel *model in self.adjustDataArr) {
        if (!model.comfirStatus) {
            [self showAlertViewControllerTitle:wenxinTitle Message:[NSString stringWithFormat:@"订单号%@\n调整运费失败!", model.taskId] CancelTitle:@"联系司机" CancelTextColor:CancelColor ConfirmTitle:@"确认" ConfirmTextColor:ConfirmColor cancelBlock:^{
                NSString *driverMobile = [NSString stringWithFormat:@"tel:%@",model.mobile];
                if (![NSString isBlankString:model.mobile]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:driverMobile]];
                }else{
                    [YFToast showMessage:@"该司机电话号码为空" inView:self.view];
                }
            } confirmBlock:^{
                
            }];
        }
    }
}

/**
 刷新数据
 */
-(void)refreshData{
//    [self.tableView.mj_header beginRefreshing];
    self.page                           = 1;
    [self netWork];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFReleaseListTableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseListTableViewCell" forIndexPath:indexPath];
    cell.type                                   = self.type;
    cell.Omodel                                 = self.dataArr[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 4.0f : 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 57.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YFReleaseListFooterView *footerView         = [[[NSBundle mainBundle] loadNibNamed:@"YFReleaseListFooterView" owner:nil options:nil] lastObject];
    footerView.superVC                          = self;
    footerView.type                             = self.type;
    footerView.Omodel                           = self.dataArr[section];
    @weakify(self)
    footerView.refreshDataBlock                 = ^(){
        @strongify(self)
        self.page                               = 1;
        [self netWork];
    };
    //确认收货
    footerView.confirmCollectGoodsBlock         = ^(YFOrderListModel *sModel){
        @strongify(self)
        self.saveId                             = sModel.Id;
        self.saveTaskId                         = sModel.taskId;
        [self locationJurisdiction];
        
    };
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YFOrderDetailViewController *detail         = [YFOrderDetailViewController new];
    detail.hidesBottomBarWhenPushed             = YES;
    detail.orderNum                             = [self.dataArr[indexPath.section] Id];
    detail.taskId                               = [self.dataArr[indexPath.section] taskId];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-45) style:UITableViewStyleGrouped];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.estimatedRowHeight           = 0;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight                    = 140.0f;
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseListTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseListTableViewCell"];
        @weakify(self)
        _tableView.mj_header                    = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.page                           = 1;
            [WKRequest isHiddenActivityView:YES];
            [self netWork];
        }];
        _tableView.mj_footer                    = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self netWork];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark 结束刷新
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark 网络异常
-(void)netAnomaly{
    if (![WKRequest YFNetWorkReachability]) {
        self.nullView.imgView.image              = [UIImage imageNamed:@"netAnomaly"];
        [self.nullView.noMoreBtn setTitle:@"网络异常,请检查网络" forState:0];
    }
}

#pragma mark  nullView 
-(YFNullView *)nullView{
    if (!_nullView) {
        _nullView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFNullView" owner:nil options:nil] lastObject];
        _nullView.imgView.image                  = [UIImage imageNamed:@"noOrder"];
        [_nullView.noMoreBtn setTitle:@"暂无订单" forState:0];
        _nullView.frame                          = CGRectMake(0, 0, ScreenWidth, self.tableView.height);
        [self.tableView addSubview:_nullView];
    }
    return _nullView;
}

#pragma mark 确认收货
-(void)confirmationGoods:(NSString *)opLocation{
    NSMutableDictionary *parms                        = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.saveId forKey:@"id"];
    [parms safeSetObject:self.saveTaskId forKey:@"taskId"];
    [parms safeSetObject:opLocation forKey:@"opLocation"];
    @weakify(self)
    [WKRequest postWithURLString:@"v1/taskOrder/completeTaskOrder.do" parameters:parms isJson:YES success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFNotificationCenter postNotificationName:@"OrderCompletion" object:nil];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)reGeocodeAction
{
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

#pragma mark - Initialization

- (void)initCompleteBlock
{
    WS(weakSelf)
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        DLog(@"%@",regeocode.formattedAddress);
        DLog(@"%@%@",regeocode.province,regeocode.city);
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            DLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            DLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            DLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
            DLog(@"定位成功");
            [weakSelf confirmationGoods:regeocode.formattedAddress];
        }        
    };
}

- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
}

- (void)dealloc
{
    [self cleanUpAction];
    
    self.completionBlock = nil;
}

#pragma mark  定位权限
-(void)locationJurisdiction{
    //判断用户是否允许打开定位功能
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用
        [GiFHUD showWithOverlay];
        [self reGeocodeAction];
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        [self showAlertViewControllerTitle:wenxinTitle Message:@"请到设置->隐私->定位服务开启定位权限" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
            
        } confirmBlock:^{
            NSURL *openUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] openURL:openUrl]) {
                [[UIApplication sharedApplication] openURL:openUrl];
            }
        }];
        
        
    }
}



@end
