//
//  YFViolationInquiryViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/6/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFViolationInquiryViewController.h"
#import "YFViolationTableViewCell.h"
#import "YFViolationBannerTableViewCell.h"
@interface YFViolationInquiryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YFViolationInquiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI{
    self.title                                  = @"违章查询";
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YFViolationBannerTableViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:@"YFViolationBannerTableViewCell" forIndexPath:indexPath];
        return cell;
    }else{
        YFViolationTableViewCell *cell          = [tableView dequeueReusableCellWithIdentifier:@"YFViolationTableViewCell" forIndexPath:indexPath];
        cell.superVC                            = self;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == 0 ? 125.0f : 300.0f;
}

#pragma mark tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.separatorStyle               = 0;
        _tableView.backgroundColor              = UIColorFromRGB(0xF4F5F6);
        [_tableView registerNib:[UINib nibWithNibName:@"YFViolationTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFViolationTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFViolationBannerTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFViolationBannerTableViewCell"];
    }
    return _tableView;
}

@end
