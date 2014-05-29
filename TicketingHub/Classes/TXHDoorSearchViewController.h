//
//  TXHDoorSearchViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHProductsManager;

extern NSString *const TXHQueryValueKey;
extern NSString *const TXHSelectedOrderKey;

extern NSString *const TXHRecognizedQRCodeNotification;
extern NSString *const TXHDidSelectOrderNotification;

@interface TXHDoorSearchViewController : UIViewController

@property (strong, nonatomic) TXHProductsManager *productsManger;

@end
