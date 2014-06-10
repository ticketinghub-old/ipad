//
//  TXHDoorOrderDetailsViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHProductsManager;

@interface TXHDoorOrderDetailsViewController : UIViewController

@property (nonatomic, strong) TXHOrder           *order;
@property (nonatomic, weak  ) TXHProductsManager *productManager;

@end
