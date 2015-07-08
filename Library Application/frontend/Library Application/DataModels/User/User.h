//
//  User.h
//  Library Application
//
//  Created by Ömer Emre Aslan on 08/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * email;

@end
