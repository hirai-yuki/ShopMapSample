//
//  CLMMapViewController.h
//  ShopMapSample
//
//  Created by hirai.yuki on 2015/10/28.
//  Copyright © 2015年 Yuki  Hirai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CLMMapViewController;

@protocol CLMMapViewControllerDelegate <NSObject>

@required
- (void)mapViewController:(CLMMapViewController *)mapViewController didFetchRoute:(MKRoute *)route;

@end

@interface CLMMapViewController : UIViewController

@property (nonatomic) NSArray *shops;
@property (weak, nonatomic) id<CLMMapViewControllerDelegate> delegate;

- (void)moveMapCameraTo:(MKRouteStep *)step;
- (void)reloadData;

@end
