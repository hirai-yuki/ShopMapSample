//
//  CLMShopAnnotation.m
//  ShopMapSample
//
//  Created by hirai.yuki on 2015/10/28.
//  Copyright © 2015年 Yuki  Hirai. All rights reserved.
//

#import "CLMShopAnnotation.h"

@implementation CLMShopAnnotation

- (nonnull instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title image:(UIImage *)image {
    self = [super init];
    
    if (self) {
        _coordinate = coordinate;
        _title = title;
        _image = image;
    }
    
    return self;
}

@end
