//
//  BarcodeViewController.h
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHBarcodeScanner;

@protocol BarcodeViewControllerDelegate <NSObject>

- (void) scanViewController:(TXHBarcodeScanner *)barcodeScaner didSuccessfullyScan:(NSString *)scannedValue;

@end

@interface TXHBarcodeScanner : NSObject

@property (nonatomic, weak) id<BarcodeViewControllerDelegate> delegate;

+ (BOOL)isCameraAvailable;

- (void)torch:(BOOL)enable;

- (void)startScanning;
- (void)stopScanning;

- (void)showPreviewInView:(UIView *)view;

- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
