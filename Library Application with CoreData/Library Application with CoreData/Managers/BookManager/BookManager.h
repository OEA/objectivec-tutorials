//
//  BookManager.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 21/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Book.h"


@interface BookManager : NSObject <NSFetchedResultsControllerDelegate>

//Book CRUD methods
- (void)createBook:(Book *)book;
- (void)updateBook:(Book *)book;
- (void)deleteBook:(Book *)book;
- (Book *)getBookFromName:(NSString *)name; //of book

//Necessary Methods
- (NSArray *)getAllBooks;

//Shared Instance
+ (instancetype)sharedInstance;
@end
