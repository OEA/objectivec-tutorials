//
//  ViewController.m
//  MapKitExperiment
//
//  Created by Ömer Emre Aslan on 08/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "ViewController.h"
@interface ViewController () <MKMapViewDelegate,  CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic) BOOL isChangedLocation;
@property (strong, nonatomic) CLLocation *currentLocation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    [self showMap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLGeocoder *geoCoder = [CLGeocoder new];
    
    if (!self.currentLocation) {
        self.currentLocation = manager.location;
        CLLocationCoordinate2D zoomLocation = self.currentLocation.coordinate;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        
        // 3
        [_mapView setRegion:viewRegion animated:YES];
        
//        [geoCoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//                
//            
//            
//        }];
    } else {
    
    }
}

- (void)showMap
{
    
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation= self.locationManager.location.coordinate;
    
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
