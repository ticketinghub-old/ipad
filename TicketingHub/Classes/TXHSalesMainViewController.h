//
//  TXHSalesMainViewController.h
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHOrderManager;
@class TXHProductsManager;

@protocol TXHSalesContentsViewControllerProtocol <NSObject>

@property (nonatomic, readonly, getter = isValid) BOOL valid;

@property (strong, nonatomic) TXHProductsManager *productManager;
@property (strong, nonatomic) TXHOrderManager    *orderManager;

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName;

@optional

- (void)setOffsetBottomBy:(CGFloat)offset;

@end

@interface TXHSalesMainViewController : UIViewController

@property (strong, nonatomic) TXHProductsManager *productManager;
@property (strong, nonatomic) TXHOrderManager    *orderManager;

@end
