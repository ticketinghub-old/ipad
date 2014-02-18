//
//  TXHSaleStepsManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSaleStepsManager.h"
#import "TXHSalesWizardViewController.h"

@interface TXHSaleStepsManager ()

@property (strong, nonatomic) NSArray *steps;
@property (assign, nonatomic) NSUInteger currentStepIndex;

@end

@implementation TXHSaleStepsManager

- (instancetype)initWithSteps:(NSArray *)steps
{
    if (!(self = [super init]))
        return nil;
    
    self.steps = steps;
    
    return self;
}

#pragma mark TXHSalesWizardViewControllerDataSource

- (NSUInteger)currentStepIndex
{
    return _currentStepIndex;
}

- (NSUInteger)numberOfsteps
{
    return [self.steps count];
}

- (NSUInteger)indexOfStep:(id)step
{
    return [self.steps indexOfObject:step];
}

- (BOOL)isStepCompleted:(id)step
{
    return NO;
}

- (id)stepAtIndex:(NSUInteger)stepIndex
{
    if (stepIndex >= [self numberOfsteps])
        return nil;
    
    return self.steps[stepIndex];
}

- (void)salesWizardViewController:(TXHSalesWizardViewController *)wizard didSelectStepAtIndex:(NSUInteger)stepIndex
{
    
}

- (BOOL)salesWizardViewController:(TXHSalesWizardViewController *)wizard canSelectStepAtIndex:(NSUInteger)stepIndex
{
    return stepIndex < self.currentStepIndex;
}


@end
