//
//  YFGoodsSourceDetailViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/3.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFGoodsSourceDetailViewController.h"
#import "YFGoodsSourceTableViewCell.h"
#import "YFReleseDetailModel.h"
#import "YFMileageComputeViewController.h"
#import "YFGoodsDetailSectionView.h"
#import "YFGoodsDetailDriverTableViewCell.h"
#import "YFShareView.h"
#import "YFDriverDetailModel.h"
#import "YFDriverDetailViewController.h"
#import "YFCarSourceModel.h"

@interface YFGoodsSourceDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) UIButton *lookBtn;
@property (nonatomic, strong, nullable) YFReleseDetailModel *mainModel;
@property (nonatomic, strong, nullable) YFDriverDetailModel *driverModel;
@property (nonatomic, strong, nullable) YFGoodsDetailSectionView *sectionView;
/**0 已查看司机 1 已联系司机*/
@property (nonatomic, assign)           NSInteger page,driverSelectIndex;
@property (nonatomic, strong, nullable) NSMutableArray <YFMayBeCarModel *> *driverDataArr;
@end

@implementation YFGoodsSourceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title                              = @"货源详情";
    self.page                               = 1;
    self.driverSelectIndex                  = 0;
    self.driverDataArr                      = [NSMutableArray new];
    [self addRightImageBtn:@"shareLogo"];
    [self netWork];
}

#pragma mark 分享
- (void)rightImageButtonClick:(UIButton *)sender{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    YFShareView *shareView = [[YFShareView alloc] initWithFrame:CGRectZero shareType:YFShareContentBySourceType];
    NSString *userName;
    if (![NSString isBlankString:[UserData userInfo].username]) {
        userName = [[UserData userInfo].username substringToIndex:1];
    }else{
        userName = @"";
    }
    shareView.shareContent = [NSString stringWithFormat:@"好货好价，%@老板等你来联系！登录乾坤司机APP，优质货源等你来接。",userName];
    shareView.shareImage = @"shareIcon";
    shareView.shareTitle = [NSString stringWithFormat:@"【%@→%@】的货源寻求车辆资源",[NSString getCityName:self.mainModel.startSite],[NSString getCityName:self.mainModel.endSite]];
    shareView.superVC = self;
    shareView.shareUrl = [NSString stringWithFormat:@"%@?id=%@",H5_URL,self.Id];
    [win addSubview:shareView];
}

#pragma mark network 货源详情
-(void)netWork{
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(self.type) forKey:@"type"];
    [parms safeSetObject:self.Id forKey:@"id"];
    NSString *path                          = [NSString stringWithFormat:@"v1/goods/%ld/get.do",(long)self.type];
    @weakify(self)
    [GiFHUD showWithOverlay];
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        [GiFHUD dismiss];
        @strongify(self)
        if (CODE_ZERO) {
            self.mainModel                  = [YFReleseDetailModel mj_objectWithKeyValues:baseModel.data];
            if (self.type == 1) {
                [self getGoodsDriverMessageWithType:0];
            }else{
                [self driverDetail:self.mainModel.driverId];
                self.tableView.mj_footer.hidden = YES;
            }
            [self.tableView reloadData];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
       
    }];
}

/**
 司机详情
 */
-(void)driverDetail:(NSString *)driverId{
    NSMutableDictionary *parms               = [NSMutableDictionary dictionary];
    [parms safeSetObject:driverId forKey:@"driveId"];
    @weakify(self)
    [WKRequest getWithURLString:@"v1/goods/driver/details.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.driverModel                = [YFDriverDetailModel mj_objectWithKeyValues:baseModel.data];
        }else{
//            [YFToast showMessage:baseModel.message inView:self.view];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

/**
 已查看  和 已联系的司机

 @param type type":"0,浏览过的司机 1,联系过的司机"
 */
- (void)getGoodsDriverMessageWithType:(NSInteger )type{
    NSMutableDictionary *dict              = [NSMutableDictionary dictionary];
    [dict safeSetObject:self.mainModel.supplyGoodsId forKey:@"supplyGoodsId"];
    [dict safeSetObject:@(type) forKey:@"type"];
    NSMutableDictionary *parms             = [NSMutableDictionary dictionary];
    [parms safeSetObject:[NSString dictionTransformationJson:dict] forKey:@"condition"];
    [parms safeSetObject:@(self.page) forKey:@"page"];
    [parms safeSetObject:@(20) forKey:@"rows"];
    @weakify(self)
    [WKRequest postWithURLString:@"app/goods/getGoodsDriverMessage.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            if (self.page == 1) {
                self.driverDataArr         = [YFMayBeCarModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            }else{
                [self.driverDataArr addObjectsFromArray:[YFMayBeCarModel mj_objectArrayWithKeyValuesArray:baseModel.data]];
            }
        }else{
//            [YFToast showMessage:baseModel.message inView:self.view];
        }
        self.tableView.mj_footer.hidden    = self.driverDataArr.count < 10 ? YES : NO;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderType == 4 ? 1 : 2;//已取消状态下面没有司机信息
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        //如果是未承运 或者已承运 就只有一条数据
        if (self.orderType == 2 || self.orderType == 3) {
            return 1;
        }
        return self.driverDataArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YFGoodsSourceTableViewCell *cell        = [tableView dequeueReusableCellWithIdentifier:@"YFGoodsSourceTableViewCell" forIndexPath:indexPath];
        cell.model                              = self.mainModel;
        cell.superVC                            = self;
        return cell;
    }
    YFGoodsDetailDriverTableViewCell *cell      = [tableView dequeueReusableCellWithIdentifier:@"YFGoodsDetailDriverTableViewCell" forIndexPath:indexPath];
    cell.superVC                                = self;
    cell.btnBGView.hidden                       = self.orderType == 1 ? NO : YES;
    if (self.orderType != 1) {
        cell.driverModel                        = self.driverModel;
    }else if (self.driverDataArr.count != 0){
        //发布中
        cell.selectIndex                        = self.driverSelectIndex;
        cell.Lmodel                             = self.driverDataArr[indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 350.0f;
    }
    return self.orderType == 1 ? 135.0f : 90.0f;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        self.sectionView.orderType               = self.orderType;
        return self.sectionView;
    }
    return [UIView new];
}

- (void)sectionBtnTitle{
    if (self.driverSelectIndex == 0) {
        if (self.driverDataArr.count == 0) {
            [self.sectionView.leftBtn setTitle:@"已查看司机" forState:0];
        }else{
            [self.sectionView.leftBtn setTitle:[NSString stringWithFormat:@"已查看司机(%ld)",self.driverDataArr.count] forState:0];
        }
    }else{
        if (self.driverDataArr.count == 0) {
            [self.sectionView.rightBtn setTitle:@"已联系司机" forState:0];
        }else{
            [self.sectionView.rightBtn setTitle:[NSString stringWithFormat:@"已联系司机(%ld)",self.driverDataArr.count] forState:0];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? CGFLOAT_MIN : 43.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.orderType == 1) {
            //发布中的订单
            YFDriverDetailViewController *detail    = [YFDriverDetailViewController new];
            detail.driveId                          = [self.driverDataArr[indexPath.row] driverId];;
            @weakify(self)
            detail.refreashDriverDataBlock          = ^{
                @strongify(self)
                self.page                           = 1;
                [self getGoodsDriverMessageWithType:self.driverSelectIndex];
            };
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            YFDriverDetailViewController *detail    = [YFDriverDetailViewController new];
            detail.driveId                          = self.mainModel.driverId;
            @weakify(self)
            detail.refreashDriverDataBlock          = ^{
                @strongify(self)
                [self driverDetail:self.mainModel.driverId];
            };
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}


#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-self.lookBtn.height) style:UITableViewStylePlain];
        _tableView.backgroundColor              = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight           = 0;
        _tableView.separatorStyle               = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"YFGoodsSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFGoodsSourceTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFGoodsDetailDriverTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFGoodsDetailDriverTableViewCell"];
        @weakify(self)
        _tableView.mj_footer                    = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page ++;
            [self getGoodsDriverMessageWithType:self.driverSelectIndex];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark sectionView
- (YFGoodsDetailSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView                                 = [[[NSBundle mainBundle] loadNibNamed:@"YFGoodsDetailSectionView" owner:nil options:nil] lastObject];
        WS(weakSelf)
        _sectionView.clickDriverLookTypeBlock        = ^(NSInteger index){
            //0 已查看 1 已联系
            weakSelf.page                            = 1;
            [weakSelf.driverDataArr removeAllObjects];
            weakSelf.driverSelectIndex               = index;
            [weakSelf getGoodsDriverMessageWithType:index];
        };
    }
    return _sectionView;
}

#pragma mark  查看竞价
-(UIButton *)lookBtn{
    if (!_lookBtn) {
        _lookBtn                                 = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight-NavHeight-50, ScreenWidth, 50)];
        [_lookBtn setTitle:@"联系司机" forState:UIControlStateNormal];
        if (self.orderType == 1 || self.orderType == 4) {
            //发布中和已取消没有联系司机按钮
            _lookBtn.height                      = 0;
        }
        _lookBtn.titleLabel.font                 = [UIFont systemFontOfSize:20];
        _lookBtn.backgroundColor                 = UIColorFromRGB(0x0178E5);
        [_lookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        @weakify(self)
        [[_lookBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            NSString *driverMobile = [NSString stringWithFormat:@"tel:%@",self.driverModel.driverMobile];
            if (![NSString isBlankString:self.driverModel.driverMobile]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:driverMobile]];
            }else{
                [YFToast showMessage:@"该司机电话号码为空" inView:self.view];
            }
        }];
        [self.view addSubview:_lookBtn];
    }
    return _lookBtn;
}


@end
