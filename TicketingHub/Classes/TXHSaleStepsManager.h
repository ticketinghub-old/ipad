//
//  TXHSaleStepsManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TXHSalesWizardViewControllerDataSource.h"

@interface TXHSaleStepsManager : NSObject <TXHSalesWizardViewControllerDataSource>

@property (readonly, nonatomic) NSArray *steps;
@property (readonly, nonatomic) NSUInteger currentStepIndex;

- (instancetype)initWithSteps:(NSArray *)steps;

@end
