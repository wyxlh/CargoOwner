//
//  YFHomeNearMapSiteView.m
//  YFKit
//
//  Created by 王宇 on 2018/6/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFHomeNearMapSiteView.h"
#import "YFHomeNearTableViewCell.h"
@implementation YFHomeNearMapSiteView

-(void)awakeFromNib{
    [super awakeFromNib];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//    tap.delegate = self;
//    [self addGestureRecognizer:tap];
    
    self.tableView.delegate                     = self;
    self.tableView.dataSource                   = self;
    self.tableView.estimatedRowHeight           = 70;
    [self.tableView registerNib:[UINib nibWithNibName:@"YFHomeNearTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFHomeNearTableViewCell"];
    @weakify(self)
    self.tableView.mj_footer                    = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        !self.callBackBlock ? : self.callBackBlock();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFHomeNearTableViewCell *cell               = [tableView dequeueReusableCellWithIdentifier:@"YFHomeNearTableViewCell" forIndexPath:indexPath];
    cell.dict                                   = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    !self.callLocationBlock ? : self.callLocationBlock(self.dataArr[indexPath.row]);
    [self disappear];
    
}

#pragma mark - 让视图消失的方法
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    if (point.y < ScreenHeight-NavHeight) {
        !self.dispperBlock ? : self.dispperBlock();
        return YES;
    }
    return NO;
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{
    [self disappear];
}

- (void)disappear
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.y = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) { // 优化后
        self.tableView.height = ScreenHeight-NavHeight;
        [self showSiteView:+300];
    } else if (scrollView.contentOffset.y < 0) {
        [self showSiteView:+ScreenHeight-NavHeight];
        self.tableView.height = 300+300;
    }
    
    if (scrollView.contentOffset.y < -50) {
        !self.dispperBlock ? : self.dispperBlock();
        [self disappear];
    }
}

- (void)showSiteView:(CGFloat)y {
    self.tableView.hidden                    = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.y = y;
    }];
}

@end
