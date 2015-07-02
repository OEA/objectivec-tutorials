//
//  MainVC.m
//  Simple Calculator
//
//  Created by Ömer Emre Aslan on 01/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "MainVC.h"
#import "CalculatorManager.h"
@interface MainVC()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *calculatorButtons;
@property (strong, nonatomic) IBOutlet UITextView *resultText;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) CalculatorManager *calculateManager;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *logicalButtons;
@end

@implementation MainVC


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
    if (!_calculateManager)
        _calculateManager = [CalculatorManager sharedInstance];
}
- (IBAction)numbersButtonTapped:(id)sender 
{
    UIButton *button = (UIButton *)sender;
    [self clearBorderOfLogicalButtons];
    if ([self hasResultZero] || self.calculateManager.isOnProgress) {
        self.calculateManager.isOnProgress = NO;
        if (![[button currentTitle] isEqualToString:@"0"]) {
            self.resultText.text = [button currentTitle];
            [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
        }
    } else {
        [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
        self.resultText.text = [self.resultText.text stringByAppendingString:[button currentTitle]];
    }
}
- (IBAction)plusMinusButtonTapped:(id)sender {
    NSNumber *number = [self convertStringToNumber:self.resultText.text];
    if ([number floatValue] > 0 ) {
        self.resultText.text = [NSString stringWithFormat:@"-%@", number];
    } else if ([number floatValue] < 0){
        float number1 = [number floatValue];
        float product = number1 * -1;
        NSNumber *result = [NSNumber numberWithFloat:product];
        self.resultText.text = [NSString stringWithFormat:@"%@", result];
    } else {
        //do Nothing when it is zero
    }
}
- (IBAction)commaButtonTapped:(id)sender {
    if ([self.resultText.text containsString:@"."]) {
        //do nothing
    } else {
        self.resultText.text = [self.resultText.text stringByAppendingString:@"."];
    }
}

- (BOOL)hasResultZero
{
    return ([self.resultText.text isEqualToString:@"0"]) ? YES : NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{ 
    return UIStatusBarStyleLightContent; 
}
- (IBAction)equalsButtonTapped:(id)sender {
    [self clearBorderOfLogicalButtons];
    
    if (self.calculateManager.cMode) {
        self.calculateManager.secondNumber = [self convertStringToNumber:self.resultText.text];
        NSNumber *result = [self.calculateManager processNumbers:self.calculateManager.cMode];
        self.calculateManager.firstNumber = result;
        self.resultText.text = [NSString stringWithFormat:@"%@",result];
        self.calculateManager.cMode = nil;
    } 
    
    
    
}

- (IBAction)percentageButtonTapped:(id)sender {
    NSNumber *number = [self convertStringToNumber:self.resultText.text];
    self.resultText.text = [self.calculateManager getPercentageOfNumber:number];
}
- (void)clearBorderOfLogicalButtons {
    
    for (UIButton *button in self.logicalButtons) {
        [[button layer] setBorderWidth:0.25f];
        [[button layer] setBorderColor:[UIColor colorWithRed:0.0f/255.0f
                                                       green:0.0f/255.0f
                                                        blue:0.0f/255.0f
                                                       alpha:0.4f] .CGColor];
    }
}

- (IBAction)logicalButtonsTapped:(id)sender {
    
    //In construction
    /*
    
    */
    if (!self.calculateManager.cMode) {
        
        self.calculateManager.firstNumber = nil;
        self.calculateManager.secondNumber = nil;
        self.calculateManager.cMode = [self.logicalButtons indexOfObject:sender];
    }
        self.calculateManager.isOnProgress = YES;
        if (!self.calculateManager.firstNumber) {
            self.calculateManager.firstNumber = [self convertStringToNumber:self.resultText.text];
        } else {
            self.calculateManager.secondNumber = [self convertStringToNumber:self.resultText.text];
            NSNumber *result = [self.calculateManager processNumbers:[self.logicalButtons indexOfObject:sender]];
            self.calculateManager.firstNumber = result;
            self.resultText.text = [NSString stringWithFormat:@"%@",result];
        }
    
    [self clearBorderOfLogicalButtons];
    
    [[sender layer] setBorderWidth:2.0f];
    [[sender layer] setBorderColor:[UIColor colorWithRed:0.0f/255.0f
                                                   green:0.0f/255.0f
                                                    blue:0.0f/255.0f
                                                   alpha:0.75f] .CGColor];
}

- (void)updateUI
{
    [self setNeedsStatusBarAppearanceUpdate];
    for (UIButton *button in self.calculatorButtons) {
        [[button layer] setBorderWidth:0.25f];
        [[button layer] setBorderColor:[UIColor colorWithRed:0.0f/255.0f
                                                       green:0.0f/255.0f
                                                        blue:0.0f/255.0f
                                                       alpha:0.4f] .CGColor];
    }
}

- (NSNumber *)convertStringToNumber:(NSString *)number
{
    NSNumberFormatter *f = [NSNumberFormatter new];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:number];
    return myNumber;
}

- (IBAction)clearResultText:(id)sender 
{
    
    self.calculateManager.firstNumber = nil;
    self.calculateManager.secondNumber = nil;
    self.resultText.text = @"0";
    [self clearBorderOfLogicalButtons];
    [self.clearButton setTitle:@"AC" forState:UIControlStateNormal];
}
@end
