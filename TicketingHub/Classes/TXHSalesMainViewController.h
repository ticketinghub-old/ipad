//
//  TXHSalesMainViewController.h
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXHSalesContentsViewControllerProtocol <NSObject>

@property (nonatomic, readonly, getter = isValid) BOOL valid;

@end

@interface TXHSalesMainViewController : UIViewController

@end
