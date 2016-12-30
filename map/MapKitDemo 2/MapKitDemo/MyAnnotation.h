//
//  MyAnnotation.h
//  MapKitDemo
//
//  Created by 常彪 on 16/1/5.
//  Copyright © 2016年 0xcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
//商户的手机号
@property (nonatomic, copy) NSString *phoneNumber;
//商户的类型
@property (nonatomic, copy) NSString *type;


@end



