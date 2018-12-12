//
//  JMUpdataImage.m
//  SKKit
//
//  Created by 王宇 on 16/7/16.
//  Copyright © 2016年 wy. All rights reserved.
//

#import "JMUpdataImage.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface JMUpdataImage()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIViewController *ViewC;
}

@end

@implementation JMUpdataImage

-(instancetype)init{
    if (self=[super init]) {
        self.tag = 100;
    }
    return self;
}

-(void)camera:(UIViewController*)ViewController{
    ViewC=ViewController;
    //如果没有相机权限 给出提示
    if (![self isAllowOpenCamera]) {
        [self showAlert];
    }
    [ViewC.view addSubview:self];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [ViewC presentViewController:picker animated:YES completion:nil];
}

-(void)updateLogo:(UIViewController *)ViewController {
    ViewC=ViewController;
     [ViewC.view addSubview:self];
    //调用相册
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [ViewC presentViewController:pickerImage animated:YES completion:^{

    }];
}

#pragma mark 点击相册中的图片 或照相机照完后点击use  后触发的方法 UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{


    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
     
        

        //设置image的尺寸
        CGSize imagesize = image.size;
        image = [self imageWithImage:image scaledToSize:imagesize];
        if (self.callBackImage) {
             self.callBackImage([self UIImageToBase64Str:image],image);
        }
       
//        //图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//
//        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];

        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            UIView *view=[ViewC.view  viewWithTag:100];
            [view removeFromSuperview];
        }];
    }
}

//对图片进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);

    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext();

    // Return the new image.
    return newImage;
}
//图片转为nsstring
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    CGSize imagesize = image.size;
    image = [self imageWithImage:image scaledToSize:CGSizeMake(imagesize.width/2, imagesize.height/2)];
    
    
    NSData *data = UIImageJPEGRepresentation(image,0.1);
    
    
    NSString *encodedImageStr = [NSString stringWithFormat:@"%@",[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    
    return encodedImageStr;
}

- (void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在iPhone的'设置-隐私-照片'选项中,允许乾坤货主版访问您手机相机" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alert addAction:confirm];
    
    [ViewC presentViewController:alert animated:YES completion:nil];
    return;
}

/**
 查看是否打开相机权限
 
 @return  YES打开 NO没打开
 */
- (BOOL)isAllowOpenCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

@end
