//
//  YFSortView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSortView.h"
#import "YFSortViewTableViewCell.h"
@implementation YFSortView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.isEqual                        = 0;
    self.tableView.delegate             = self;
    self.tableView.dataSource           = self;
    self.tableView.rowHeight            = 44.0f;
    self.tableView.separatorStyle       = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"YFSortViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFSortViewTableViewCell"];
}

-(void)setType:(NSInteger)type{
    _type                               = type;
    if (type == 1) {
        self.dataArr                    = [NSArray getTimeSortData];
    }else{
        self.dataArr                    = [NSArray getMoneySortData];
    }
    //如果两次都点击的是同一个则不刷新
    if (type != self.isEqual) {
        [self.tableView reloadData];
    }
    self.isEqual                        = type;
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFSortViewTableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"YFSortViewTableViewCell" forIndexPath:indexPath];
    cell.title.text                     = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self disappear];
    //因为目前就两种排序的方式 所以只需要吧 indexPath.row传回去就行了
    !self.backSortStateBlock ? : self.backSortStateBlock(indexPath.row,self.type);
}



-(void)disappear{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.y = 85.0f;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
