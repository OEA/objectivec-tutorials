//
//  ViewController.m
//  Interactive Notification
//
//  Created by Ömer Emre Aslan on 11/08/15.
//  Copyright © 2015 Ömer Emre Aslan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIMutableUserNotificationAction *action1;
    action1 = [[UIMutableUserNotificationAction alloc] init];
    [action1 setActivationMode:UIUserNotificationActivationModeBackground];
    [action1 setTitle:@"Action 1"];
    [action1 setIdentifier:@"Action1"];
    [action1 setDestructive:NO];
    [action1 setAuthenticationRequired:NO];
    
    UIMutableUserNotificationAction *action2;
    action2 = [[UIMutableUserNotificationAction alloc] init];
    [action2 setActivationMode:UIUserNotificationActivationModeBackground];
    [action2 setTitle:@"Action 2"];
    [action2 setIdentifier:@"Action2"];
    [action2 setDestructive:NO];
    [action2 setAuthenticationRequired:NO];
    [action2 setBehavior:UIUserNotificationActionBehaviorTextInput];
    
    
    UIMutableUserNotificationCategory *actionCategory;
    actionCategory = [[UIMutableUserNotificationCategory alloc] init];
    [actionCategory setIdentifier:@"ActionCategory"];
    [actionCategory setActions:@[action1, action2]
                    forContext:UIUserNotificationActionContextDefault];
    
    
    /*
        If we select the context as UIUserNotificationActionContextMinimal, actions will be shown on lockscreen and banner. Otherwise(UIUserNotificationActionContextDefault), more than 2 actions will be shown on modal notification.
     */
    
    NSSet *categories = [NSSet setWithObject:actionCategory];
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendNotification:(id)sender {
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.alertBody = self.textView.text;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.category = @"ActionCategory";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
