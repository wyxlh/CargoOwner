//
//  YFAboutViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFAboutViewController.h"
#import "YFFeedBackTableViewCell.h"
#import "YFAboutHeadView.h"
@interface YFAboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFAboutHeadView *headView;
@property (nonatomic, copy, nullable)   NSString *content;
@end

@implementation YFAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                      = @"关于我们";
    [self netWork];
}

-(void)netWork{
    @weakify(self)
    [WKRequest getWithURLString:@"system/aboutUs.do" parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.content            = baseModel.data;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFFeedBackTableViewCell *cell               = [tableView dequeueReusableCellWithIdentifier:@"YFFeedBackTableViewCell" forIndexPath:indexPath];
    cell.content.text                           = self.content;
    return cell;
}

#pragma mark tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor              = [UIColor whiteColor];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight           = 200;
        _tableView.tableHeaderView              = self.headView;
        [_tableView registerNib:[UINib nibWithNibName:@"YFFeedBackTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFFeedBackTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /**
     *  这里的偏移量是纵向从contentInset算起 则一开始偏移就是0 向下为负 上为正 下拉
     */
    
    // 获取到tableView偏移量
    CGFloat Offset_y = scrollView.contentOffset.y;
    // 下拉 纵向偏移量变小 变成负的
    if ( Offset_y < 0) {
        // 拉伸后图片的高度
        CGFloat totalOffset = 200*ScreenWidth/320 - Offset_y;
        // 图片放大比例
        CGFloat scale = totalOffset / (200*ScreenWidth/320);
        CGFloat width = ScreenWidth;
        // 拉伸后图片位置
        _headView.pictureImageView.frame = CGRectMake(-(width * scale - width) / 2, Offset_y, width * scale, totalOffset);
    }
    
}

#pragma mark headView
-(YFAboutHeadView *)headView{
    if (!_headView) {
        _headView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFAboutHeadView" owner:nil options:nil] lastObject];
        _headView.frame                          = CGRectMake(0, 0, ScreenWidth, 200*ScreenWidth/320);
    }
    return _headView;
}


@end
