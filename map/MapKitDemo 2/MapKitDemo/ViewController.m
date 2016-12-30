//
//  ViewController.m
//  MapKitDemo
//
//  Created by 常彪 on 16/1/4.
//  Copyright © 2016年 0xcb. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"


@interface MKMapView (fixed_old_xcode)
//显示比例尺
@property (nonatomic, assign) BOOL showsScale;
//指南针
@property (nonatomic, assign) BOOL showsCompass;
@end



@interface ViewController () <MKMapViewDelegate>
{
    //实例变量，成员变量
    MKMapView *_mapView;
    //管理定位授权，以及定位的功能，
    //8.0之后的手机都需要用CLLocationManager定位
    CLLocationManager *_locationManager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //防止低版本的手机调用不存在的属性或者方法，导致崩溃
    CGFloat sysVer = [[UIDevice currentDevice].systemVersion floatValue];
    

    //获取授权
    if (sysVer >= 8.0f) {
        //在iOS8.0之前是可以直接提示授权定位，并且可以定位用户的当前位置
        //2016-01-05 14:16:33.243 MapKitDemo[50745:2698152] Trying to start MapKit location updates without prompting for location authorization. Must call -[CLLocationManager requestWhenInUseAuthorization] or -[CLLocationManager requestAlwaysAuthorization] first.
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestAlwaysAuthorization];
    }
    
    
    
    //CGRectInset生成一个新的的距离原来的rect边距dx, dy的rect
    _mapView = [[MKMapView alloc] initWithFrame:CGRectInset(self.view.bounds, 100, 100)];
    //地图类型,
    _mapView.mapType = MKMapTypeStandard;
    //卫星和普通地图混合图
    //_mapView.mapType = MKMapTypeHybrid;
    //卫星图
    //_mapView.mapType = MKMapTypeSatellite;
    

    if (sysVer >= 9.0f)
    {
        //显示比例尺
        _mapView.showsScale = YES;
        //指南针
        _mapView.showsCompass = YES;
        //交通路况
        _mapView.showsTraffic = YES;
    }
    if (sysVer >= 7.0f) {
        //点信息
        _mapView.showsPointsOfInterest = YES;
        //建筑物
        _mapView.showsBuildings = YES;
    }

    _mapView.showsUserLocation = YES;
    _mapView.userLocation.title = @"当前位置";
    //代理
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    float f = 8.0;
    if (f == 8.0) {
        NSLog(@"相等");
    }else{
        NSLog(@"不相等");
    }
    f = f + .1;
    f = 8.1;
    NSLog(@"f = %f", f);
    if (f == 8.1f) { //正确的
//    if (f == 8.1) { //错误的
        NSLog(@"8.1相等");
    }else{
        NSLog(@"8.1不相等");
    }
    //直接写8.1是double类型，写8.1f是float类型
    NSLog(@"sizeof(float) === %ld", sizeof(float));
    NSLog(@"sizeof(double) === %ld", sizeof(double));
    NSLog(@"sizeof(8.1) === %ld", sizeof(8.1));
    NSLog(@"sizeof(8.1f) === %ld", sizeof(8.1f));
    NSLog(@"8.1 ===== %.15f", 8.1);
    NSLog(@"8.1f ===== %.15f", 8.1f);
    
    //地图上面默认有很多手势, 有些还是自己定义的私有的
    NSLog(@"地图上面的手势 ====  %@", [_mapView.subviews[0] gestureRecognizers]);
    
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_mapView addGestureRecognizer:tap];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(34.72958621, 113.74592800);
    //设置地图中心点经纬度坐标
//    [_mapView setCenterCoordinate:mapCenter animated:YES];
    
//    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(mapCenter, MKCoordinateSpanMa ke(10, 10));
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(mapCenter, 1000, 1000);
    //设置地图内容的区域
    [_mapView setRegion:mapRegion animated:YES];
    
    //注解，标注，
    //MKAnnotation协议，定义一些基础的注解需要用到的数据，和方法
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    //坐标
    point.coordinate = mapCenter;
    point.title = @"我的位置";
//    [_mapView addAnnotations:@[point]];
    [_mapView addAnnotation:point];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//思路：
//1.用点击的手势
//2.把点击的位置对应mapView的相对位置坐标找到，
//3.坐标转换，把点击在view上面的坐标，转换成地理位置的坐标
//4.添加注解，
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    //点击在view上的位置
    CGPoint touchSelfViewPos = [tap locationInView:self.view];
    
    //_mapView把self.view上面的点转换成相对于自己坐标系的点
    //CGPoint convToMapViewPos = [_mapView convertPoint:touchSelfViewPos fromView:self.view];
    //self.view把相对自己的点，转换到_mapView的坐标系中的点
    CGPoint convToMapViewPos = [self.view convertPoint:touchSelfViewPos toView:_mapView];
    
    
    //转换坐标:
//    UIView之间转换坐标
//    CALayer之间转换坐标
//    地图的坐标转换：不同类型的坐标
    CLLocationCoordinate2D convertCoor = [_mapView convertPoint:convToMapViewPos toCoordinateFromView:tap.view];
    [_mapView setCenterCoordinate:convertCoor animated:YES];
    //添加标注,
    //实际上这些数据没有顺序，并且来自于服务器
    //客户端把用户当前的位置的坐标上传给服务器的查询的接口
    //服务器去查询数据库（mysql, sqlserver, ）根据坐标查找附近的商户、用户
    //服务器把商户、用户的坐标和一些基本信息组装成json或者xml给客户端
    //客户端收到响应，解析，显示
    //LBS 基于位置的服务
    if (rand()%2 == 0)
    {
        //大头针
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = convertCoor;
        point.title = [NSString stringWithFormat:@"标注%d", rand()%100];
        [_mapView addAnnotation:point];
    }else{
        //自己定义的
        MyAnnotation *anno = [[MyAnnotation alloc] init];
        anno.coordinate = convertCoor;
        anno.title = [NSString stringWithFormat:@"商户%d", rand()%100];
        anno.subtitle = @"地址。。。。。。。";
        anno.phoneNumber = @"110";
        anno.type = @"shop";
        [_mapView addAnnotation:anno];
    }
    
    //覆盖物(会随着地图缩放、旋转一块进行缩放、旋转)
    const int coorCnt = 100;
    CLLocationCoordinate2D coors[coorCnt] = {};
    for (int i=0; i<coorCnt; ++i) {
        CLLocationCoordinate2D coor;
        coor.latitude = convertCoor.latitude + random()%100*1.0f*0.0001f;
        coor.longitude = convertCoor.longitude + random()%100*1.0f*0.00001f;;
        coors[i] = coor;
    }
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coors count:coorCnt];
    [_mapView addOverlay:line];
    
}


#pragma mark 地图的代理方法

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"地图的区域将要改变。。。");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"地图的区域已经改变。。。");
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"地图将要开始加载。。。");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"地图已经完成加载。。。");
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"地图已经加载失败。。。%@", error);
}

//nullable 可以为空,返回nil是默认值
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //判断一个对象是否是一个类（子类）的实例对象
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        static NSString *pinReuseId = @"pin-reuse-id";
        //需要先从重用池(NSMutableArray)中找可以重用的
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReuseId];
        //如果找不到的话创建
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinReuseId];
        }
        //pinView.pinTintColor, 9.0之后的系统可以设置
        //pinView.pinTintColor = [MKPinAnnotationView purplePinColor];
        //动画下落
        pinView.animatesDrop = YES;
        //对于大头针的视图没有效果
        pinView.image = [UIImage imageNamed:@"shop"];
        //允许弹出泡泡的视图
        pinView.canShowCallout = YES;
        //允许大头针被长按拖动到其他位置
        pinView.draggable = YES;
        return pinView;
    }else if([annotation isKindOfClass:[MyAnnotation class]]){
        //数据(Model)对象转换回来
        MyAnnotation *myAnno = (MyAnnotation *)annotation;
        static NSString *myReuseId = @"my-id";
        //视图(View)
        MKAnnotationView *anView = [mapView dequeueReusableAnnotationViewWithIdentifier:myReuseId];
        if (!anView) {
            //创建也可以自己写一个MKAnnotationView的子类
            anView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myReuseId];
        }
        anView.image = [UIImage imageNamed:@"shop"];
        anView.canShowCallout = YES;
        anView.draggable = YES;
        //可以修改弹出的气泡的样式
        UIImage *img = [UIImage imageNamed:myAnno.type];
        //左边的视图（一般是logo图片）
        anView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:img];
        //anView.leftCalloutAccessoryView.frame = CGRectMake(0, 0, 100, 100);
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        rightLab.text = myAnno.phoneNumber;
        //右边视图（一般是方形的按钮）
//        anView.rightCalloutAccessoryView = rightLab;
        //详情的视图 (一般是详情的label)
        anView.detailCalloutAccessoryView = rightLab;
        return anView;
    }
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    //一定要判断类型，因为后续可能有更多的覆盖物
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineView = [[MKPolylineView alloc] initWithOverlay:overlay];
        lineView.lineWidth = 30;
        lineView.strokeColor = [UIColor redColor];
        UIBezierPath *bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 1000, 1000)];
        lineView.path = bezier.CGPath;
        return lineView;
    }

    return nil;
}

@end
