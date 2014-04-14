//
//  TXHSaleStepsManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSalesStepsManager.h"
#import "TXHSalesWizardViewController.h"

@interface TXHSalesStepsManager ()

@property (strong, nonatomic) NSArray *steps;
@property (assign, nonatomic) NSUInteger currentStepIndex;

@end

@implementation TXHSalesStepsManager

- (instancetype)initWithSteps:(NSArray *)steps
{
    if (!(self = [super init]))
        return nil;
    
    self.steps = steps;
    
    return self;
}

- (void)continueToNextStep;
{
    self.currentStepIndex++;
}

- (BOOL)hasNextStep
{
    return self.currentStepIndex + 1 < [self numberOfsteps];
}

- (void)resetProcess
{
    self.currentStepIndex = 0;
}

- (void)setCurrentStepIndex:(NSUInteger)currentStepIndex
{
    _currentStepIndex = currentStepIndex;
    
    [self.delegate saleStepsManager:self didChangeToStep:[self stepAtIndex:_currentStepIndex]];
}

#pragma mark TXHSalesWizardViewControllerDataSource

- (id)currentStep
{
    return [self stepAtIndex:self.currentStepIndex];
}

- (NSUInteger)numberOfsteps
{
    return [self.steps count];
}

- (NSInteger)indexOfStep:(id)step;
{
    return [self.steps indexOfObject:step];
}

- (BOOL)isStepCompleted:(id)step
{
    return [self indexOfStep:step] < self.currentStepIndex;
}

- (BOOL)isStepCurrent:(id)step
{
    return [self indexOfStep:step] == self.currentStepIndex;
}

- (id)stepAtIndex:(NSUInteger)stepIndex
{
    if (stepIndex >= [self numberOfsteps])
        return nil;
    
    return self.steps[stepIndex];
}

- (void)salesWizardViewController:(TXHSalesWizardViewController *)wizard didSelectStepAtIndex:(NSUInteger)stepIndex
{
    self.currentStepIndex = stepIndex;
}

- (BOOL)salesWizardViewController:(TXHSalesWizardViewController *)wizard canSelectStepAtIndex:(NSUInteger)stepIndex
{
    if (self.currentStepIndex == [self.steps count] - 1)
        return NO;
    
    return stepIndex < self.currentStepIndex;
}


@end
