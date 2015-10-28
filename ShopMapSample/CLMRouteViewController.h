//
//  CLMRouteViewController.h
//  ShopMapSample
//
//  Created by hirai.yuki on 2015/10/28.
//  Copyright © 2015年 Yuki  Hirai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CLMRouteViewController;

@protocol CLMRouteViewControllerDelegate <NSObject>

@required
- (void)routeViewController:(CLMRouteViewController *)routeViewController didSelectStep:(MKRouteStep *)step;

@end

@interface CLMRouteViewController : UITableViewController

@property (nonatomic) MKRoute *route;
@property (weak, nonatomic) id<CLMRouteViewControllerDelegate> delegate;

@end
