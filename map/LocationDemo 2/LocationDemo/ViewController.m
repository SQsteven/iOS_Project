//
//  ViewController.m
//  LocationDemo
//
//  Created by 常彪 on 16/1/4.
//  Copyright © 2016年 0xcb. All rights reserved.
//

#import "ViewController.h"
//导入头文件
#import <CoreLocation/CoreLocation.h>

//角度转弧度
#define R2A(r) (r * M_PI / 180.f)

//如果是使用iOS SDK小于8.0的就需要写个类别
//声明CLLocationManager有这样一个方法
@interface CLLocationManager (hack)
- (void)requestAlwaysAuthorization;
@end


@interface ViewController () <CLLocationManagerDelegate>
{
    //使用ARC，一定要是成员变量,否则的话没次都会重新获取用户授权，并且iOS8之后不能定位
    CLLocationManager *_locManager;
    
    UIImageView *_bgView;
    UIImageView *_centerView;
    UIImageView *_rimView;
    UIImageView *_rimBgView;
    UIImageView *_rimBgImageView;
    UIImageView *_directView;
    UIImageView *_rimBorderView;
    UILabel     *_locationLab;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //一般遇到新的类都去看头文件的声明，找相关的初始化方法
    _locManager = [[CLLocationManager alloc] init];
    //定位之后的结果会在代理方法里面传过来
    _locManager.delegate = self;
    //比较坑的地方，iOS8之后
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f)
    {
        //需要在Info.plist添加NSLocationAlwaysUsageDescription键
        //If the NSLocationAlwaysUsageDescription key is not specified in your Info.plist, this method will do nothing, as your app will be assumed not to support Always authorization.
        //总是授权
        //[_locManager requestAlwaysAuthorization];
        
        //需要在Info.plist里面添加NSLocationWhenInUseUsageDescription键
        //If the NSLocationWhenInUseUsageDescription key is not specified in your Info.plist, this method will do nothing, as your app will be assumed not to support WhenInUse authorization.
        //当使用的时候进行授权
        [_locManager requestWhenInUseAuthorization];
    }
    
    
    //开始更新手机的位置
    [_locManager startUpdatingLocation];
    //开始更新手机指向的方向
    [_locManager startUpdatingHeading];
    
    
    
    //测试反解码, 中国河南省郑州市管城回族区经济开发区明湖街道经开第三大街168号
    CLLocation *beiJing = [[CLLocation alloc] initWithLatitude:34.72958621 longitude:113.74592800];
    [self geocorderLocation:beiJing];
    
    _bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgView.image = [UIImage imageNamed:@"Background-568h"];
    [self.view addSubview:_bgView];
    
    CGFloat r = CGRectGetWidth(self.view.bounds) - 43;
    _rimBgView = [[UIImageView alloc] initWithFrame:CGRectMake(21.5, CGRectGetHeight(self.view.bounds)*0.31f, r, r)];
    _rimBgView.image = [UIImage imageNamed:@"CompassBezel"];
    [self.view addSubview:_rimBgView];
    
    
    _rimBgImageView = [[UIImageView alloc] initWithFrame:CGRectInset(_rimBgView.bounds, 21, 21)];
    _rimBgImageView.image = [UIImage imageNamed:@"CompassFace"];
    [_rimBgView addSubview:_rimBgImageView];
    
    _rimView = [[UIImageView alloc] initWithFrame:CGRectInset(_rimBgView.bounds, 22, 22)];
    _rimView.image = [UIImage imageNamed:@"CompassFaceRim"];
    [_rimBgView addSubview:_rimView];
    
    _directView = [[UIImageView alloc] initWithFrame:CGRectInset(_rimBgView.bounds, 44, 44)];
    _directView.image = [UIImage imageNamed:@"CompassFaceDirection"];
    [_rimBgView addSubview:_directView];
    
    _rimBorderView = [[UIImageView alloc] initWithFrame:_rimView.frame];
    _rimBorderView.image = [UIImage imageNamed:@"CompassFaceShadow"];
    [_rimBgView addSubview:_rimBorderView];
    
    _centerView = [[UIImageView alloc] initWithFrame:CGRectMake(_rimBgView.bounds.size.width*0.5f-20, _rimBgView.bounds.size.height*0.5f-20, 40, 40)];
    _centerView.image = [UIImage imageNamed:@"CompassPivot"];
    [_rimBgView addSubview:_centerView];
    
    _locationLab = [[UILabel alloc] init];
    _locationLab.frame = CGRectMake(0, 0, self.view.bounds.size.width - 60, 40);
    _locationLab.font = [UIFont systemFontOfSize:13];
    _locationLab.center = CGPointMake(self.view.center.x, self.view.center.y - 240);
    _locationLab.numberOfLines = 0;
    _locationLab.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_locationLab];
}

#pragma mark 定位相关的代理方法

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%s", __func__);
}

//反编码地理坐标
- (void)geocorderLocation:(CLLocation *)loc
{
    //地理编码;地形编码, 是一个耗时的任务
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        //<CLPlacemark *>
        if (error) {
            NSLog(@"地理位置反编码错误 === %@", error);
        }else{
            //没有错误，可以遍历结果
            for (CLPlacemark *mark in placemarks) {
                NSLog(@"地理名字 ==== %@", mark.name);
                _locationLab.text = mark.name;
                NSLog(@"街道 ==== %@", mark.thoroughfare);
                NSLog(@"城市 ==== %@", mark.locality);
                NSLog(@"邮编 ===== %@", mark.postalCode);
                //NSLog(@"位置信息 ==== %@", mark);
            }
            //NSLog(@"位置信息 ==== %@", placemarks);
        }
    }];
    
}

//<CLLocation *>
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%s", __func__);
    CLLocation *beiJing = [[CLLocation alloc] initWithLatitude:39.5427 longitude:116.2317];
    for (CLLocation *loc in locations) {
        //反解码用户当前经纬度坐标
        [self geocorderLocation:loc];
        
        //获取两个地理坐标的距离
        //- (CLLocationDistance)distanceFromLocation:(const CLLocation *)location
        //北京天安门广场的经纬度（东经：116°23′17〃，北纬：39°54′27〃
        CLLocationDistance dist = [loc distanceFromLocation:beiJing];
        NSLog(@"位置 === %@ 距离北京=%f", loc, dist);
        
    }
    //手机已经更新定位的位置了
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"手机的朝向改变 ==== %@", newHeading);
    NSLog(@"地理方向 ==== %f", newHeading.trueHeading);
    NSLog(@"磁极方向 ==== %f", newHeading.magneticHeading);
    //trueHeading地理方向
    //magneticHeading磁极的方向
    //headingAccuracy精度
    //x/y/z 三个轴
    
    //    指南针
    [UIView animateWithDuration:0.1f animations:^{
        //角度转换成弧度，
        //CGFloat angle = newHeading.magneticHeading * M_PI / 180.0f;
        //表盘
        _rimView.transform = CGAffineTransformMakeRotation(R2A(-newHeading.trueHeading));
        CGAffineTransform transform = _rimView.transform;
        transform = CGAffineTransformScale(transform, 1, 1);
        _rimView.transform = transform;
//        CGAffineTransformConcat(;
//        , );
        //指针
        _directView.transform = _rimView.transform;
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"定位失败 ==== %@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
