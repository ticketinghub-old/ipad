//
//  TXHSalesWizardViewController.h
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesWizardViewController : UITableViewController

@property (readonly, nonatomic) NSUInteger step;

- (void)moveToNextStep;
- (void)orderExpired;

@end
