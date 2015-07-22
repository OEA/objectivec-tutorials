//
//  AuthorManager.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 22/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Author.h"
#import "Book.h"

@interface AuthorManager : NSObject <NSFetchedResultsControllerDelegate>

//Create Log
- (void)createAuthor:(Author *)author;
- (Author *)getAuthor:(NSString *)name;

//Shared Instance
+(instancetype)sharedInstance;
@end
