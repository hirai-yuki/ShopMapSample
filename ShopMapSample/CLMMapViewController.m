//
//  CLMMapViewController.m
//  ShopMapSample
//
//  Created by hirai.yuki on 2015/10/28.
//  Copyright © 2015年 Yuki  Hirai. All rights reserved.
//

#import "CLMMapViewController.h"
#import "CLMShopAnnotation.h"

@interface CLMMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) NSArray *stepAnnotations;
@property (nonatomic) MKRouteStep *currentStep;

@end

@implementation CLMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsCompass = YES;
    self.mapView.showsScale = YES;
    self.mapView.showsTraffic = YES;
}

- (void)reloadData {
    self.currentStep = nil;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView addAnnotations:self.shops];
    [self moveDefaultLocation];
}

- (IBAction)mapTypeSegmentedChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 1:
            self.mapView.mapType = MKMapTypeHybridFlyover;
            break;
        default:
            self.mapView.mapType = MKMapTypeStandard;
            break;
    }
}

#pragma mark - Private methods

- (IBAction)moveDefaultLocationBarButtonItemTapped:(id)sender {
    [self moveDefaultLocation];
}

- (void)moveDefaultLocation {
    [self.mapView showAnnotations:self.shops animated:YES];
}

- (void)fetchRouteWithCoordinate:(id<MKAnnotation>)annotation {
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:annotation.coordinate
                              addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.source = source;
    request.destination = destination;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error || response.routes.count == 0) {
            return;
        }
        
        self.currentStep = nil;
        [self.mapView removeAnnotations:self.stepAnnotations];
        [self.mapView removeOverlays:self.mapView.overlays];
        
        MKRoute *route = response.routes[0];
        
        NSMutableArray *stepAnnotations = [NSMutableArray array];
        
        for (MKRouteStep *step in route.steps) {
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate = step.polyline.coordinate;
            [self.mapView addAnnotation:annotation];
            [stepAnnotations addObject:annotation];
        }
        
        self.stepAnnotations = stepAnnotations;
        
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        [self.mapView setVisibleMapRect:route.polyline.boundingMapRect edgePadding:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0) animated:YES];
        
        if ([self.delegate respondsToSelector:@selector(mapViewController:didFetchRoute:)]) {
            [self.delegate mapViewController:self didFetchRoute:route];
        }
    }];
}

- (void)moveMapCameraTo:(MKRouteStep *)step {
    if ([step isEqual:self.currentStep]) {
        return;
    }
    
    CLLocationCoordinate2D ground;
    CLLocationCoordinate2D eye;
    
    if (self.currentStep) {
        ground = step.polyline.coordinate;
        eye = self.currentStep.polyline.coordinate;
    } else {
        ground = step.polyline.coordinate;
        eye = ground;
    }
    
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:ground fromEyeCoordinate:eye eyeAltitude:50.0];
    [self.mapView setCamera:camera animated:YES];
    
    self.currentStep = step;
}

#pragma mark - <MKMapViewDelegate>

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if ([annotation isKindOfClass:[CLMShopAnnotation class]]) {
        CLMShopAnnotation *shopAnnotation = (CLMShopAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"ShopAnnotation"];
        
        if (annotationView) {
            annotationView.annotation = shopAnnotation;
        } else {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:shopAnnotation
                                                          reuseIdentifier:@"ShopAnnotation"];
        }
        
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"shop_pin"];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.detailCalloutAccessoryView = [[UIImageView alloc] initWithImage:shopAnnotation.image];
        
        return annotationView;
    }
    
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyline = overlay;
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
        renderer.lineWidth = 3.0;
        renderer.strokeColor = [UIColor colorWithRed:255/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
        return renderer;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(nonnull MKAnnotationView *)view calloutAccessoryControlTapped:(nonnull UIControl *)control {
    [self fetchRouteWithCoordinate:view.annotation];
}

@end
