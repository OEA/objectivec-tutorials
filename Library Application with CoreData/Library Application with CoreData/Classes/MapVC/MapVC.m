//
//  MapVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 27/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "MapVC.h"
#import "UserManager.h"
#import "City.h"

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
    
    
    NSMutableArray *cities = [self.userManager getCitiesArray];
    
    for (City *city in cities) {
       
        CLLocationCoordinate2D istanbul = [self getCoordinateFromCityName:city.name];
        MKPointAnnotation *istanbulPoint = [[MKPointAnnotation alloc] init];
        istanbulPoint.coordinate = istanbul;
        istanbulPoint.title = city.name;
        istanbulPoint.subtitle = [NSString stringWithFormat:@"%ld books", (long)city.count];
        
        
        [self.mapView addAnnotation:istanbulPoint];
        
    }
    
}

- (CLLocationCoordinate2D)getCoordinateFromCityName:(NSString *)cityName
{
    
    NSLog(@"city = %@", cityName);
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@", cityName];
    
    NSURL *excUrl = [NSURL URLWithString:url];
    NSData *data = [NSData dataWithContentsOfURL:excUrl];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *cityGeneral = dict[@"results"][0];
    NSDictionary *cityDetail = [cityGeneral objectForKey:@"geometry"];
    NSDictionary *bounds = [cityDetail objectForKey:@"location"];
    
    NSString *lat = [bounds objectForKey:@"lat"];
    NSString *lng = [bounds objectForKey:@"lng"];
    CLLocationCoordinate2D istanbul;
    istanbul.latitude = [lat doubleValue];
    istanbul.longitude= [lng doubleValue];
    
    return istanbul;
    
    
    
}
@end
