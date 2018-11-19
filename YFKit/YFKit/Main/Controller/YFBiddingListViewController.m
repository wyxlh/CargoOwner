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
#import "YFBiddingListModel.h"
@interface YFBiddingListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong) YFBiddingListHeadView *headView;//头视图
@property (nonatomic, strong) YFBiddingListModel *mainModel;
@end

@implementation YFBiddingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self netWork];
}

-(void)setUI{
    self.title                              = @"竞价列表";
    
}

#pragma mark netWork
-(void)netWork{
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.Id forKey:@"id"];
    WS(weakSelf)
    [WKRequest getWithURLString:@"goods/checkPrice.do" parameters:parms success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            weakSelf.mainModel              = [YFBiddingListModel mj_objectWithKeyValues:baseModel.data];
            [weakSelf.tableView reloadData];
        }else{
            [YFToast showMessage:baseModel.message inView:weakSelf.view];
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
    cell.model                                  = self.mainModel.priceList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YFDriverDetailViewController *detail    = [YFDriverDetailViewController new];
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
        [_tableView registerNib:[UINib nibWithNibName:@"YFBiddingListTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFBiddingListTableViewCell"];
        @weakify(self)
        _tableView.mj_header                    = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
            });
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
        [self.view addSubview:_headView];
    }
    return _headView;
}


@end
