//
//  ViewController.m
//  Location
//
//  Created by 谢鑫 on 2019/8/7.
//  Copyright © 2019 Shae. All rights reserved.
//

#import "ViewController.h"
#import<MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface ViewController ()<MAMapViewDelegate>
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)AMapLocationManager *locationManage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //实例化MAMapView对象
     _mapView=[[MAMapView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    //设置代理
    _mapView.delegate=self;
    //设置地图类型
    _mapView.mapType=MAMapTypeStandard;
    //定位以后改变地图的图层显示
    //[_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    //添加大头针
    //[self addPin];
    //添加到控制器的view上
    [self.view addSubview:_mapView];
    
    //定位
    [self requestLocation];
     
}
/*      大头针                        */
-(void)addPin{
    //添加大头针
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(32.03522, 118.74237);
    pointAnnotation.title = @"侵华日军南京大屠杀遇难同胞纪念馆";
    pointAnnotation.subtitle = @"水西门大街418号";
    [self.mapView addAnnotation:pointAnnotation];
    self.mapView.centerCoordinate = pointAnnotation.coordinate;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
/*         定位                        */
- (AMapLocationManager *)locationManage{
    if (_locationManage==nil) {
        _locationManage=[[AMapLocationManager alloc]init];
        //带逆地图信息的一次定位（返回坐标和地址信息）
        [_locationManage setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //定位超时时间，最低2s，此处设置为2s
        _locationManage.locationTimeout=2;
        //逆地图请求超时时间，最低2s，此处设置为2秒
        _locationManage.reGeocodeTimeout=2;
    }
    return _locationManage;
}
-(void)requestLocation{
    //带逆地理（返回坐标和地址信息）。将下面代码中的YES改成NO,则不会返回地址信息
    [self.locationManage requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};",(long)error.code,error.localizedDescription);
            if (error.code==AMapLocationErrorLocateFailed) {
                return ;
            }
        }
        NSLog(@"location:%@",location);
        
        if (regeocode) {
            NSLog(@"regeocode:%@",regeocode);
        }
    }];
}
@end
