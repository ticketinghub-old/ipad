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
@property (assign, nonatomic) NSUInteger currentStep;

@end

@implementation TXHSaleStepsManager

- (instancetype)initWithSteps:(NSArray *)steps
{
    if (!(self = [super init]))
        return nil;
    
    self.steps = steps;
    
    return self;
}

- (void)continueToNextStep;
{
    self.currentStep++;
}

- (BOOL)hasNextStep
{
    return self.currentStep + 1 < [self numberOfsteps];
}

- (void)resetProcess
{
    _currentStep = -1;
    self.currentStep = 0;
}

-(void)setCurrentStep:(NSUInteger)currentStep
{
    if (_currentStep != currentStep)
    {
        _currentStep = currentStep;
        
        [self.delegate saleStepsManager:self didChangeToStep:[self stepAtIndex:_currentStep]];
    }
}

#pragma mark TXHSalesWizardViewControllerDataSource


- (NSUInteger)currentStepIndex
{
    return _currentStep;
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
    return [self indexOfStep:step] < self.currentStep;
}

- (BOOL)isStepCurrent:(id)step
{
    return [self indexOfStep:step] == self.currentStep;
}

- (id)stepAtIndex:(NSUInteger)stepIndex
{
    if (stepIndex >= [self numberOfsteps])
        return nil;
    
    return self.steps[stepIndex];
}

- (void)salesWizardViewController:(TXHSalesWizardViewController *)wizard didSelectStepAtIndex:(NSUInteger)stepIndex
{
    self.currentStep = stepIndex;
}

- (BOOL)salesWizardViewController:(TXHSalesWizardViewController *)wizard canSelectStepAtIndex:(NSUInteger)stepIndex
{
    return stepIndex < self.currentStepIndex;
}


@end
