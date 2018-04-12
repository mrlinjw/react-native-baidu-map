//
//  RCTBaiduMap.m
//  RCTBaiduMap
//
//  Created by lovebing on 4/17/2016.
//  Copyright © 2016 lovebing.org. All rights reserved.
//

#import "RCTBaiduMapView.h"
#import "RCTBaiduMapViewManager.h"

@implementation RCTBaiduMapView {
    BMKMapView* _mapView;
    BMKPointAnnotation* _annotation;
    NSMutableArray* _annotations;
    NSMutableArray* _urlTiles;
}

-(void)setIconType:(int)iconType {
    self.tag = iconType;
}

-(void)setZoom:(float)zoom {
    self.zoomLevel = zoom;
}

-(void)setCenterLatLng:(NSDictionary *)LatLngObj {
    double lat = [RCTConvert double:LatLngObj[@"lat"]];
    double lng = [RCTConvert double:LatLngObj[@"lng"]];
    CLLocationCoordinate2D point = CLLocationCoordinate2DMake(lat, lng);
    self.centerCoordinate = point;
}

-(void)setUrlTiles:(NSArray *)urlTiles{
    _urlTiles = [[NSMutableArray alloc] init];
    NSMutableArray *tileOverlays = [NSMutableArray array];
    [urlTiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        1、根据URL模版（即指向相关图层图片的URL）创建BMKURLTileLayer对象。
        BMKURLTileLayer *tileLayer = [[BMKURLTileLayer alloc] initWithURLTemplate:obj];
//        tileLayer.URLTemplate = obj;
//        2、设置BMKURLTileLayer的可见最大/最小Zoom值。
        tileLayer.minZoom = 0;
        tileLayer.maxZoom = 20;
//        3、设定BMKURLTileLayer的可渲染区域。
        tileLayer.visibleMapRect = BMKMapRectMake(32994258, 35853667, 3122, 5541);
//        4、将BMKURLTileLayer对象添加到BMKMapView中
        [tileOverlays addObject:tileLayer];
    }];
    [self addOverlays:[NSArray arrayWithArray:tileOverlays]];
    
}
//- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
//    if ([overlay isKindOfClass:[BMKTileLayer class]]) {
//        BMKTileLayerView *view = [[BMKTileLayerView alloc] initWithTileLayer:overlay];
//        return view;
//    }
//    return nil;
//}
-(void)setMarker:(NSDictionary *)option {
    NSLog(@"setMarker");
    if(option != nil) {
        if(_annotation == nil) {
            _annotation = [[BMKPointAnnotation alloc]init];
            [self addMarker:_annotation option:option];
        }
        else {
            [self updateMarker:_annotation option:option];
        }
    }
}

-(void)setMarkers:(NSArray *)markers {
    int markersCount = [markers count];
//    if(_annotations == nil) {
        _annotations = [[NSMutableArray alloc] init];
//    }
    
    //删除旧点
//    int oldCount = [_annotations count];
//    if(oldCount >0 ){
//        int start = oldCount -1;
//        for (int i = start; i >= oldCount; i--) {
//            BMKPointAnnotation *annotation = [_annotations objectAtIndex:i];
//            [self removeAnnotation:annotation];
//            [_annotations removeObject:annotation];
//        }
//    }
    
    if(markers != nil) {
        for (int i = 0; i < markersCount; i++)  {
            NSDictionary *option = [markers objectAtIndex:i];
            
            BMKPointAnnotation *annotation = nil;
            if(i < [_annotations count]) {
                annotation = [_annotations objectAtIndex:i];
            }
            if(annotation == nil) {
                annotation = [[BMKPointAnnotation alloc]init];
                [self addMarker:annotation option:option];
                [_annotations addObject:annotation];
            }
            else {
                [self updateMarker:annotation option:option];
            }
        }
        
        int _annotationsCount = [_annotations count];
        
        NSString *smarkersCount = [NSString stringWithFormat:@"%d", markersCount];
        NSString *sannotationsCount = [NSString stringWithFormat:@"%d", _annotationsCount];
        NSLog(smarkersCount);
        NSLog(sannotationsCount);
        
        if(markersCount < _annotationsCount) {
            int start = _annotationsCount - 1;
            for(int i = start; i >= markersCount; i--) {
                BMKPointAnnotation *annotation = [_annotations objectAtIndex:i];
                [self removeAnnotation:annotation];
                [_annotations removeObject:annotation];
            }
        }
    }
    RCTBaiduMapViewManager * ma = [RCTBaiduMapViewManager new];
    [ma setReceiveAnnotations: _annotations];
    [ma addPointJuheWithCoorArray: self ans: _annotations];
}

-(CLLocationCoordinate2D)getCoorFromMarkerOption:(NSDictionary *)option {
    double lat = [RCTConvert double:option[@"latitude"]];
    double lng = [RCTConvert double:option[@"longitude"]];
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    return coor;
}

-(void)addMarker:(BMKPointAnnotation *)annotation option:(NSDictionary *)option {
    [self updateMarker:annotation option:option];
//    [self addAnnotation:annotation];
}

-(void)updateMarker:(BMKPointAnnotation *)annotation option:(NSDictionary *)option {
    CLLocationCoordinate2D coor = [self getCoorFromMarkerOption:option];
    
    
    id v = [option valueForKey:@"itemId"];
    NSString *itemId =  @"";
    if([v isKindOfClass:[NSNumber class]]){
        itemId = [NSString stringWithFormat:@"%@",v];
    }else if([v isKindOfClass:[NSString class]]){
        itemId = v;
    }
    
    NSString *title = [RCTConvert NSString:option[@"title"]];
    if(title.length == 0) {
        title = nil;
    }
    annotation.coordinate = coor;
    annotation.title = title;
    annotation.accessibilityLabel = itemId;
}


@end
