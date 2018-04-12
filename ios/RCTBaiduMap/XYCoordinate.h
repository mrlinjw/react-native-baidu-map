//
//  XYCoordinate.h
//  RCTBaiduMap
//
//  Created by alwayalive on 2018/4/8.
//  Copyright © 2018年 lovebing.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface XYCoordinate : NSObject

+(NSString *)tileBounds:(double)tx ty:(double)ty zoom:(double)zoom;
+(double)pixels2Meters:(double)p zoom:(double)zoom;
+(double)resolution:(double)zoom;
+(double)meters2Lon:(double)my;
+(double)meters2Lat:(double)my;
+(double)lon2Meter:(double)lon;
+(double)lat2Meter:(double)lat;
@end
