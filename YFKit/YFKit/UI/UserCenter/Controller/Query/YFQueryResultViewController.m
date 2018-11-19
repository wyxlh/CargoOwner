//
//  YFQueryResultViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/6/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFQueryResultViewController.h"
#import "YFQueryResultTableViewCell.h"
@interface YFQueryResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YFQueryResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                                  = @"违章查询";
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFQueryResultTableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:@"YFQueryResultTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView                          = [[UIView alloc]init];
    headerView.backgroundColor                  = [UIColor whiteColor];
    UILabel *title                              = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, ScreenWidth-32, 20)];
    title.textColor                             = UIColorFromRGB(0x7D7E7E);
    title.text                                  = @"提示 : 距离下一次车检还有5天,请关注";
    title.font                                  = [UIFont systemFontOfSize:16];
    [headerView addSubview:title];
    UILabel *line                               = [[UILabel alloc]initWithFrame:CGRectMake(0, title.maxY+14, ScreenWidth, 4)];
    line.backgroundColor                        = UIColorFromRGB(0xF4F5F6);
    [headerView addSubview:line];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 52.0f;
}

#pragma mark tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.separatorStyle               = 0;
        _tableView.rowHeight                    = 90.0f;
        _tableView.backgroundColor              = UIColorFromRGB(0xF4F5F6);
        [_tableView registerNib:[UINib nibWithNibName:@"YFQueryResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFQueryResultTableViewCell"];
    }
    return _tableView;
}



@end
