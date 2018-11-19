//
//  YFPlatformEmptyCarViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/7/20.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFPlatformEmptyCarViewController.h"

@interface YFPlatformEmptyCarViewController ()
@property (nonatomic, strong, nullable) UITableView *tableView;
@end

@implementation YFPlatformEmptyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStylePlain];
//        _tableView.delegate                     = self;
//        _tableView.dataSource                   = self;
        _tableView.estimatedRowHeight           = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseItemTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseGoodsMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseGoodsMsgTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
