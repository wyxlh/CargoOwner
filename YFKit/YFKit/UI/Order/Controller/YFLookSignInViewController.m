//
//  YFLookSignInViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFLookSignInViewController.h"
#import "YFLookSignModel.h"
#import "YFLookSignCollectionViewCell.h"
#import "YFLookImgItemCollectionViewCell.h"
@interface YFLookSignInViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) YFLookSignModel *mainModel;
@end

@implementation YFLookSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self netWork];
}

-(void)setUI{
    self.title                                     = @"查看签收";
    self.collectionView.delegate                   = self;
    self.collectionView.dataSource                 = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFLookSignCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFLookSignCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFLookImgItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFLookImgItemCollectionViewCell"];
}

#pragma mark netWork
-(void)netWork{
    NSMutableDictionary *parms                        = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.taskId forKey:@"taskId"];
    @weakify(self)
    [WKRequest getWithURLString:@"v1/taskOrder/taskOrderDetail.do?" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.mainModel                            = [YFLookSignModel mj_objectWithKeyValues:baseModel.data];
            [self.collectionView reloadData];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 0 ? 1 : self.mainModel.opPicurls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YFLookSignCollectionViewCell *cell           = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFLookSignCollectionViewCell" forIndexPath:indexPath];
        cell.model                                   = self.mainModel;
        return cell;
    }
    YFLookImgItemCollectionViewCell *cell            = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFLookImgItemCollectionViewCell" forIndexPath:indexPath];
    cell.path                                        = self.mainModel.opPicurls[indexPath.row];
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(ScreenWidth, 195.0f);
    }
    return CGSizeMake((ScreenWidth-50)/2, (ScreenWidth-50)/2);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20.0f, 20.0f, 0, 20.0f);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSMutableArray *items = @[].mutableCopy;
        for (int i = 0; i < self.mainModel.opPicurls.count; i++) {
            YFLookImgItemCollectionViewCell *cell = (YFLookImgItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            NSString *url = [NSString stringWithFormat:@"%@",self.mainModel.opPicurls[i]];
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imgView imageUrl:[NSURL URLWithString:url]];
            [items addObject:item];
        }
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
//        browser.delegate = self;
        browser.dismissalStyle = _dismissalStyle;
        browser.backgroundStyle = _backgroundStyle;
        browser.loadingStyle = _loadingStyle;
        browser.pageindicatorStyle = _pageindicatorStyle;
        browser.bounces = _bounces;
        [browser showFromViewController:self];
    }
}

// MARK: - KSPhotoBrowserDelegate

//- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
//    NSLog(@"selected index: %ld", index);
//}







@end
