//
//  ViewController.m
//  TouchID Experiment
//
//  Created by Ömer Emre Aslan on 12/08/15.
//  Copyright © 2015 Ömer Emre Aslan. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self authenticateUser];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)authenticateUser
{
    LAContext *context = [LAContext new];
    NSError *error;
    NSString *authenticateMessage = @"Please authenticate for seeing stuff!";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:authenticateMessage reply:^(BOOL success, NSError * __nullable error) {
            if (success) {
                NSLog(@"success!");
            } else {
                NSLog(@"fail!");
            }
            
            
            switch (error.code) {
                case LAErrorSystemCancel:
                    NSLog(@"Authentication was canceled by system");
                    break;
                    
                case LAErrorUserCancel:
                    NSLog(@"Authentication was canceled by user");
                    break;
                    
                case LAErrorUserFallback:
                    NSLog(@"User selected to enter password");
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self showPasswordAlert];
                    }];
                    break;
            }
            
        }];
    } else {
        NSLog(@"%@",error.localizedDescription);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self showPasswordAlert];
        }];
    }
}

- (void)showPasswordAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Touch ID Password" message:@"Please enter the password" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
        
        UITextField *textField = [alertController textFields].firstObject;
        if (textField) {
            if ([textField.text isEqualToString:@"test"]) {
                NSLog(@"success!");
            } else {
                NSLog(@"fail!");
                [self showPasswordAlert];
            }
        }
        
    }];
    [alertController addAction:action];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * __nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
