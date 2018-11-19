//
//  YFRegisterViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFRegisterViewController.h"
#import "YFRegisterTableViewCell.h"
@interface YFRegisterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@end

@implementation YFRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title                                               = @"注册";
    self.navigationController.navigationBar.translucent      = NO;
    self.navigationController.navigationBar.barTintColor     = UIColorFromRGB(0x004197);
    [self.tableView reloadData];
}

#pragma markUITableViewDelegate,UITableViewDataSource 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFRegisterTableViewCell *cell               = [tableView dequeueReusableCellWithIdentifier:@"YFRegisterTableViewCell" forIndexPath:indexPath];
    cell.superVC                                = self;
    @weakify(self)
    cell.registerSuccessBlock                   = ^{
        @strongify(self)
        [self Back];
    };
    return cell;
}

#pragma mark  返回
-(void)Back{
    [self selectTabbarIndex:0];
    NSArray* vcarr = [self.navigationController viewControllers];
    if (vcarr.count > 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedRowHeight           = 200;
        [_tableView registerNib:[UINib nibWithNibName:@"YFRegisterTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFRegisterTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    YFRegisterTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //离开界面销毁定时器
    [cell.timer invalidate];
    cell.timer = nil;
    
}


@end
