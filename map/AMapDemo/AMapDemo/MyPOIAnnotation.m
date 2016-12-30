//
//  MyPOIAnnotation.m
//  AMapDemo
//
//  Created by 常彪 on 16/1/6.
//  Copyright © 2016年 0xcb. All rights reserved.
//

#import "MyPOIAnnotation.h"

@implementation MyPOIAnnotation

+ (id)annotationWithAMapPOI:(AMapPOI *)poi
{
    MyPOIAnnotation *anno = [[MyPOIAnnotation alloc] init];
    //坐标经纬度
    CLLocationCoordinate2D coor;
    coor.latitude = poi.location.latitude;
    coor.longitude = poi.location.longitude;
    anno.coordinate = coor;
    //标题
    anno.title = poi.name;
    //子标题
    anno.subtitle = poi.address;
    return anno;
}


@end








