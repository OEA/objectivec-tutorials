//
//  TransactionManager.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 23/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Transaction.h"


@interface TransactionManager : NSObject <NSFetchedResultsControllerDelegate>

//Transaction CRUD methods
- (void)createTransaction:(Book *)book;
- (void)deleteTransaction:(Book *)book;
- (Transaction *)getTransaction:(Book *)book;


//Shared Instance
+ (instancetype)sharedInstance;
@end
