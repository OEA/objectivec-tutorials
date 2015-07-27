//
//  MapVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 27/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "MapVC.h"
#import "UserManager.h"

@interface MapVC() <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UserManager *userManager;
@end

@implementation MapVC


#define METERS_PER_MILE 1609.344

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    
}

- (UserManager *)userManager
{
    if (!_userManager) {
        _userManager = [UserManager sharedInstance];
    }
    
    return _userManager;
}

- (void)mapViewDidFinishLoadingMap:(nonnull MKMapView *)mapView
{
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D istanbul;
    istanbul.latitude = 41.0082376;
    istanbul.longitude= 28.9783589;
    
    CLLocationCoordinate2D konya;
    konya.latitude = 37.8746429;
    konya.longitude= 32.4931554;
    
    CLLocationCoordinate2D sivas;
    sivas.latitude = 39.750545;
    sivas.longitude= 37.0150217;

    
    MKPointAnnotation *istanbulPoint = [[MKPointAnnotation alloc] init];
    istanbulPoint.coordinate = istanbul;
    istanbulPoint.title = @"İstanbul";
    istanbulPoint.subtitle = @"4 books";
    
    
    MKPointAnnotation *konyaPoint = [[MKPointAnnotation alloc] init];
    konyaPoint.coordinate = konya;
    konyaPoint.title = @"Konya";
    konyaPoint.subtitle = @"0 book";
    
    
    MKPointAnnotation *sivasPoint = [[MKPointAnnotation alloc] init];
    sivasPoint.coordinate = sivas;
    sivasPoint.title = @"Sivas";
    sivasPoint.subtitle = @"14 books";
    
    [self.mapView addAnnotation:istanbulPoint];
    [self.mapView addAnnotation:konyaPoint];
    [self.mapView addAnnotation:sivasPoint];
}
@end
