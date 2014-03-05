//
//  BarcodeViewController.h
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarcodeViewController;

@protocol BarcodeViewControllerDelegate <NSObject>

@optional

- (void) scanViewController:(BarcodeViewController *)barcodeScaner didSuccessfullyScan:(NSString *)scannedValue;

@end

@interface BarcodeViewController : UIViewController

@property (nonatomic, weak) id<BarcodeViewControllerDelegate> delegate;

@end
