//
//  HeatMapTileOverlayViewController.m
//  DevDemo2D
//
//  Created by 翁乐 on 15/5/12.
//  Copyright (c) 2015年 xiaoming han. All rights reserved.
//

#import "HeatMapTileOverlayViewController.h"

#import <MAMapKit/MAHeatMapTileOverlay.h>


@interface HeatMapTileOverlayViewController()

@property (nonatomic,strong) MAHeatMapTileOverlay *heatMapTileOverlay;

@property UIView *controls;

@end

@implementation HeatMapTileOverlayViewController


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayRenderer *tileOverlayRenderer = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];
        
        return tileOverlayRenderer;
    }
    
    return nil;
}


- (void)opacityAction:(UISlider *)slider
{
    [self.heatMapTileOverlay setOpacity:slider.value];
    MATileOverlayRenderer *renderer = (MATileOverlayRenderer *)[self.mapView rendererForOverlay:self.heatMapTileOverlay];
    [renderer reloadData];
}

- (void)radiusAction:(UISlider *)slider
{
    [self.heatMapTileOverlay setRadius:slider.value *100];
    MATileOverlayRenderer *renderer = (MATileOverlayRenderer *)[self.mapView rendererForOverlay:self.heatMapTileOverlay];
    [renderer reloadData];
}

- (void)gradientAction:(UISegmentedControl *)segmentControl
{
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
        {
            [self.heatMapTileOverlay
             setGradient:[[MAHeatMapGradient alloc] initWithColor:@[[UIColor blueColor], [UIColor greenColor],[UIColor redColor]] andWithStartPoints:@[@(0.2), @(0.5),@(0.9)]]];
            break;
        }
        case 1:
        {
            [self.heatMapTileOverlay
             setGradient:[[MAHeatMapGradient alloc] initWithColor:@[[UIColor redColor], [UIColor blueColor],[UIColor greenColor]] andWithStartPoints:@[@(0.4), @(0.6), @(0.8)]]];
            break;
        }
        case 2:
        {
            [self.heatMapTileOverlay
        setGradient:[[MAHeatMapGradient alloc] initWithColor:@[[UIColor grayColor],[UIColor brownColor], [UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor redColor]] andWithStartPoints:@[@(0.1),@(0.3),@(0.5), @(0.6), @(0.8),@(0.9)]]];
            break;
        }
            
        default:
            break;
    }
    
    MATileOverlayRenderer *renderer = (MATileOverlayRenderer *)[self.mapView rendererForOverlay:self.heatMapTileOverlay];
    [renderer reloadData];
}

- (void)initToolBar
{
    
    float height = CGRectGetHeight(self.mapView.bounds);
    float width = CGRectGetWidth(self.view.bounds);
    
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    
    ///gradient
    UISegmentedControl *gradientTypeSegMentControl = [[UISegmentedControl alloc] initWithItems:
                                                      [NSArray arrayWithObjects:
                                                       @"蓝绿红",
                                                       @"红蓝绿",
                                                       @"灰棕蓝绿黄红",
                                                       nil]];
    gradientTypeSegMentControl.selectedSegmentIndex = 0;
    gradientTypeSegMentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [gradientTypeSegMentControl addTarget:self action:@selector(gradientAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *mayTypeItem = [[UIBarButtonItem alloc] initWithCustomView:gradientTypeSegMentControl];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, mayTypeItem, flexbleItem, nil];
    
    
    ///control
    self.controls = [[UIView alloc] initWithFrame:CGRectMake(20, height - 160 , width - 40, 110)];
    self.controls.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin ;
    
    self.controls.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    
    
    ///opacity
    UISlider *opacity = [[UISlider alloc] initWithFrame:CGRectMake(85,5 , width - 40 - 70 -30, 50)];
    opacity.value = 0.6f;
    
    UILabel *laOpacity = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 40)];
    [laOpacity setText:@"透明度："];
    
    ///radius
    UISlider *radius = [[UISlider alloc] initWithFrame:CGRectMake(85,55 , width - 40 - 70 -30, 50)];
    radius.value = 0.12f;
    
    UILabel *laRadius = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 70, 40)];
    [laRadius setText:@"半径："];
    
    
    [opacity addTarget:self action:@selector(opacityAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [radius addTarget:self action:@selector(radiusAction:) forControlEvents:UIControlEventTouchUpInside| UIControlEventTouchUpOutside];

    
    [self.controls addSubview:opacity];
    [self.controls addSubview:laOpacity];
    [self.controls addSubview:radius];
    [self.controls addSubview:laRadius];
    
    [self.view addSubview:self.controls];
}


- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.heatMapTileOverlay = [[MAHeatMapTileOverlay alloc] init];
    
    NSMutableArray* data = [NSMutableArray array];
    
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"heatMapData" ofType:@"json"]];
    
    @autoreleasepool {
        
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            
            for (NSDictionary *dic in dicArray)
            {
                MAHeatMapNode *node = [[MAHeatMapNode alloc] init];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [dic[@"lat"] doubleValue];
                coordinate.longitude = [dic[@"lng"] doubleValue];
                node.coordinate = coordinate;
                
                node.intensity = [dic[@"count"] doubleValue];
                [data addObject:node];
            }
        }
    }
    
    self.heatMapTileOverlay.data = data;
    [self.mapView addOverlay:self.heatMapTileOverlay];
}

@end
