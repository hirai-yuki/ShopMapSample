//
//  CLMMainViewController.m
//  ShopMapSample
//
//  Created by hirai.yuki on 2015/10/28.
//  Copyright © 2015年 Yuki  Hirai. All rights reserved.
//

#import "CLMMainViewController.h"
#import "CLMMapViewController.h"
#import "CLMRouteViewController.h"
#import "CLMShopAnnotation.h"
#import <MapKit/MapKit.h>

@interface CLMMainViewController () <MKMapViewDelegate, CLLocationManagerDelegate, CLMMapViewControllerDelegate, CLMRouteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *routeContainerViewHeightLayoutConstraint;
@property (nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) CLMMapViewController *mapViewController;
@property (weak, nonatomic) CLMRouteViewController *routeViewController;

@end

@implementation CLMMainViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    [self setRouteContainerViewHidden:YES animate:NO];
    
    self.mapViewController.shops = [self generateShopAnotations];
    [self.mapViewController reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mapView"]) {
        self.mapViewController = segue.destinationViewController;
        self.mapViewController.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"routeView"]) {
        self.routeViewController = segue.destinationViewController;
        self.routeViewController.delegate = self;
    }
}

#pragma mark - Private methods

- (void)setRouteContainerViewHidden:(BOOL)hidden animate:(BOOL)animate {
    if (hidden) {
        self.navigationItem.rightBarButtonItem = nil;
        self.routeContainerViewHeightLayoutConstraint.constant = 0.0;
    } else {
        UIBarButtonItem *hideRouteBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                                target:self
                                                                                                action:@selector(hideRouteBarButtonItemDidTapped:)];
        self.navigationItem.rightBarButtonItem = hideRouteBarButtonItem;
        self.routeContainerViewHeightLayoutConstraint.constant = 180.0;
    }
    
    NSTimeInterval duration = animate ? 0.2 : 0.0;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)hideRouteBarButtonItemDidTapped:(id)sender {
    [self setRouteContainerViewHidden:YES animate:YES];
    [self.mapViewController reloadData];
}

- (NSArray *)generateShopAnotations {
    MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(35.69725758651142, 139.77473706007004), 100, 100);
    return @[
             [[CLMShopAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(35.69725758651142, 139.77473706007004)
                                                     title:@"クラスメソッド本店"
                                                     image:[UIImage imageNamed:@"cm"]],
             [[CLMShopAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(35.6814920138883, 139.76665019989014)
                                                     title:@"クラスメソッド東京駅店"
                                                     image:[UIImage imageNamed:@"tokyo"]],
             [[CLMShopAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(35.658182, 139.702043)
                                                     title:@"クラスメソッド渋谷駅店"
                                                     image:[UIImage imageNamed:@"shibuya"]],
             [[CLMShopAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(35.729848, 139.711929)
                                                     title:@"クラスメソッド池袋駅店"
                                                     image:[UIImage imageNamed:@"ikebukuro"]],
             [[CLMShopAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(35.690921, 139.700258)
                                                     title:@"クラスメソッド新宿駅店"
                                                     image:[UIImage imageNamed:@"shinjuku"]]
             ];
    
}

#pragma mark - <CLMRouteViewControllerDelegate>

- (void)routeViewController:(CLMRouteViewController *)routeViewController didSelectStep:(MKRouteStep *)step {
    [self.mapViewController moveMapCameraTo:step];
}

#pragma mark - <CLMMapViewControllerDelegate>

- (void)mapViewController:(CLMMapViewController *)mapViewController didFetchRoute:(id)route
{
    self.routeViewController.route = route;
    [self.routeViewController.tableView reloadData];
    [self setRouteContainerViewHidden:NO animate:YES];
}

@end
