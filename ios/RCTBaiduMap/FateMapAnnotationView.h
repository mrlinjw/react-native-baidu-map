//
//  FateMapAnnotationView.h
//  moyou
//
//  Created by 幻想无极（谭启宏） on 16/7/6.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

//#import <BaiduMapAPI_Map/BaiduMapAPI_Map.h>

//#import "FateModel.h"
#import "BMKClusterItem.h"
/*
 *自定义地图里面的标注
 *点聚合AnnotationView
 */
@interface FateMapAnnotationView : BMKAnnotationView


///所包含annotation个数
@property (nonatomic, assign) NSInteger size;
//@property (nonatomic, copy)NSString *imagUrlString;
@property (nonatomic,strong)BMKCluster *cluster;

@end

/*
 *点聚合Annotation
 */
@interface FateMapAnnotation : BMKPointAnnotation


///所包含annotation个数
@property (nonatomic, assign) NSInteger size;
//@property (nonatomic, copy)NSString *imagUrlString;
@property (nonatomic,strong)BMKCluster *cluster;

@end