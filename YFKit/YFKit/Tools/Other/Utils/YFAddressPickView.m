//
//  YFAddressPickView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define windowColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]
#define navigationViewHeight 45.0f
#define pickViewViewHeight 213.0f

#import "YFAddressPickView.h"

@interface YFAddressPickView ()
{
    NSString *provinceString,*cityString,*areaString,*provinceId,*cityId,*areaId;
}
@property(nonatomic,strong)NSMutableArray *DataArray;
@property(nonatomic,strong)NSDictionary   *AllCityDict;
@property(nonatomic,strong)NSMutableArray *provinceArray;
@property(nonatomic,strong)NSMutableArray *cityArray;
@property(nonatomic,strong)NSMutableArray *townArray;
@property(nonatomic,strong)UIView *bottomView;//包括导航视图和地址选择视图
@property(nonatomic,strong)UIPickerView *pickView;//地址选择视图
@property(nonatomic,strong)UIView *navigationView;//上面的导航视图

@end

@implementation YFAddressPickView
YFAddressPickView *shareInstance;

+ (instancetype)shareInstance
{
    //static AddressPickView *shareInstance = nil;
    //static dispatch_once_t onceToken;
    // dispatch_once(&onceToken, ^{
    if (!shareInstance) {
        shareInstance = [[YFAddressPickView alloc] init];
    }
    // });
    
    [shareInstance showBottomView];
    return shareInstance;
}

+ (void)resetPicker
{
    shareInstance = nil;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addTapGestureRecognizerToSelf];
        [self createView];
    }
    return self;
    
}

#pragma mark - get data
- (void)getPickerDataWithProvince:(NSArray *)ProvinceArr CityArr:(NSDictionary *)CityArr ProvinceId:(NSString *)province CityId:(NSString *)city DistrictId:(NSString *)district
{
    //记录初始状态
    provinceId = province;
    cityId = city;
    areaId = district;
    [self.provinceArray removeAllObjects];
    [self.cityArray removeAllObjects];
    [self.townArray removeAllObjects];
    
    self.DataArray              = (NSMutableArray *)ProvinceArr;
    self.AllCityDict            = CityArr;

    //省的数据
    [self.provinceArray addObject:self.DataArray];
    //拿到城市的数据
    NSDictionary *cityDict = [CityArr safeJsonObjForKey:province];

    
    [self.cityArray addObject:cityDict];
    
    // 区的数据
    
    NSDictionary *districtDict = [CityArr safeJsonObjForKey:city];
    
    [self.townArray addObject:districtDict];
    
    //默认选中第一个省市区
    provinceString = [[[self.provinceArray objectAtIndex:0] safeObjectAtIndex:[_pickView selectedRowInComponent:0]] stringObjectForKey:@"address"];
    
    NSDictionary *cityNameDict = [self.cityArray safeObjectAtIndex:0];
    cityString = [cityNameDict.mj_keyValues.allValues safeObjectAtIndex:[_pickView selectedRowInComponent:1]];
    
    NSDictionary *areaIdDict = [self.townArray safeObjectAtIndex:0];
    areaString = [areaIdDict.mj_keyValues.allValues safeObjectAtIndex:[_pickView selectedRowInComponent:2]];
    
    [_pickView reloadComponent:0];
    [_pickView selectRow:0 inComponent:0 animated:YES];
    [_pickView selectRow:0 inComponent:1 animated:YES];
    [_pickView selectRow:0 inComponent:2 animated:YES];
    
    
}

- (NSInteger)getIdIndex:(NSString *)Id Key:(NSString *)key FromArray:(NSArray *)array
{
    for (int i = 0; i<array.count; i++) {
        NSDictionary *dic =array[i];
        if ([Id isEqualToString:[dic stringObjectForKey:key]]) {
            return i;
        }
    }
    return 0;
}
-(NSMutableArray *)cityArray{
    
    if (!_cityArray) {
        _cityArray = [NSMutableArray new];
    }
    return _cityArray;
}
-(NSMutableArray *)townArray{
    
    if (!_townArray) {
        _townArray = [NSMutableArray new];
    }
    return _townArray;
}

-(NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray new];
    }
    return _provinceArray;
    
}

-(void)addTapGestureRecognizerToSelf
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBottomView)];
    [self addGestureRecognizer:tap];
}
-(void)createView
{
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, navigationViewHeight+pickViewViewHeight)];
    [self addSubview:_bottomView];
    //导航视图
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, navigationViewHeight)];
    _navigationView.backgroundColor = [UIColor whiteColor];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, navigationViewHeight-0.5, ScreenWidth, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xDEDEDE);
    [_navigationView addSubview:line];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 80, navigationViewHeight);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:[UIColor colorWithWhite:0.267 alpha:1.000] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hiddenBottomView) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(ScreenWidth - 80, 0, 80, navigationViewHeight);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn setTitleColor:[UIColor colorWithWhite:0.267 alpha:1.000] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:sureBtn];
    
    
    [_bottomView addSubview:_navigationView];
    //这里添加空手势不然点击navigationView也会隐藏,
    UITapGestureRecognizer *tapNavigationView = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [_navigationView addGestureRecognizer:tapNavigationView];
    
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, _navigationView.maxY, kScreenWidth, pickViewViewHeight)];
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.dataSource = self;
    _pickView.delegate =self;
    
    [_bottomView addSubview:_pickView];
    
}
#pragma mark - 确定按钮点击
-(void)tapButton:(UIButton*)button
{
    //点击确定回调block
//    if (self.DataArray) {
//        _block(provinceString,cityString,areaString,provinceId,cityId,areaId);
//    }
    
    NSString *address = [NSString stringWithFormat:@"%@/%@/%@",provinceString,cityString,[NSString getNullOrNoNull:areaString]];
    !self.startPlaceBlock ? : self.startPlaceBlock (address);
    [self hiddenBottomView];
}
-(void)showBottomView
{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.frame = CGRectMake(0, kScreenHeight-navigationViewHeight-pickViewViewHeight, kScreenWidth, navigationViewHeight+pickViewViewHeight);
        self.backgroundColor = windowColor;
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)hiddenBottomView
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, navigationViewHeight+pickViewViewHeight);
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        NSArray *array = [self.provinceArray safeObjectAtIndex:0];
        return array.count;
    } else if (component == 1) {
        NSDictionary *array = [self.cityArray safeObjectAtIndex:0];
        return array.count;
    } else {
        NSDictionary *array = [self.townArray safeObjectAtIndex:0];
        return array.count;
    }
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *lable=[[UILabel alloc]init];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.numberOfLines = 2;
    lable.font=[UIFont systemFontOfSize:14.0f];
    if (component == 0) {
        lable.text=[[[self.provinceArray safeObjectAtIndex:0]safeObjectAtIndex:row]stringObjectForKey:@"address"];
    } else if (component == 1) {
        //加保险,防止数组越界
        NSDictionary *dict = [self.cityArray safeObjectAtIndex:0];
        NSArray *cityArr = dict.mj_keyValues.allValues;
        lable.text = [cityArr safeObjectAtIndex:row];
    } else {
        //加保险,防止数组越界
        NSDictionary *dict = [self.townArray safeObjectAtIndex:0];
        NSArray *townArr = dict.mj_keyValues.allValues;
        lable.text = [townArr safeObjectAtIndex:row];
    }
    return lable;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    //这里减五 是为了伟大的"甘肃省临夏回族自治州积石山保安族东乡族撒拉族自治县"等名字长的地方(郭长峰)
    CGFloat pickViewWidth = kScreenWidth/3-5;
    
    return pickViewWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 35;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        
        if (self.cityArray.count>0) {
            [self.cityArray removeAllObjects];
        }
        
        DLog(@"%@",[self.provinceArray safeObjectAtIndex:0][row]);
        //得到选中省的 code
        NSString *cityCode = [NSString stringWithFormat:@"%@",[[self.provinceArray safeObjectAtIndex:0][row] safeJsonObjForKey:@"code"]];
        
        NSDictionary *cityDict = [self.AllCityDict safeJsonObjForKey:cityCode];
        [self.cityArray addObject:cityDict];
        
        if (self.townArray.count>0) {
            [self.townArray removeAllObjects];
        }
        
        //得到城市的第一条数据的code
        NSString *distric = cityDict.mj_keyValues.allKeys[0];
        
        NSDictionary *districtDict = [self.AllCityDict safeJsonObjForKey:distric];
        if (districtDict.count != 0) {
            [self.townArray addObject:districtDict];
        }
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    if (component == 1) {
        if (self.cityArray.count > 0) {
            if (self.townArray.count>0) {
                [self.townArray removeAllObjects];
            }
            NSDictionary *cityDict = self.cityArray[0];
            NSString *cityCode = cityDict.mj_keyValues.allKeys[row];
            
            NSDictionary *districtDict = [self.AllCityDict safeJsonObjForKey:cityCode];
            if (districtDict.count != 0) {
                 [self.townArray addObject:districtDict];
            }
        } else {
            self.townArray = nil;
        }
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    [self configVarsWithComponent:component row:row];
}


/**
 *  滚动结束刷新数据
 *
 */
- (void)configVarsWithComponent:(NSInteger)component row:(NSInteger)row{
    
    switch (component) {
        case 0:
        {
            DLog(@"%@",self.provinceArray);
            provinceString = [[[self.provinceArray objectAtIndex:0] safeObjectAtIndex:[_pickView selectedRowInComponent:0]] stringObjectForKey:@"address"];
            
            NSDictionary *cityNameDict = [self.cityArray safeObjectAtIndex:0];
            cityString = [cityNameDict.mj_keyValues.allValues safeObjectAtIndex:[_pickView selectedRowInComponent:1]];
            
            NSDictionary *areaNameDict = [self.townArray safeObjectAtIndex:0];
            areaString = [areaNameDict.mj_keyValues.allValues safeObjectAtIndex:[_pickView selectedRowInComponent:2]];
            
            provinceId = [[[self.provinceArray objectAtIndex:0] safeObjectAtIndex:[_pickView selectedRowInComponent:0]] stringObjectForKey:@"code"];
            
            cityId = [cityNameDict.mj_keyValues.allKeys safeObjectAtIndex:[_pickView selectedRowInComponent:1]];
            
            areaId = [areaNameDict.mj_keyValues.allKeys safeObjectAtIndex:[_pickView selectedRowInComponent:2]];
            
        }
            break;
        case 1:
        {
             provinceString = [[[self.provinceArray objectAtIndex:0] safeObjectAtIndex:[_pickView selectedRowInComponent:0]] stringObjectForKey:@"address"];
            
            NSDictionary *cityNameDict = [self.cityArray safeObjectAtIndex:0];
            cityString = [cityNameDict.mj_keyValues.allValues safeObjectAtIndex:[_pickView selectedRowInComponent:1]];
            
            NSDictionary *areaNameDict = [self.townArray safeObjectAtIndex:0];
            areaString = [areaNameDict.mj_keyValues.allValues safeObjectAtIndex:[_pickView selectedRowInComponent:2]];
            
            provinceId = [[[self.provinceArray objectAtIndex:0] safeObjectAtIndex:[_pickView selectedRowInComponent:0]] stringObjectForKey:@"code"];
            
            cityId = [cityNameDict.mj_keyValues.allKeys safeObjectAtIndex:[_pickView selectedRowInComponent:1]];
            
            areaId = [areaNameDict.mj_keyValues.allKeys safeObjectAtIndex:[_pickView selectedRowInComponent:2]];
            
        }
            break;
        case 2:
        {
            provinceString = [[[self.provinceArray objectAtIndex:0] safeObjectAtIndex:[_pickView selectedRowInComponent:0]] stringObjectForKey:@"address"];
            
            NSDictionary *cityNameDict = [self.cityArray safeObjectAtIndex:0];
            cityString = [cityNameDict.mj_keyValues.allValues safeObjectAtIndex:[_pickView selectedRowInComponent:1]];
            
            NSDictionary *areaIdDict = [self.townArray safeObjectAtIndex:0];
            areaString = [areaIdDict.mj_keyValues.allValues safeObjectAtIndex:[_pickView selectedRowInComponent:2]];
            
            provinceId = [[[self.provinceArray objectAtIndex:0] safeObjectAtIndex:[_pickView selectedRowInComponent:0]] stringObjectForKey:@"code"];
            
            cityId = [cityNameDict.mj_keyValues.allKeys safeObjectAtIndex:[_pickView selectedRowInComponent:1]];
            
            areaId = [areaIdDict.mj_keyValues.allKeys safeObjectAtIndex:[_pickView selectedRowInComponent:2]];
            
        }
            break;
        default:
            break;
    }
    
    
}


@end
