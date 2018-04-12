//
//  HandDrawnTileLayer.m
//  RCTBaiduMap
//
//  Created by alwayalive on 2018/4/8.
//  Copyright © 2018年 lovebing.org. All rights reserved.
//

#import "HandDrawnTileLayer.h"

@implementation HandDrawnTileLayer

- (UIImage *)tileForX:(NSInteger)x y:(NSInteger)y zoom:(NSInteger)zoom{
    NSString *coordStr = [[XYCoordinate tileBounds:x ty:y zoom:zoom] stringByAppendingString:@"&WIDTH=256&HEIGHT=256"];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+\\.\\d+,)+\\d+\\.\\d+\\&width=\\d+\\&height=\\d+" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self.URLTemplate options:0 range:NSMakeRange(0, [self.URLTemplate length]) withTemplate:coordStr];
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:modifiedString]]];
}

@end
