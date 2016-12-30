//
//  ViewController.m
//  LocationDemo
//
//  Created by 常彪 on 16/4/12.
//  Copyright © 2016年 0xcb. All rights reserved.
//

/*
 定位用户位置属于个人的隐私信息
 都要获取用户的授权
 可以定位用户的手机的当前位置，
 手机的头部的朝向
 */

#import "ViewController.h"
//定位相关
#import <CoreLocation/CoreLocation.h>
//地图
#import <MapKit/MapKit.h>
//自定义的标注数据模型类
#import "CBAnnotation.h"    




@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
{
    //必须声明为成员变量，如果不谨慎，会造成授权获取不到
    //位置的管理
    CLLocationManager *_lmanager;
    //地图
    MKMapView *_mapView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        //定位服务可用
        _lmanager = [[CLLocationManager alloc] init];
        //设置代理，处理异步的定位的回调
        _lmanager.delegate = self;
        
        /*
        Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[CLLocationManager requestAlwaysAuthorization]: unrecognized selector sent to instance 0x1f1ba530'
         */
        //iOS 8.0之后需要手动调用代码获取授权
        //iOS 8.0之前直接调用开始定位的方法，
        //这两个只需要调用其中一个就可以
        //直接获取授权 If the NSLocationAlwaysUsageDescription key is not specified in your Info.plist, this method will do nothing
        //必须要指定NSLocationAlwaysUsageDescription的key才能调用requestAlwaysAuthorization
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
            [_lmanager requestAlwaysAuthorization];
        }
        //使用的时候获取授权，需要指定NSLocationWhenInUseUsageDescription的key
        //[_lmanager requestWhenInUseAuthorization];
        
        //开始定位用户位置
        [_lmanager startUpdatingLocation];
        //开始定位用户手机的朝向
        [_lmanager startUpdatingHeading];
        
    }else{
        //HUD提示一下，当前定位服务不可用，请在设置里面打开
    }
    
    //地理位置的编码，和反编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"厦门高崎国际机场" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"地址位置编码完成");
        //NSLog(@"编码地理位置 === %@ %@", placemarks, error);
        for (CLPlacemark *mark in placemarks) {
            NSLog(@"%f %f 名字：%@ 街道：%@ 门牌号：%@ 城市：%@ 县级：%@ 国家：%@", mark.location.coordinate.longitude,
                  mark.location.coordinate.latitude, mark.name, mark.thoroughfare, mark.subThoroughfare, mark.locality, mark.subLocality, mark.subAdministrativeArea);
        }
    }];
    
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(24.534586, 118.131845);
    //封装
    [self reverseCoordinate:coor complitionHandler:^(NSString *info) {
        NSLog(@"地址位置坐标解码：%@", info);
    }];
    
    
    //地图, 大小是view的bounds、frame、center，单位：point
    //显示的内容：region, centerCoordinate，单位：经纬度
    CGRect mapFrame = CGRectInset(self.view.bounds, 20, 20);
    _mapView = [[MKMapView alloc] initWithFrame:mapFrame];
    //可以捕获一些代理事件、拖动、加载、定位
    _mapView.delegate = self;

    //地图的样式、类型，可以改成卫星图、或者混合类型的
//    _mapView.mapType = MKMapTypeHybrid;
//    _mapView.region
    CLLocationCoordinate2D cenCoor = CLLocationCoordinate2DMake(24.534586, 118.131845);
#pragma unused(cenCoor)
    //指定地图内容的中心点的经纬度坐标
    //_mapView.centerCoordinate = cenCoor;
    //跨度指定经纬度的delta
    //MKCoordinateSpan span = MKCoordinateSpanMake(2, 2);
    //_mapView.region = MKCoordinateRegionMake(cenCoor, span);
    //指定区域的精确到单位米
    //_mapView.region = MKCoordinateRegionMakeWithDistance(cenCoor, 100, 100);
    //定位用户当前位置并且显示出来,
    //iOS8.0之后需要配合CLLocationManager一块使用
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    
    
    NSLog(@"MapView上面的手势：%@", _mapView.subviews[0].gestureRecognizers);
    //添加点击的手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapAction:)];
    [_mapView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    //转换坐标系view里面有一些convert
    
    //UIView的坐标系中触摸的点
    CGPoint touchPos = [sender locationInView:sender.view];
    NSLog(@"相对于地图的view点击的位置：%@", NSStringFromCGPoint(touchPos));
    CGPoint touchPos2 = [sender locationInView:self.view];
    NSLog(@"相对于self.view点击的位置：%@", NSStringFromCGPoint(touchPos2));
    //把地图上的点转换成self.view的点
    CGPoint touchPos3 = touchPos;
    touchPos3.x += _mapView.frame.origin.x;
    touchPos3.y += _mapView.frame.origin.y;
    NSLog(@"手动转换地图view上的点到self.view的坐标系 %@", NSStringFromCGPoint(touchPos3));
    CGPoint touchPos4 = [self.view convertPoint:touchPos fromView:_mapView];
    NSLog(@"使用self.view把来自于地图view的点转换到self.view坐标系 %@", NSStringFromCGPoint(touchPos4));
    CGPoint touchPos5 = [_mapView convertPoint:touchPos toView:self.view];
    NSLog(@"转换地图view上的点到self.view的坐标系 %@", NSStringFromCGPoint(touchPos5));
    
    //使用convert转换UIView的坐标到地图的经纬度坐标
    CLLocationCoordinate2D coor = [_mapView convertPoint:touchPos toCoordinateFromView:sender.view];
//    [_mapView setCenterCoordinate:coor animated:YES];
    [self reverseCoordinate:coor complitionHandler:^(NSString *info) {
        NSLog(@"点击的位置的信息解码： %@", info);
        
        
        //加一个大头针，或者自定义的标注
        //添加的是数据模型的对象，
        Class clz = arc4random()%2==0 ? [MKPointAnnotation class] : [CBAnnotation class];
        MKShape *pa = [[clz alloc] init];
        pa.coordinate = coor;
        //想要有气泡必须制定标题
        pa.title = info;
        [_mapView addAnnotation:pa];
        
        //这里是获取不到的, 原因是还没有刷新添加AnnotationView
        MKAnnotationView *annoView = [_mapView viewForAnnotation:pa];
        NSLog(@"%@", annoView);
    }];
    
    
    //转换指定的地图上的经纬度坐标 =>  UIView上的点
    //- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(nullable UIView *)view;
    
}

- (void)reverseCoordinate:(CLLocationCoordinate2D)coor complitionHandler:(void(^)(NSString *))complition
{
    CLGeocoder *reCorder = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
    [reCorder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"地址位置坐标解码完成");
        for (CLPlacemark *mark in placemarks) {
            NSString *info = [NSString stringWithFormat:@"%f %f 名字：%@ 街道：%@ 门牌号：%@ 城市：%@ 县级：%@ 国家：%@", mark.location.coordinate.longitude,
                  mark.location.coordinate.latitude, mark.name, mark.thoroughfare, mark.subThoroughfare, mark.locality, mark.subLocality, mark.subAdministrativeArea];
            complition(info);
            break;
        }
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //动画效果
    CLLocationCoordinate2D cenCoor = CLLocationCoordinate2DMake(24.534586, 118.131845);
    //[_mapView setCenterCoordinate:cenCoor animated:YES];
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(cenCoor, 100, 100) animated:YES];
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"位置更新 ==== %@", locations);
    
    for (CLLocation *loc in locations) {
        
        NSLog(@"位置： t:%@ lon:%f lat:%f", loc.timestamp, loc.coordinate.longitude, loc.coordinate.latitude);
        
        //地理位置的编码，和反编码
//        CLGeocoder 
        
        [self reverseCoordinate:loc.coordinate complitionHandler:^(NSString *info) {
            NSLog(@"当前位置坐标解码完成: %@", info);
        }];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"朝向更新 ==== 磁极方向：%f  相对于正南正北的方法：%f", newHeading.magneticHeading, newHeading.trueHeading);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"地图区域将要改变 %d", animated);
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"地图区域已经改变 %d", animated);
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"地图区域将要开始加载");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"地图区域加载完成");
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"地图区域将加载失败 %@", error);
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        static NSString *reuseId =  @"pin";
        //大头针类型的
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        }
        //配置大头针
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0) {
            //紫色的
            pinView.pinTintColor = [MKPinAnnotationView purplePinColor];
        }
        //动画下落的效果
        pinView.animatesDrop = YES;
        //可以长按拖动的
        pinView.draggable = YES;
        //点击不会弹出气泡的原因是canShowCallout和数据对象标题
        pinView.canShowCallout = YES;
        //图片
        pinView.image = [UIImage imageNamed:@"timg"];
        return pinView;
    }else if([annotation isKindOfClass:[CBAnnotation class]]){
        static NSString *reuseId = @"myAnno";
        MKAnnotationView *anView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (!anView) {
            anView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        }
        //配置标注的视图
        anView.image = [UIImage imageNamed:@"timg"];
        anView.canShowCallout = YES;
        //默认弹出气泡
        anView.selected = YES;
        //弹出气泡视图的左半部分
        anView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:anView.image];
        
        //弹出气泡的右半部分
        UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        infoLab.text = annotation.title;
        infoLab.numberOfLines = 0;
        anView.rightCalloutAccessoryView = infoLab;
        return anView;
    }
    return nil;
}


@end



