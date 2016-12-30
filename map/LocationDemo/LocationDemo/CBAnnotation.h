//
//  CBAnnotation.h
//  LocationDemo
//
//  Created by 常彪 on 16/4/12.
//  Copyright © 2016年 0xcb. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CBAnnotation : MKShape
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end
