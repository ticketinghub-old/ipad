//
//  TXHSalesTicketCompletionViewController.h
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesTicketCompletionViewController : UIViewController

@property (readonly, nonatomic, getter = isValid) BOOL valid;
@property (weak, nonatomic) id delegate;

@end
