//
//  CLMShopAnnotation.h
//  ShopMapSample
//
//  Created by hirai.yuki on 2015/10/28.
//  Copyright © 2015年 Yuki  Hirai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CLMShopAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, nullable) UIImage *image;

- (nonnull instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                                     title:(nullable NSString *)title
                                     image:(nullable UIImage *)image;

@end
