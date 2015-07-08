//
//  Book.h
//  Library Application
//
//  Created by Ömer Emre Aslan on 08/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Author;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * pages;
@property (nonatomic, retain) NSDate * publishdate;
@property (nonatomic, retain) Author *author;

@end
