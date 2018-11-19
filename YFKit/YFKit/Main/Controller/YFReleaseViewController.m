//
//  YFReleaseViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFReleaseViewController.h"
#import "YFReleaseItemTableViewCell.h"
#import "YFReleaseGoodsMsgTableViewCell.h"
#import "YFReleaseFooterView.h"
#import "YFChooseDriverViewController.h"
@interface YFReleaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) NSArray *titleArr,*placeholderArr;//title
@property (nonatomic, strong, nullable) NSArray *imgArr;//图片
@property (nonatomic, strong, nullable) YFReleaseFooterView *footerView;
@end

@implementation YFReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}



#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 || section == 1 ? 2 : 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//地址
        YFReleaseItemTableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseItemTableViewCell" forIndexPath:indexPath];
        cell.logo.image                            = [UIImage imageNamed:self.imgArr[indexPath.section][indexPath.row]];
        cell.title.text                            = self.titleArr[indexPath.section][indexPath.row];
        cell.placeholder.placeholder               = self.placeholderArr[indexPath.section][indexPath.row];
        return cell;
    }else if (indexPath.section == 1){// 货物信息
        if (indexPath.row == 0) {
            YFReleaseItemTableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseItemTableViewCell" forIndexPath:indexPath];
            cell.logo.image                        = [UIImage imageNamed:self.imgArr[indexPath.section][indexPath.row]];
            cell.title.text                        = self.titleArr[indexPath.section][indexPath.row];
            cell.placeholder.placeholder               = self.placeholderArr[indexPath.section][indexPath.row];
            return cell;
        }
        YFReleaseGoodsMsgTableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseGoodsMsgTableViewCell" forIndexPath:indexPath];
        cell.logo.image                            = [UIImage imageNamed:self.imgArr[indexPath.section][indexPath.row]];
        cell.title.text                            = self.titleArr[indexPath.section][indexPath.row];
        return cell;
    }else{//货车类型及需求
        YFReleaseItemTableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseItemTableViewCell" forIndexPath:indexPath];
        cell.logo.image                            = [UIImage imageNamed:self.imgArr[indexPath.section][indexPath.row]];
        cell.title.text                            = self.titleArr[indexPath.section][indexPath.row];
        cell.placeholder.placeholder               = self.placeholderArr[indexPath.section][indexPath.row];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return 87.0f;
        }
    }
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section < 2 ? 5.0f : 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //车型车长
        }else if (indexPath.row == 1){
            // 装货时间
        }else if (indexPath.row == 2){
            // 期望运费
        }else if (indexPath.row == 3){
            //其他要求
        }else if (indexPath.row == 4){
            //指定司机
            YFChooseDriverViewController *driver = [YFChooseDriverViewController new];
            driver.hidesBottomBarWhenPushed      = YES;
            [self.navigationController pushViewController:driver animated:YES];
        }
    }
}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight-self.footerView.height-45) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.estimatedRowHeight           = YES;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseItemTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseGoodsMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseGoodsMsgTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(YFReleaseFooterView *)footerView{
    if (!_footerView) {
        _footerView                             = [[[NSBundle mainBundle] loadNibNamed:@"YFReleaseFooterView" owner:nil options:nil] lastObject];
        _footerView.frame                       = CGRectMake(0, ScreenHeight-NavHeight-TabbarHeight-50-45, ScreenWidth, 50);
        @weakify(self)
        [[_footerView.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [YFToast showMessage:@"哈哈哈哈" inView:self.view];
//            [YFToast showMessage:@"哈哈哈"];
        }];
        [self.view addSubview:_footerView];
    }
    return _footerView;
}

-(void)setUI{
    self.titleArr                               = @[@[@"始发地",@"目的地"],
                                                    @[@"货品名称",@"货物重量/体积/件数"],
                                                    @[@"车型车长",@"装货时间",@"期望运费",@"其他要求",@"指定司机"]];
    self.imgArr                                 = @[@[@"Originating",@"End"],
                                                    @[@"goodName",@"weight"],
                                                    @[@"car",@"loadingTime",@"free",@"more",@"AppointPeople"]];
    self.placeholderArr                         = @[@[@"点击选择",@"点击选择"],
                                                    @[@"点击选择"],
                                                    @[@"点击选择",@"点击选择",@"非必选项",@"装卸要求、付款要求、其他等",@"选择好友(非必填)"]];
    [self.tableView reloadData];
}

@end
