//
//  UserLogManager.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 22/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "User.h"
#import "Book.h"
#import "UserLog.h"

@interface UserLogManager : NSObject <NSFetchedResultsControllerDelegate>

//Create Log
- (void)createLog:(NSString *)transaction :(User *)user;

//Get All Log for specific username
- (NSMutableArray *)getLogsFromUserName:(NSString *)username;

//Shared Instance
+(instancetype)sharedInstance;
@end
