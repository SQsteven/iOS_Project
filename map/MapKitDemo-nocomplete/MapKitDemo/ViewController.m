//
//  ViewController.m
//  MapKitDemo
//
//  Created by 常彪 on 16/1/4.
//  Copyright © 2016年 0xcb. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>


@interface ViewController ()
{
    //实例变量，成员变量
    MKMapView *_mapView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CGRectInset生成一个新的的距离原来的rect边距dx, dy的rect
    _mapView = [[MKMapView alloc] initWithFrame:CGRectInset(self.view.bounds, 10, 10)];
    //地图类型,
    _mapView.mapType = MKMapTypeStandard;
    //卫星和普通地图混合图
    //_mapView.mapType = MKMapTypeHybrid;
    //卫星图
    //_mapView.mapType = MKMapTypeSatellite;
    [self.view addSubview:_mapView];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(34.72958621, 113.74592800);
//    [_mapView setCenterCoordinate:mapCenter animated:YES];
//    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(mapCenter, MKCoordinateSpanMake(10, 10));
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(mapCenter, 100, 100);
    [_mapView setRegion:mapRegion animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
