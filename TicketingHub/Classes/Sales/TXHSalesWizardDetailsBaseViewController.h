//
//  TXHSalesWizardDetailsBaseViewController.h
//  TicketingHub
//
//  Created by Mark on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSalesTimerViewController;

@interface TXHSalesWizardDetailsBaseViewController : UIViewController

@property (strong, nonatomic) id delegate;

// A reference to the timer view
@property (strong, nonatomic) TXHSalesTimerViewController *timerView;

@end
