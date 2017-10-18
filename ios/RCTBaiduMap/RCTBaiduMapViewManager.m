//
//  RCTBaiduMapViewManager.m
//  RCTBaiduMap
//
//  Created by lovebing on Aug 6, 2016.
//  Copyright © 2016 lovebing.org. All rights reserved.
//

#import "RCTBaiduMapViewManager.h"
#import "Cluster/BMKClusterManager.h"

/*
 *点聚合Annotation
 */
@interface ClusterAnnotation : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, assign) NSInteger size;
@property (nonatomic,strong)BMKCluster *cluster;

@end

@implementation ClusterAnnotation

@synthesize size = _size;

@end


/*
 *点聚合AnnotationView
 */
@interface ClusterAnnotationView : BMKPinAnnotationView {
    
}

@property (nonatomic, assign) NSInteger iconType;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ClusterAnnotationView

@synthesize iconType = _iconType;
@synthesize size = _size;
@synthesize label = _label;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        _label.layer.borderColor = [UIColor whiteColor].CGColor;
        _label.layer.borderWidth = 2;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor redColor];
        _label.layer.cornerRadius = 15;
        _label.clipsToBounds = YES;
        [self addSubview:_label];
        self.alpha = 0.85;
    }
    return self;
}

- (void)setIconType:(NSInteger)iconType {
    _iconType = iconType;
}

- (void)setSize:(NSInteger)size {
    _size = size;
//    self.pinColor = BMKPinAnnotationColorPurple;
    NSString* iconImg = @"icon_qita.png";
    if( self.iconType == 1){
        iconImg = @"icon_diaodian.png";
    }
    else if( self.iconType == 3 ){
        iconImg = @"icon_luying.png";
    }
    else if( self.iconType == 4 ){
        iconImg = @"icon_jingdian.png";
    }
    else if( self.iconType == 6 ){
        iconImg = @"icon_cangting.png";
    }
    else if( self.iconType == 7 ){
        iconImg = @"icon_lvguan.png";
    }
    else if( self.iconType == 8 ){
        iconImg = @"icon_chuangjia.png";
    }
    else if( self.iconType == 13 ){
        iconImg = @"icon_yujudian.png";
    }
    else if( self.iconType == 18 ){
        iconImg = @"icon_qianshui.png";
    }
    if (_size == 1) {
        self.label.hidden = YES;
        self.image = [UIImage imageNamed:iconImg];
    }else{
        self.label.hidden = NO;
//    if (size > 20) {
//        self.label.backgroundColor = [UIColor redColor];
//    } else if (size > 10) {
//        self.label.backgroundColor = [UIColor purpleColor];
//    } else if (size > 5) {
//        self.label.backgroundColor = [UIColor blueColor];
//    } else {
//        self.label.backgroundColor = [UIColor greenColor];
//    }
        _label.text = [NSString stringWithFormat:@"%ld", size];
    }
}

@end

@implementation RCTBaiduMapViewManager{
    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
//    NSMutableArray* _annotations;
    NSInteger _zoomLevel; //原聚合级别
    BOOL cluster; //判断是否存在多点聚合
};


RCT_EXPORT_MODULE(RCTBaiduMapView)

RCT_EXPORT_VIEW_PROPERTY(iconType, int)
RCT_EXPORT_VIEW_PROPERTY(mapType, int)
RCT_EXPORT_VIEW_PROPERTY(zoom, float)
RCT_EXPORT_VIEW_PROPERTY(trafficEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(baiduHeatMapEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(marker, NSDictionary*)
RCT_EXPORT_VIEW_PROPERTY(markers, NSArray*)

RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(center, CLLocationCoordinate2D, RCTBaiduMapView) {
    [view setCenterCoordinate:json ? [RCTConvert CLLocationCoordinate2D:json] : defaultView.centerCoordinate];
}


+(void)initSDK:(NSString*)key {
    
    BMKMapManager* _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:key  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (UIView *)view {
    RCTBaiduMapView* mapView = [[RCTBaiduMapView alloc] init];
    mapView.delegate = self;
    return mapView;
}

-(void)mapview:(BMKMapView *)mapView
 onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"onDoubleClick");
    NSDictionary* event = @{
                            @"type": @"onMapDoubleClick",
                            @"params": @{
                                    @"latitude": @(coordinate.latitude),
                                    @"longitude": @(coordinate.longitude)
                                    }
                            };
    [self sendEvent:mapView params:event];
}

-(void)mapView:(BMKMapView *)mapView
onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"onClickedMapBlank");
    NSDictionary* event = @{
                            @"type": @"onMapClick",
                            @"params": @{
                                    @"latitude": @(coordinate.latitude),
                                    @"longitude": @(coordinate.longitude)
                                    }
                            };
    [self sendEvent:mapView params:event];
}

//-(void) mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    NSDictionary* event = @{
//                            @"type": @"onDidAddAnnotation",
//                            @"params": @{}
//                            };
//    [self sendEvent:mapView params:event];
//}

-(void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    NSDictionary* event = @{
                            @"type": @"onMapLoaded",
                            @"params": @{}
                            };
    [self sendEvent:mapView params:event];
}

-(void)mapView:(BMKMapView *)mapView
didSelectAnnotationView:(BMKAnnotationView *)view {
    NSArray *clusters =  ((ClusterAnnotation *)[view annotation]).cluster.clusterItems;
    NSInteger count = [clusters count];
    NSString *itemId = @"";
    NSMutableArray *items = [NSMutableArray new];
    BOOL clusterPoint = YES;
    if(count == 1){
        clusterPoint = NO;
        itemId = ((ClusterAnnotation *)[view annotation]).cluster.itemId;
    }
    for(BMKClusterItem * c in clusters ){
        NSObject *a = @{
                        @"itemId": c.itemId,
                        @"title": c.title,
                        @"latitude": @(c.coor.latitude),
                        @"longitude": @(c.coor.longitude)
                    };
        [items addObject:a];
    }
    NSDictionary* event = @{
                            @"type": @"onMarkerClick",
                            @"params": @{
                                    @"cluster":  [NSNumber numberWithBool:clusterPoint],
                                    @"itemId": itemId,
                                    @"title": [[view annotation] title],
                                    @"latitude": @([[view annotation] coordinate].latitude),
                                    @"longitude": @([[view annotation] coordinate].longitude),
                                    @"items":items
                                }
                            };
    [self sendEvent:mapView params:event];
}

- (void) mapView:(BMKMapView *)mapView
 onClickedMapPoi:(BMKMapPoi *)mapPoi {
    NSLog(@"onClickedMapPoi");
    NSDictionary* event = @{
                            @"type": @"onMapPoiClick",
                            @"params": @{
                                    @"name": mapPoi.text,
                                    @"uid": mapPoi.uid,
                                    @"latitude": @(mapPoi.pt.latitude),
                                    @"longitude": @(mapPoi.pt.longitude)
                                    }
                            };
    [self sendEvent:mapView params:event];
}

//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
//        newAnnotationView.animatesDrop = YES;
//        return newAnnotationView;
//    }
//    return nil;
//}

-(void)mapStatusDidChanged: (BMKMapView *)mapView	 {
    NSLog(@"mapStatusDidChanged");
    CLLocationCoordinate2D targetGeoPt = [mapView getMapStatus].targetGeoPt;
    NSDictionary* event = @{
                            @"type": @"onMapStatusChange",
                            @"params": @{
                                    @"target": @{
                                            @"latitude": @(targetGeoPt.latitude),
                                            @"longitude": @(targetGeoPt.longitude)
                                            },
                                    @"zoom": @"",
                                    @"overlook": @""
                                    }
                            };
    [self sendEvent:mapView params:event];
}

//拖动结束后返回中心坐标
- (void) mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"regionDidChangeAnimated");
    CLLocationCoordinate2D targetGeoPt = [mapView getMapStatus].targetGeoPt;
    NSDictionary* event = @{
                            @"type": @"onMapStatusChangeFinish",
                            @"params": @{
                                    @"target": @{
                                            @"latitude": @(targetGeoPt.latitude),
                                            @"longitude": @(targetGeoPt.longitude)
                                            },
                                    @"zoom": @(mapView.zoomLevel),
                                    @"overlook": @""
                                    }
                            };
    [self sendEvent:mapView params:event];
}


//监听地图状态，缩放时重绘标志
- (void) mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status {
    
    
    NSInteger zooml = (NSInteger)mapView.zoomLevel;
    if(!_zoomLevel){
        _zoomLevel = zooml;
    }
    else{
        if(_zoomLevel != zooml){
            _zoomLevel = zooml;
            NSLog(@"%@", [NSString stringWithFormat:@"%ld级别", zooml]);
//            [self addPointJuheWithCoorArray:mapView ans:_Annotations ];
        }
    }
}

-(void)setReceiveAnnotations: (NSMutableArray *) ans{
//    _annotations = [NSMutableArray arrayWithArray: ans];
    _Annotations = ans;
}

//添加模型数组
- (void)addPointJuheWithCoorArray: (BMKMapView *)mapView
                              ans: (NSMutableArray *)ans{
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i < 22; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    //点聚合管理类
    _clusterManager = [[BMKClusterManager alloc] init];
    //向点聚合管理类中添加标注
//    if(!_annotations){
//        _annotations = [NSMutableArray arrayWithArray: mapView.annotations];
//    }
    long int count = [ans count];
    for (NSInteger i = 0; i < count; i++) {
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        BMKPointAnnotation *a = [ans objectAtIndex:i];
        clusterItem.coor = a.coordinate;
        clusterItem.title = a.title;
        clusterItem.accessibilityLabel = a.accessibilityLabel;
        clusterItem.itemId = a.accessibilityLabel;
        [_clusterManager addClusterItem:clusterItem];
    };
    [self updateClusters:mapView];
}

//更新聚合状态
- (void)updateClusters: (BMKMapView *)mapView {
    _clusterZoom = (NSInteger)mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:( _clusterZoom - 3)];
        
        if (clusters.count > 0) {
            [mapView removeAnnotations:mapView.annotations];
            [mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                ///获取聚合后的标注
                __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL clusterPoint = NO;
                    for (BMKCluster *item in array) {
                        ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        annotation.cluster = item;
                        annotation.accessibilityLabel = item.itemId;
                        if(item.size>1){
                            cluster = YES;
                            clusterPoint = YES;
                            annotation.title = [NSString stringWithFormat:@"%ld", item.size];
                        }else{
                            annotation.title = item.title;
                        }
                        [clusters addObject:annotation];
                    }
                    [mapView removeAnnotations:mapView.annotations];
                    [mapView addAnnotations:clusters];
                    
                    NSDictionary* event = @{
                                            @"type": @"onIosDidAddAnnotations",
                                            @"params": @{}
                                            };
                    [self sendEvent:mapView params:event];
                    
                });
            });
        }
    }
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[ClusterAnnotation class]]) {
        //普通annotation
        NSString *AnnotationViewID = @"ClusterMark";
        ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;
        ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.iconType = mapView.tag;
        annotationView.size = cluster.size;
        annotationView.draggable = YES;
        annotationView.annotation = cluster;
        annotationView.canShowCallout = NO; //隐藏气泡
        return annotationView;
    }
    return nil;
    
}


-(void)sendEvent:(RCTBaiduMapView *) mapView params:(NSDictionary *) params {
    if (!mapView.onChange) {
        return;
    }
    mapView.onChange(params);
}

@end
