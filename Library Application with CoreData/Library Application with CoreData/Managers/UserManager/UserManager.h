//
//  UserManager.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 21/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "User.h"

@interface UserManager : NSObject <NSFetchedResultsControllerDelegate>

//User CRUD methods
- (void)createUser:(User *)user;
- (void)updateUser:(User *)user;
- (void)deleteUser:(User *)user;
- (User *)getUserFromUserName:(NSString *)username;

//Necessary methods
- (User *)getLastUser;
- (User *)getFirstUser;
- (User *)getCurrentUser; //Last logged in user
- (NSMutableArray *)getAllUser;

//Logical methods
- (BOOL)isAdmin;

//Shared Instance
+(instancetype)sharedInstance;


//Login methods
- (void)loginUser:(NSString *)username :(NSString *)password;
@end
