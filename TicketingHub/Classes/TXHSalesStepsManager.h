//
//  TXHSaleStepsManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TXHSalesWizardViewControllerDataSource.h"
#import "TXHSalesStep.h"

@class TXHSalesStepsManager;

// notifications are way to messy
@protocol TXHSaleStepsManagerDelegate <NSObject>

- (void)saleStepsManager:(TXHSalesStepsManager *)manager didChangeToStep:(TXHSalesStep *)step;

@end

@interface TXHSalesStepsManager : NSObject <TXHSalesWizardViewControllerDataSource>

@property (readonly, nonatomic) NSArray *steps;
@property (readonly, nonatomic) NSUInteger currentStepIndex;

@property (weak, nonatomic) id<TXHSaleStepsManagerDelegate> delegate;

- (instancetype)initWithSteps:(NSArray *)steps;
- (NSInteger)indexOfStep:(TXHSalesStep *)step;
- (TXHSalesStep *)currentStep;
- (void)continueToNextStep;
- (void)resetProcess;
- (BOOL)hasNextStep;

@end
