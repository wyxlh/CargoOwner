//
//  YFPersonalMsgViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFPersonalMsgViewController.h"
#import "YFPersonCollectionViewCell.h"
#import "YFPersonImgCollectionViewCell.h"
#import "YFPersonSubmitCollectionViewCell.h"
#import "JMUpdataImage.h"
#import "YFPersonImageModel.h"
#import "YFPersonPhotoModel.h"
#import "YFUpdataPhotoView.h"
#import "YFModeBindViewController.h"
#import "YFUserInfoCompleteModel.h"
#import <TZImagePickerController.h>

@interface YFPersonalMsgViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <YFPersonPhotoModel *> *titleArr,*photoArr;;
@property (nonatomic, strong) NSMutableArray *userPhotoArr;//图片数据
@property (nonatomic, strong) JMUpdataImage *updataImage;
@property (nonatomic, assign) NSInteger selectIndex;//选中的是哪个位置上传的图片
@property (nonatomic, strong) YFPersonImageModel *mainModel;
@property (nonatomic, strong) UITextField *nameTF,*IDCardTF,*companyNameTF;//真实命中 身份证号 公司名
@property (nonatomic, assign) BOOL isUpdata;//是否允许编辑
@property (nonatomic, strong) YFUpdataPhotoView *updataPhotoView;//上传图片
@end

@implementation YFPersonalMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self netWork];
}

-(void)setUI{
    self.title                              = @"个人资料";
    self.titleArr                          = [YFPersonPhotoModel mj_objectArrayWithKeyValuesArray:[NSArray getPersonIDCardTitle]];
    self.photoArr                          = [YFPersonPhotoModel mj_objectArrayWithKeyValuesArray:[NSArray getPersonIDCardTitle]];
    [self addBackItem];
    self.userPhotoArr                       = [NSMutableArray new];
    self.collectionView.delegate            = self;
    self.collectionView.dataSource          = self;
    self.collectionView.scrollEnabled       = ISIPHONEX ? NO : YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFPersonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFPersonCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFPersonImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFPersonImgCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFPersonSubmitCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFPersonSubmitCollectionViewCell"];
}

#pragma mark  获取个人资料
-(void)netWork{
    @weakify(self)
    [WKRequest getWithURLString:@"base/user/queryPerson.do" parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [self requestNetSuccess:baseModel.data];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}
//请求成功
-(void)requestNetSuccess:(NSString *)Data{
    self.mainModel                      = [YFPersonImageModel mj_objectWithKeyValues:Data];
    for (int i = 0; i < self.titleArr.count; i ++) {
        YFPersonPhotoModel *model       = self.titleArr[i];
        YFPersonPhotoModel *changeModel = self.photoArr[i];
        if (i == 0) {
            model.path                  = self.mainModel.identityUrl;
            changeModel.path            = self.mainModel.identityUrl;
        }else if (i == 1){
            model.path                  = self.mainModel.identityBackUrl;
            changeModel.path            = self.mainModel.identityBackUrl;
        }else if (i == 2){
            model.path                  = self.mainModel.businessCardUrl;
            changeModel.path            = self.mainModel.businessCardUrl;
        }else{
            model.path                 = self.mainModel.doorheadPhotoUrl;
            changeModel.path            = self.mainModel.doorheadPhotoUrl;
        }
        
        [self.userPhotoArr addObject:[NSString getNullOrNoNull:model.path]];

    }
    //主账户 第一次可直接修改
    [self canUpdata];
    [self.collectionView reloadData];
}

/**
 主账户 第一次可直接修改
 */
- (void)canUpdata{
    //子账号没有编辑按钮 001 不能编辑公司名称
    [self addRightTitleBtn:@"编辑"];
    int num = 0;
    if ([NSString isBlankString:self.mainModel.idcard]) {
        for (NSString *path in self.userPhotoArr) {
            if ([NSString isBlankString:path]) {
                num ++;
            }
        }
        //如果都是空的 则 num = 4;
        self.isUpdata                                   = self.rightTitleBtn.hidden = num == 4;
    }
}

-(void)showUpdataPhoto{
    self.updataPhotoView.hidden                         = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.updataPhotoView.backgroundColor            = [UIColor colorWithWhite:0.00 alpha:0.299];
        self.updataPhotoView.y                          = -350;
    }];
}

-(void)rightTitleButtonClick:(UIButton *)sender{
//    if (!self.mainModel.systemDef && !IS_CARGO_OWNER) {
//
//        [self showAlertViewControllerTitle:wenxinTitle Message:@"请联系管理员修改 021-32581211-8060" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
//
//        } confirmBlock:^{
//            NSString *driverMobile = @"tel:021-32581211-8060";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:driverMobile]];
//        }];
//        return;
//    }
    sender.selected                          = !sender.selected;
    self.isUpdata                            = sender.selected;
    //如果上传的图片 但是没有提交 就点击了取消按钮 那么就直接把之上传的图片移除掉
    for (int i = 0; i < self.titleArr.count; i++) {
        YFPersonPhotoModel *pModel           = self.titleArr[i];
        if (self.isUpdata && [pModel.path compare:@"group"]) {
            //出于取消编辑状态 和有本地图片这这数组里面 但是没有上传 需要把这张图片换成原来的
            pModel.path                      = [self.photoArr[i] path];
        }
    }
    
    [self.collectionView reloadData];
    [sender setTitle:self.isUpdata ? @"取消" : @"编辑" forState:UIControlStateNormal];
}

#pragma mark  修改个人资料 isAllChinese
-(void)updataUserInfo{
    NSString *alertMsg;
    if ([NSString isBlankString:self.nameTF.text]) {
        alertMsg                     = @"请输入您的真实姓名";
    }else if (![NSString isAllChinese:self.nameTF.text]){
        alertMsg                     = @"请输入您的真实姓名";
    }else if (self.nameTF.text.length < 2 || self.nameTF.text.length > 10){
        alertMsg                     = @"真实姓名为2-10个字符";
    }else if (![NSString validateIdentityCard:self.IDCardTF.text]){
        alertMsg                     = @"请输入正确的身份证号";
    }else if ([NSString isBlankString:self.companyNameTF.text]){
        alertMsg                     = @"请输入公司名称或个人姓名";
    }else if ([NSString isBlankString:[self.titleArr[0] path]]){
        alertMsg                     = @"请上传身份证正面照";
    }else if ([NSString isBlankString:[self.titleArr[1] path]]){
        alertMsg                     = @"请上传身份证反面照";
    }else if ([NSString isBlankString:[self.titleArr[2] path]] && [NSString isBlankString:[self.titleArr[3] path]]){
        alertMsg                     = @"请上传公司名片或门牌照";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    
    NSMutableDictionary *parms       = [NSMutableDictionary dictionary];
    if ([self.IDCardTF.text containsString:@"x"]) {
        self.IDCardTF.text           = [NSString getReplaceAfterWithReplaceBefore:self.IDCardTF.text NeedReplaceString:@"x" ReplaceAfterString:@"X"];
    }
    [parms safeSetObject:self.IDCardTF.text forKey:@"idcard"];
    [parms safeSetObject:self.nameTF.text forKey:@"realName"];
    [parms safeSetObject:self.mainModel.mobile forKey:@"mobile"];
    [parms safeSetObject:self.companyNameTF.text forKey:@"companyName"];
    [parms safeSetObject:[self.titleArr[0] path] forKey:@"identityUrl"];
    [parms safeSetObject:[self.titleArr[1] path] forKey:@"identityBackUrl"];
    [parms safeSetObject:[self.titleArr[2] path] forKey:@"businessCardUrl"];
    [parms safeSetObject:[self.titleArr[3] path] forKey:@"doorheadPhotoUrl"];
    
    @weakify(self)
    [WKRequest postWithURLString:@"base/user/updatePerson.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFToast showMessage:@"修改成功" inView:self.view];
            //修改用户信息完整字段
            [UserData setUserInfoStatus:@"1"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 上传图片
-(void)updataUserRelevantPhoto:(NSString *)data image:(UIImage *)image{
    NSMutableDictionary *parms               = [NSMutableDictionary dictionary];
    [parms safeSetObject:data forKey:@"drivingLicenseUrl"];
    @weakify(self)
    [WKRequest postWithUrlString:@"base/user/upload.do" parameters:parms uploadImage:image success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            NSDictionary *dict               = [baseModel.mDictionary safeJsonObjForKey:@"data"];
            [self updataPhotoSuccess:dict];
            //上传成功之后 在显示图片到页面上
            YFPersonImgCollectionViewCell *cell = (YFPersonImgCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:1]];
            cell.imgView.image                  = image;
            cell.noPhotoLbl.text                = @"点击修改";
            cell.noPhotoLbl.alpha               = 0.7;
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark
-(void)updataPhotoSuccess:(NSDictionary *)dict{
    NSString *file                           = [dict stringObjectForKey:@"userHeader"];
    YFPersonPhotoModel *pModel               = self.titleArr[self.selectIndex];
    pModel.path                              = file;
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 1 ? 4 : 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YFPersonCollectionViewCell *cell      = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFPersonCollectionViewCell" forIndexPath:indexPath];
        cell.isUpdata                         = self.isUpdata;
        cell.model                            = self.mainModel;
        self.nameTF                           = cell.name;
        self.IDCardTF                         = cell.IDCard;
        self.companyNameTF                    = cell.companyName;
        @weakify(self)
        [[[cell.changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            @strongify(self)
            YFModeBindViewController *bind    = [YFModeBindViewController new];
            bind.sourceType                   = BindPhoneByPersonMessageType;
            [self.navigationController pushViewController:bind animated:YES];
        }];
        return cell;
    }else if (indexPath.section == 1){
        YFPersonImgCollectionViewCell *cell   = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFPersonImgCollectionViewCell" forIndexPath:indexPath];
        cell.isUdate                          = self.isUpdata;
        if (self.isUpdata) {
            cell.model                        = self.titleArr[indexPath.row];
        }else{
            cell.model                        = self.photoArr[indexPath.row];
        }
        return cell;
    }
    YFPersonSubmitCollectionViewCell *cell    = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFPersonSubmitCollectionViewCell" forIndexPath:indexPath];
    cell.submitBtn.hidden                     = !self.isUpdata;
    @weakify(self)
    [[[cell.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self updataUserInfo];
    }];
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(ScreenWidth, 200.0f);
    }else if (indexPath.section == 1){
        return CGSizeMake((ScreenWidth-42)/3, ((ScreenWidth-42)/4*14)/10+37);
    }else{
        return CGSizeMake(ScreenWidth, ScreenHeight-200-((ScreenWidth-39)/4*14)/5-NavHeight+37);
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 6.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 6.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return section == 1 ? UIEdgeInsetsMake(10.0f, 15.0f, 0, 15.0f) : UIEdgeInsetsZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (!self.isUpdata) {
            //如果不是上传图片 是点击查看w图片, 如果当前这张图片没有 那么久不让点击
            if (![NSString isBlankString:[self.userPhotoArr objectAtIndex:indexPath.row]]) {
                [self showPhoto:collectionView didSelectItemAtIndexPath:indexPath];
            }
            return;
        }
        self.selectIndex                    = indexPath.row;
        
        [self showUpdataPhoto];
        if (self.selectIndex == 0) {
            //身份证正面
            self.updataPhotoView.title.text = @"上传身份证正面";
            self.updataPhotoView.placeHolderImg.image = [UIImage imageNamed:@"IDCardJust"];
        }else if (self.selectIndex == 1){
            //身份证反面
            self.updataPhotoView.title.text = @"上传身份证反面";
            self.updataPhotoView.placeHolderImg.image = [UIImage imageNamed:@"IDCardBack"];
        }else if (self.selectIndex == 2){
            //公司名片
            self.updataPhotoView.title.text = @"上传公司名片";
            self.updataPhotoView.placeHolderImg.image = [UIImage imageNamed:@"CompanyCard"];
        }else{
            //门头照
            self.updataPhotoView.title.text = @"上传公司门头照";
            self.updataPhotoView.placeHolderImg.image = [UIImage imageNamed:@"Doorhead"];
        }
    }
}

#pragma mark 点击显示大图
-(void)showPhoto:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.userPhotoArr.count == 0) {
        return;
    }
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < self.userPhotoArr.count; i++) {
        YFPersonImgCollectionViewCell *cell = (YFPersonImgCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        NSString *url = [NSString stringWithFormat:@"%@",self.userPhotoArr[i]];
        if (![NSString isBlankString:url]) {
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imgView imageUrl:[NSURL URLWithString:url]];
            [items addObject:item];
        }
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

#pragma mark 上传图片 updataPhotoView
- (YFUpdataPhotoView *)updataPhotoView{
    if (!_updataPhotoView) {
        _updataPhotoView                    = [[[NSBundle mainBundle] loadNibNamed:@"YFUpdataPhotoView" owner:nil options:nil] lastObject];
        _updataPhotoView.frame              = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 350);
        _updataPhotoView.autoresizingMask   = 0;
        @weakify(self)
        [[_updataPhotoView.albumBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            //相册
            [self.updataPhotoView disappear];
            [self updataImageto];
        }];
        [[_updataPhotoView.PhotoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
           @strongify(self)
            //拍照
            [self.updataPhotoView disappear];
            [self.updataImage camera:self];
            self.updataImage.callBackImage = ^(NSString *data,UIImage *image){
                @strongify(self)
                YFPersonImgCollectionViewCell *cell = (YFPersonImgCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:1]];
                cell.imgView.image                  = image;
                cell.noPhotoLbl.text                = @"点击修改";
                cell.noPhotoLbl.alpha               = 0.7;
                [self updataUserRelevantPhoto:data image:image];
            };
        }];
        
        [YFWindow addSubview:_updataPhotoView];
    }
    return _updataPhotoView;
}

#pragma mark 获取图片
-(JMUpdataImage *)updataImage{
    if (!_updataImage) {
        _updataImage                        = [[JMUpdataImage alloc]init];
    }
    return _updataImage;
}

- (void)updataImageto{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    // 你可以通过block或者代理，来得到用户选择的照片.
    @weakify(self)
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self)
        UIImage *image = [photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        NSString *encodedImageStr = [NSString stringWithFormat:@"%@",[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        [self updataUserRelevantPhoto:encodedImageStr image:image];
        
    }];

    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


@end
