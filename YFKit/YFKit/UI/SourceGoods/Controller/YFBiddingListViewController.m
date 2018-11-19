//
//  YFBiddingListViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBiddingListViewController.h"
#import "YFBiddingListHeadView.h"
#import "YFBiddingListTableViewCell.h"
#import "YFDriverDetailViewController.h"
#import "YFPlaceOrderViewController.h"
#import "YFBiddingListModel.h"
#import "YFReleseDetailModel.h"
#import "YFSortView.h"

@interface YFBiddingListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong) YFBiddingListHeadView *headView;//头视图
@property (nonatomic, strong) YFBiddingListModel *mainModel;
@property (nonatomic, strong) YFSortView *sortView;//筛选 view
@property (nonatomic, assign) NSInteger sort;//（0：就是全部和默认排序，1就是时间升序，2时间降序，3价格升序，4价格降序）
@end

@implementation YFBiddingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self netWork];
    
}

-(void)setUI{
    self.sort                               = 0;
    self.title                              = @"竞价列表";
    @weakify(self)
    [[YFNotificationCenter rac_addObserverForName:@"RefreshBidDataKey" object:nil] subscribeNext:^(NSNotification  *x) {
        @strongify(self)
        for (PriceListModel *pModel in self.mainModel.priceList) {
            //判断是否能报价  当前为能报价 [NSString isCanOffer:self.releaseTime Minute:self.mainModel.placeTime] = YES 为不能报价
            pModel.isCanOffer               = YES;
        }
        //手动把确认报价按钮改了 让用户能点击
        [self.tableView reloadData];
    }];
}

#pragma mark netWork
-(void)netWork{
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.Id forKey:@"id"];
    [parms safeSetObject:@(self.sort) forKey:@"sort"];
    WS(weakSelf)
    [WKRequest getWithURLString:@"v1/goods/checkPrice.do" parameters:parms success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            [weakSelf requestSuccess:baseModel];
        }else{
//            [YFToast showMessage:baseModel.message inView:weakSelf.view];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)requestSuccess:(WKBaseModel *)baseModel{
    
    self.mainModel                          = [YFBiddingListModel mj_objectWithKeyValues:baseModel.data];
    if ([NSString isBlankString:self.mainModel.Id]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    for (PriceListModel *pModel in self.mainModel.priceList) {
        //判断是否能报价  当前为能报价 [NSString isCanOffer:self.releaseTime Minute:self.mainModel.placeTime] = YES 为不能报价
        if (![NSString isCanOffer:self.releaseTime Minute:self.mainModel.placeTime] && [NSString isAllowBiddingWithPickGoodsTime:self.mainModel.pickGoodsDate]) {
            pModel.isCanOffer               = YES;
        }
    }
    [self.tableView.mj_header endRefreshing];

    [self.tableView reloadData];
}

#pragma mark 确认报价
- (void)againGetBindLindDataWithSuccessBlock:(void(^)(void))successBlock{
    [WKRequest isHiddenActivityView:YES];
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.Id forKey:@"id"];
    [parms safeSetObject:@(self.sort) forKey:@"sort"];
    WS(weakSelf)
    [WKRequest getWithURLString:@"v1/goods/checkPrice.do" parameters:parms success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            weakSelf.mainModel              = [YFBiddingListModel mj_objectWithKeyValues:baseModel.data];
            successBlock();
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 获取货源详情接口
 */
-(void)Confirmation:(NSInteger )index{
    NSMutableDictionary *parms                = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(1) forKey:@"type"];
    [parms safeSetObject:self.Id forKey:@"id"];
    @weakify(self)
    [WKRequest getWithURLString:@"v1/goods/1/get.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            YFReleseDetailModel *detailModel  = [YFReleseDetailModel mj_objectWithKeyValues:baseModel.data];
            detailModel.driverPhone           = [self.mainModel.priceList[index] carrierLinkPhone];
            detailModel.driverId              = [self.mainModel.priceList[index] carrierSyscode];
            detailModel.driverName            = [self.mainModel.priceList[index] carrierName];
            detailModel.quotedPrice           = [self.mainModel.priceList[index] quotePrice];
            detailModel.verificationId        = [self.mainModel.priceList[index] Id];
            YFPlaceOrderViewController *Place = [YFPlaceOrderViewController new];
            Place.detailModel                 = detailModel;
            Place.oldOrderType                = 1;
            [self.navigationController pushViewController:Place animated:YES];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainModel.priceList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFBiddingListTableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:@"YFBiddingListTableViewCell" forIndexPath:indexPath];
    cell.superVC                                = self;
    cell.model                                  = self.mainModel.priceList[indexPath.row];
    @weakify(self)
    cell.callBackBlock                          = ^{
        @strongify(self)
        [self againGetBindLindDataWithSuccessBlock:^{
            [self Confirmation:indexPath.row];
        }];
        
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YFDriverDetailViewController *detail    = [YFDriverDetailViewController new];
    detail.driveId                          = [self.mainModel.priceList[indexPath.row] carrierSyscode];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headView.maxY, ScreenWidth, ScreenHeight-NavHeight-self.headView.maxY) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.separatorStyle               = 0;
        _tableView.rowHeight                    = 90.0f;
        _tableView.backgroundColor              = [UIColor groupTableViewBackgroundColor];
        [_tableView registerNib:[UINib nibWithNibName:@"YFBiddingListTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFBiddingListTableViewCell"];
        @weakify(self)
        _tableView.mj_header                    = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self netWork];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark 头视图
-(YFBiddingListHeadView *)headView{
    if (!_headView) {
        _headView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFBiddingListHeadView" owner:nil options:nil] lastObject];
        _headView.frame                          = CGRectMake(0.0f, 0.0f, ScreenWidth, 85.0f);
        _headView.autoresizingMask               = 0;
        _headView.publishedTime                  = self.releaseTime;
        _headView.model                          = self.mainModel;
        @weakify(self)
        _headView.callBackSortBlock              = ^(NSInteger tag , BOOL isSelect){
            @strongify(self)
            [self sortCondition:tag WithIsSelect:isSelect];
        };
        [self.view addSubview:_headView];
    }
    return _headView;
}

#pragma mark  筛选判断 sort：int类型，必填（0：就是全部和默认排序，1就是时间升序，2时间降序，3价格升序，4价格降序）
-(void)sortCondition:(NSInteger )tag WithIsSelect:(BOOL ) isSelect{
    if (tag == 10) {
        //全部 重置选中的状态 blue ashBottom
        [self.sortView disappear];
        self.headView.timeBtn.selected              = self.headView.priceBtn.selected = NO;
        [self updataHeadViewButtonTypeWithTimeBtnColor:UIColorFromRGB(0x636465) TimeBtnImage:@"ashBottom" PriceBtnColor:UIColorFromRGB(0x636465) PriceBtnImage:@"ashBottom"];
        
        self.sort                                   = 0;
        [self.sortView.tableView reloadData];
        [self netWork];
    }else if (tag == 20){
        //时间
        if (isSelect) {
            self.sortView.type                      = 1;
            [self showSortView];
        }else{
            [self.sortView disappear];
        }
    }else if (tag == 30){
        //价格
        if (isSelect) {
            self.sortView.type                      = 2;
            [self showSortView];
        }else{
            [self.sortView disappear];
        }
    }
}

/**
 显示筛选
 */
-(void)showSortView{
    self.sortView.hidden                        = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.sortView.backgroundColor           = [UIColor colorWithWhite:0.000 alpha:0.299]
        ;
        self.sortView.y                         = + 85.0f;
    }];
}

#pragma mark 筛选 View  1就是时间升序，2时间降序，3价格升序，4价格降序）
-(YFSortView *)sortView{
    if (!_sortView) {
        _sortView                               = [[[NSBundle mainBundle] loadNibNamed:@"YFSortView" owner:nil options:nil] lastObject];
        _sortView.frame                         = CGRectMake(0, 85.0f, ScreenWidth, ScreenHeight - 85.0f);
        _sortView.sortUserType                  = YFSortUserBindType;
        @weakify(self)
        _sortView.backSortStateBlock            = ^(NSInteger index,NSInteger type){
            @strongify(self)
            if (type == 1) {
                //时间
                if (index == 0) {
                    self.sort                   = 1;
                }else{
                    self.sort                   = 2;
                }
                self.headView.timeBtn.selected  = NO;
                [self updataHeadViewButtonTypeWithTimeBtnColor:UIColorFromRGB(0x157EFB) TimeBtnImage:@"blue" PriceBtnColor:UIColorFromRGB(0x636465) PriceBtnImage:@"ashBottom"];
            }else{
                //价格
                if (index == 0) {
                    self.sort                   = 3;
                }else{
                    self.sort                   = 4;
                }
                self.headView.priceBtn.selected = NO;
                [self updataHeadViewButtonTypeWithTimeBtnColor:UIColorFromRGB(0x636465) TimeBtnImage:@"ashBottom" PriceBtnColor:UIColorFromRGB(0x157EFB) PriceBtnImage:@"blue"];
            }
            [self netWork];
        };
        [self.view addSubview:_sortView];
        
    }
    return _sortView;
}

/**
 修改HeadView选中状态按钮的颜色

 @param timeBtnColor 时间颜色
 @param timeBtnImage 时间图片
 @param priceBtnColor 价格颜色
 @param priceBtnImage 价格图片
 */
- (void)updataHeadViewButtonTypeWithTimeBtnColor:(UIColor *)timeBtnColor
                              TimeBtnImage:(NSString *)timeBtnImage
                             PriceBtnColor:(UIColor *)priceBtnColor
                             PriceBtnImage:(NSString *)priceBtnImage{
    
    [self.headView.timeBtn setTitleColor:timeBtnColor forState:UIControlStateNormal];
    [self.headView.timeBtn setImage:[UIImage imageNamed:timeBtnImage] forState:UIControlStateNormal];
    [self.headView.priceBtn setTitleColor:priceBtnColor forState:UIControlStateNormal];
    [self.headView.priceBtn setImage:[UIImage imageNamed:priceBtnImage] forState:UIControlStateNormal];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)goBack{
    //离开界面销毁定时器
    [self.headView.timer invalidate];
    self.headView.timer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [YFNotificationCenter removeObserver:self];
}



@end
