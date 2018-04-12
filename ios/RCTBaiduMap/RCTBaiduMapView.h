//
//  RCTBaiduMap.h
//  RCTBaiduMap
//
//  Created by lovebing on 4/17/2016.
//  Copyright © 2016 lovebing.org. All rights reserved.
//

#ifndef RCTBaiduMapView_h
#define RCTBaiduMapView_h


#import "RCTViewManager.h"
#import "RCTConvert+CoreLocation.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKTileLayer.h>
#import <UIKit/UIKit.h>

#import "HandDrawnTileLayer.h"

@interface RCTBaiduMapView : BMKMapView <BMKMapViewDelegate>

@property (nonatomic, copy) RCTBubblingEventBlock onChange;

-(void)setZoom:(float)zoom;
-(void)setCenterLatLng:(NSDictionary *)LatLngObj;
-(void)setMarker:(NSDictionary *)Options;
-(void)setUrlTiles:(NSArray *)urlTiles;
-(void)updateClusters;
-(void)setIconType:(int)iconType;


@end

#endif
