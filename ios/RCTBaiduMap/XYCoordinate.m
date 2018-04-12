//
//  XYCoordinate.m
//  RCTBaiduMap
//
//  Created by alwayalive on 2018/4/8.
//  Copyright © 2018年 lovebing.org. All rights reserved.
//

#import "XYCoordinate.h"

@implementation XYCoordinate

double tileSize = 256;
double initialresolution = 156543.03392804062;
double originShift = 20037508.342789244;

+(double)pixels2Meters:(double)p zoom:(double)zoom{
    return p * [self resolution:zoom] - originShift;
}

/**
 计算分辨率
 
 @param zoom
 @return
 */
+(double)resolution:(double)zoom{
    return initialresolution / pow(2, zoom);
}

/**
 X米转经纬度
 
 @param mx
 @return
 */
+(double)meters2Lon:(double)my{
    return (my / originShift ) * 180.0;
}


/**
 Y米转经纬度
 
 @param my
 @return
 */
+(double)meters2Lat:(double)my{
    double lat = ( my / originShift ) * 180.0;
    return 180.0 / M_PI * ( 2 * atan(exp(lat * M_PI / 180.0)) - M_PI / 2.0);
}


/**
 X经纬度转米
 
 @param lon
 @return
 */
+(double)lon2Meter:(double)lon{
    return lon * originShift / 180.0;
}

/**
 Y经纬度转米
 
 @param lat
 @return
 */
+(double)lat2Meter:(double)lat{
    double my = log(tan((90 + lat) * M_PI / 360.0)) / (M_PI / 180.0);
    my = my * originShift / 180.0;
    return my;
}

+(NSString *)tileBounds:(double)tx ty:(double)ty zoom:(double)zoom{
    double minX = [self pixels2Meters:tx * tileSize zoom:zoom];
    double maxY = -[self pixels2Meters:ty * tileSize zoom:zoom];
    double maxX = [self pixels2Meters:(tx + 1) * tileSize zoom:zoom];
    double minY = -[self pixels2Meters:(ty + 1) * tileSize zoom:zoom];
    minX = [self meters2Lon:minX];
    minY = [self meters2Lat:minY];
    maxX = [self meters2Lon:maxX];
    maxY = [self meters2Lat:maxY];
    
    NSDictionary *minCoordDic = BMKConvertBaiduCoorFrom(CLLocationCoordinate2DMake(minX, minY),BMK_COORDTYPE_GPS);
    NSDictionary *maxCoordDic = BMKConvertBaiduCoorFrom(CLLocationCoordinate2DMake(maxX, maxY),BMK_COORDTYPE_GPS);

    NSArray *arr = [NSArray arrayWithObjects:[minCoordDic objectForKey:@"x"], [minCoordDic objectForKey:@"y"], [maxCoordDic objectForKey:@"x"], [maxCoordDic objectForKey:@"x"], nil];
    return [[arr componentsJoinedByString:@","] stringByAppendingString:@""];
}

@end
