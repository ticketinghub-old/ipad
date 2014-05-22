//
//  TXHSalesWizardViewController.h
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXHSalesWizardViewControllerDataSource.h"

@interface TXHSalesWizardViewController : UIViewController

@property (weak, nonatomic) id<TXHSalesWizardViewControllerDataSource> dataSource;

- (void)reloadWizard;

@end
