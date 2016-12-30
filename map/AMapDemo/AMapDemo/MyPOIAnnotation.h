//
//  MyPOIAnnotation.h
//  AMapDemo
//
//  Created by 常彪 on 16/1/6.
//  Copyright © 2016年 0xcb. All rights reserved.
//

#import <Foundation/Foundation.h>
//高德地图
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MyPOIAnnotation : NSObject <MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+ (id)annotationWithAMapPOI:(AMapPOI *)poi;

@end






