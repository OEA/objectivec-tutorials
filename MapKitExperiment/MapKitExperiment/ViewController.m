//
//  ViewController.m
//  MapKitExperiment
//
//  Created by Ömer Emre Aslan on 08/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "ViewController.h"
#import "City.h"
@interface ViewController () <MKMapViewDelegate,  CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *city;
@end

@implementation ViewController

@synthesize managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    [self showMap];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
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
        [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
            MKPlacemark *placeMark = [placemarks objectAtIndex:0];
            NSString *city;
            if (!placeMark.subAdministrativeArea) {
                city = placeMark.administrativeArea;
            } else if ([placeMark.addressDictionary objectForKey:@"City"]){
                city = [placeMark.addressDictionary objectForKey:@"City"];
            } else {
                city = placeMark.locality;
            }
            
            self.city = city;
            [self addCity:city :self.currentLocation.coordinate];
        }];
        [self zoomLocation];
    } else {
        self.currentLocation = manager.location;
        [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                MKPlacemark *placeMark = [placemarks objectAtIndex:0];
                NSString *city;
                if (!placeMark.subAdministrativeArea) {
                    city = placeMark.administrativeArea;
                } else if ([placeMark.addressDictionary objectForKey:@"City"]){
                    city = [placeMark.addressDictionary objectForKey:@"City"];
                } else {
                    city = placeMark.locality;
                }
                
                
                //if ([city isEqualToString:placeMark.title])
                [self checkCities :self.city :city :self.currentLocation.coordinate];
                
                self.city = city;
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
    //[self logCitiesFromDB];
}

- (void)checkCities :(NSString *)firstCity :(NSString *)secondCity :(CLLocationCoordinate2D)coordinate
{
    if ([firstCity isEqualToString:secondCity]) {
        //donothin'
    } else {
        [self addCity:secondCity :self.currentLocation.coordinate];
        [self zoomLocation];
    }
}

-(void)methodWithName :(NSString*)name surname:(NSString*)surname{
    
}

- (void)zoomLocation
{
    CLLocationCoordinate2D zoomLocation = self.currentLocation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];
}

- (void)addCity :(NSString *)cityName :(CLLocationCoordinate2D)coordinate
{
    City *city;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", cityName];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    if ([results count] > 0) {
        city = [results objectAtIndex:0];
        NSLog(@"City ( %@ ) was updated", city.name);
    } else {
        city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.managedObjectContext];
        [city setValue:cityName forKey:@"name"];
        
        NSNumber *latitude = [NSNumber numberWithDouble:(double)coordinate.latitude];
        NSNumber *longitude = [NSNumber numberWithDouble:(double)coordinate.latitude];
        
        [city setValue:longitude forKey:@"longitude"];
        [city setValue:latitude forKey:@"latitude"];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        
        NSLog(@"City ( %@ ) was added", cityName);
    }
    
}

- (void)logCitiesFromDB
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    NSLog(@"%lu adet city var", (unsigned long)[results count]);
    for (City *city in results) {
        NSLog(@"City: %@", city.name);
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
