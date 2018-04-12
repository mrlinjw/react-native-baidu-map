//
//  RCTBaiduMapViewManager.h
//  RCTBaiduMap
//
//  Created by lovebing on Aug 6, 2016.
//  Copyright © 2016 lovebing.org. All rights reserved.
//

#ifndef RCTBaiduMapViewManager_h
#define RCTBaiduMapViewManager_h

#import "RCTBaiduMapView.h"
#import <BaiduMapAPI_Map/BMKTileLayer.h>
#import <BaiduMapAPI_Map/BMKTileLayerView.h>

static NSMutableArray* _Annotations;


@interface RCTBaiduMapViewManager : RCTViewManager<BMKMapViewDelegate>


@property (strong) NSString *flag;
+(void)initSDK:(NSString *)key;

-(void)sendEvent:(RCTBaiduMapView *) mapView params:(NSDictionary *) params;

-(void)addPointJuheWithCoorArray: (BMKMapView *)mapView ans: (NSMutableArray *)ans;

-(void)setReceiveAnnotations: (NSMutableArray *) ans;

@end

#endif /* RCTBaiduMapViewManager_h */
