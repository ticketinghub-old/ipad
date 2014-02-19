//
//  TXHSalesContentsViewController.h
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHProduct;

@interface TXHSalesContentsViewController : UIViewController

// tells if current controller filled enough informations to go to the next step
@property (readonly, nonatomic, getter = isValid) BOOL valid;

- (void)showStepWithSegueID:(NSString *)segueID;

@end
