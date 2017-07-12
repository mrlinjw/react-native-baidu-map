//
//  FateMapAnnotationView.m
//  moyou
//
//  Created by 幻想无极（谭启宏） on 16/7/6.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "FateMapAnnotationView.h"

@interface FateMapAnnotationView ()

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *userImage;
@property (nonatomic,strong)UIButton *iconButton;
@end

@implementation FateMapAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self setBounds:CGRectMake(0.f, 0.f, 142.f/2, 154.f/2)];
        [self common];
        
    }
    return self;
}

- (void)common {
    self.imageView = [UIImageView new];
    self.userImage = [UIImageView new];
    self.iconButton = [UIButton new];
    self.imageView.frame = self.bounds;
    self.userImage.frame = CGRectMake(0, 0, 130/2, 130/2);
    self.iconButton.frame = CGRectMake(142/2-20, 0, 20, 20);
    self.iconButton.layer.cornerRadius = 10;
    self.iconButton.layer.masksToBounds = YES;
    self.iconButton.backgroundColor = [UIColor redColor];
    self.iconButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.iconButton setTitle:@"99" forState:UIControlStateNormal];
    self.userImage.center = CGPointMake(self.imageView.center.x, self.imageView.center.y-3);
    self.userImage.layer.cornerRadius = 130/4;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 1;
//    self.userImage.layer.borderColor = [MoyouColor colorWithLine].CGColor;
    self.imageView.image = [UIImage imageNamed:@"yuanfen_bt_ditutouxiang"];
    self.userImage.image = [UIImage imageNamed:@"yuanfen_icon_touxiang"];
    [self addSubview:self.imageView];
    [self addSubview:self.userImage];
    [self addSubview:self.iconButton];
}

- (void)setCluster:(BMKCluster *)cluster {
//     [self.userImage sd_setImageWithURL:[NSURL URLWithString:cluster.model.pic] placeholderImage:[UIImage imageNamed:@"yuanfen_icon_touxiang"]];
}

//- (void)setModel:(FateModel *)model {
//    _model = model;
//   
//}

//- (void)setImagUrlString:(NSString *)imagUrlString {
//    _imagUrlString = imagUrlString;
//    [self.userImage sd_setImageWithURL:[NSURL URLWithString:imagUrlString] placeholderImage:[UIImage imageNamed:@"yuanfen_icon_touxiang"]];
//    NSLog(@"-----");
//}

//mask覆盖图
//
//- (UIImage *)imageByComposingImage:(UIImage *)image withMaskImage:(UIImage *)maskImage {
//    CGImageRef maskImageRef = maskImage.CGImage;
//    CGImageRef maskRef = CGImageMaskCreate(CGImageGetWidth(maskImageRef),
//                                           CGImageGetHeight(maskImageRef),
//                                           CGImageGetBitsPerComponent(maskImageRef),
//                                           CGImageGetBitsPerPixel(maskImageRef),
//                                           CGImageGetBytesPerRow(maskImageRef),
//                                           CGImageGetDataProvider(maskImageRef), NULL, false);
//    
//    CGImageRef newImageRef = CGImageCreateWithMask(image.CGImage, maskRef);
//    CGImageRelease(maskRef);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    CGImageRelease(newImageRef);
//    
//    return newImage;
//}

- (void)setSize:(NSInteger)size {
     _size = size;
    if (_size > 1) {
        self.iconButton.hidden = NO;
        [self.iconButton setTitle:[NSString stringWithFormat:@"%ld",_size] forState:UIControlStateNormal];
    }else {
        self.iconButton.hidden = YES;
    }
}

@end

@implementation FateMapAnnotation


@end

