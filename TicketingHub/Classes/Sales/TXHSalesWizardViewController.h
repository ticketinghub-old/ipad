//
//  TXHSalesWizardViewController.h
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXHSalesWizardDelegate;

@interface TXHSalesWizardViewController : UITableViewController

@property (strong, nonatomic) id <TXHSalesWizardDelegate> delegate;

- (void)moveToNextStep;
- (void)orderExpired;

@end

@protocol TXHSalesWizardDelegate <NSObject>

- (void)wizard:(TXHSalesWizardViewController *)wizard didChooseOption:(NSNumber *)option;
- (void)continueFromStep:(NSNumber *)step;

@end
