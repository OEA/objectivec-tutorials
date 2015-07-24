//
//  SubjectManager.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 22/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Subject.h"


@interface SubjectManager : NSObject <NSFetchedResultsControllerDelegate>

//Book CRUD methods
- (void)createSubject:(Subject *)subject;
- (void)updateSubject:(Subject *)subject;
- (void)deleteSubject:(Subject *)subject;
- (Subject *)getSubjectFromName:(NSString *)name; //of subject

//Necessary Methods
- (NSMutableArray *)getAllSubjects;

//Shared Instance
+ (instancetype)sharedInstance;
@end
