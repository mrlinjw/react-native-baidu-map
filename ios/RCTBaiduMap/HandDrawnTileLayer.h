//
//  HandDrawnTileLayer.h
//  RCTBaiduMap
//
//  Created by alwayalive on 2018/4/8.
//  Copyright © 2018年 lovebing.org. All rights reserved.
//
#import <BaiduMapAPI_Map/BMKTileLayer.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "XYCoordinate.h"
@interface HandDrawnTileLayer : BMKSyncTileLayer

@property NSString *URLTemplate;

@end
