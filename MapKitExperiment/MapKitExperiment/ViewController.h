//
//  ViewController.h
//  MapKitExperiment
//
//  Created by Ömer Emre Aslan on 08/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#define METERS_PER_MILE 1609.344

@interface ViewController : UIViewController

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@end

