//
//  TXHSalesWizardViewControllerDataSource.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TXHSalesStep;
@class TXHSalesWizardViewController;

@protocol TXHSalesWizardViewControllerDataSource <NSObject>

- (NSUInteger)numberOfsteps;
- (NSUInteger)currentStepIndex;
- (TXHSalesStep *)stepAtIndex:(NSUInteger)stepIndex;

- (NSUInteger)indexOfStep:(TXHSalesStep *)step;
- (BOOL)isStepCompleted:(TXHSalesStep *)step;
- (BOOL)isStepCurrent:(TXHSalesStep *)step;

- (void)salesWizardViewController:(TXHSalesWizardViewController *)wizard didSelectStepAtIndex:(NSUInteger)stepIndex; // could go to delegate

@optional

- (BOOL)salesWizardViewController:(TXHSalesWizardViewController *)wizard canSelectStepAtIndex:(NSUInteger)stepIndex; // could go to delegate

@end
