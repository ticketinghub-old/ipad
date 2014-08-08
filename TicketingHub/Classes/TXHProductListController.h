//
//  TXHProductListController.h
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import UIKit;

@class TXHProductsManager;

@interface TXHProductListController : UIViewController 

@property (strong, nonatomic) TXHUser *user;
@property (strong, nonatomic) TXHProductsManager *productsManager;
@property (weak, nonatomic) UIView *activityViewTargetView;

@end
