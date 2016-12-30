//
//  ViewController.h
//  LocationDemo
//
//  Created by 常彪 on 16/4/12.
//  Copyright © 2016年 0xcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController
- (void)reverseCoordinate:(CLLocationCoordinate2D)coor complitionHandler:(void(^)(NSString *info))complition;

@end

