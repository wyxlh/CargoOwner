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
@interface YFGoodsSourceDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) UIButton *lookBtn;
@property (nonatomic, strong, nullable) YFReleseDetailModel *mainModel;
@end

@implementation YFGoodsSourceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title                              = @"货源详情";
    self.lookBtn.hidden                     = self.type == 1 ? NO : YES;
    [self netWork];
}

#pragma mark network
-(void)netWork{
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(self.type) forKey:@"type"];
    [parms safeSetObject:self.Id forKey:@"id"];
    NSString *path                          = [NSString stringWithFormat:@"goods/%ld/get.do",self.type];
    @weakify(self)
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.mainModel                  = [YFReleseDetailModel mj_objectWithKeyValues:baseModel.data];
            [self.tableView reloadData];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFGoodsSourceTableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:@"YFGoodsSourceTableViewCell" forIndexPath:indexPath];
    cell.model                                  = self.mainModel;
    return cell;
}


#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-50) style:UITableViewStylePlain];
        _tableView.backgroundColor              = [UIColor whiteColor];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
//        _tableView.estimatedRowHeight           = YES;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedRowHeight                    = 400.0f;
        [_tableView registerNib:[UINib nibWithNibName:@"YFGoodsSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFGoodsSourceTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark  查看竞价
-(UIButton *)lookBtn{
    if (!_lookBtn) {
        _lookBtn                                 = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight-NavHeight-50, ScreenWidth, 50)];
        [_lookBtn setTitle:@"查看竞价" forState:UIControlStateNormal];
        _lookBtn.titleLabel.font                 = [UIFont systemFontOfSize:20];
        _lookBtn.backgroundColor                 = UIColorFromRGB(0x0178E5);
        [_lookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_lookBtn];
    }
    return _lookBtn;
}


@end
