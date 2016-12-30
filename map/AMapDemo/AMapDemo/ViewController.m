//
//  ViewController.m
//  AMapDemo
//
//  Created by 常彪 on 16/1/6.
//  Copyright © 2016年 0xcb. All rights reserved.
//



#import "ViewController.h"
//高德2d地图
#import <MAMapKit/MAMapKit.h>
//高德搜索api
#import <AMapSearchKit/AMapSearchKit.h>
//自定义的标注
#import "MyPOIAnnotation.h"

@interface ViewController () <AMapSearchDelegate>
{
    //地图的视图
    MAMapView *_mapView;
    //地图搜索api
    AMapSearchAPI *_searchApi;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    //版权logo的位置
    //_mapView.logoCenter = CGPointMake(100, 100);
    _mapView.zoomLevel = 10;
    //显示用户位置,需要获取授权
    //需要在Info.plist里面加NSLocationAlwaysUsageDescription字段
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    //高德搜索
    _searchApi = [[AMapSearchAPI alloc] init];
    _searchApi.delegate = self;
    
    //构造POI的'关键词'请求
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = @"店";
    request.city = @"深圳";
    //请求更多的信息
    request.requireExtension = YES;
    //发起请求
    [_searchApi AMapPOIKeywordsSearch:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 地图搜索的回调

//当请求发生错误时，会调用代理的此方法.
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

//POI查询回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSLog(@"POI请求成功");
    //AMapPOI
    if (response.count) {
        NSMutableArray *allPoiArr = [NSMutableArray array];
        
        for (AMapPOI *poi in response.pois) {
            MyPOIAnnotation *anno = [MyPOIAnnotation annotationWithAMapPOI:poi];
            [_mapView addAnnotation:anno];
            [allPoiArr addObject:anno];
        }
        
        [_mapView showAnnotations:allPoiArr animated:YES];
    }else{
        
    }
}





@end
