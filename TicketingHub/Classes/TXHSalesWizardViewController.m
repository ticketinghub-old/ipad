//
//  TXHSalesWizardViewController.m
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesWizardViewController.h"

#import "TXHSalesStep.h"

#import "UIColor+TicketingHub.h"
#import "UIFont+TicketingHub.h"

//#import <AKPickerView/AKPickerView.h>
#import <RMStepsController/RMStepsBar.h>
#import <RMStepsController/RMStep.h>

@interface TXHSalesWizardViewController () <RMStepsBarDataSource, RMStepsBarDelegate>

@property (weak, nonatomic) IBOutlet RMStepsBar *stepsBar;
//@property (weak, nonatomic) IBOutlet AKPickerView *pickerView;

@end

@implementation TXHSalesWizardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureMenu];
    [self reloadWizard];
}

- (void)configureMenu
{
    self.stepsBar.delegate   = self;
    self.stepsBar.dataSource = self;
    
    self.stepsBar.seperatorColor = [UIColor txhBlueColor];
    [self.stepsBar setHideCancelButton:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.stepsBar reloadData];
}

#pragma mark - Public methods

- (void)reloadWizard
{
    NSUInteger currentIndex = [self.dataSource currentStepIndex];
    
    [self.stepsBar setIndexOfSelectedStep:currentIndex animated:YES];
}

#pragma mark - RMStepsBarDataSource

- (NSUInteger)numberOfStepsInStepsBar:(RMStepsBar *)bar
{
    return [self.dataSource numberOfsteps];
}

- (RMStep *)stepsBar:(RMStepsBar *)bar stepAtIndex:(NSUInteger)index
{
    TXHSalesStep *salesStep = [self.dataSource stepAtIndex:index];
    RMStep *step = [[RMStep alloc] init];
    
    step.title = salesStep.title;
    step.stepTitleFont     = [UIFont txhThinFontWithSize:32];
    step.selectedBarColor  = [UIColor whiteColor];
    step.selectedTextColor = [UIColor txhDarkBlueColor];
    step.enabledBarColor   = [UIColor txhDarkBlueColor];
    step.enabledTextColor  = [UIColor whiteColor];
    step.disabledBarColor  = [UIColor txhVeryLightBlueColor];
    step.disabledTextColor = [UIColor txhBlueColor];
    
    return step;
}

#pragma mark - RMStepsBarDelegate


- (void)stepsBarDidSelectCancelButton:(RMStepsBar *)bar
{
    
}

- (void)stepsBar:(RMStepsBar *)bar shouldSelectStepAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(salesWizardViewController:didSelectStepAtIndex:)])
        [self.dataSource salesWizardViewController:self didSelectStepAtIndex:index];
}


//#pragma mark - AKPickerViewDelegate
//
//- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
//{
//    return [self.dataSource numberOfsteps];
//}
//
//- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
//{
//    TXHSalesStep *step = [self.dataSource stepAtIndex:item];
//
//    return step.title;
//}
//
//- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
//{
//
//}

@end
