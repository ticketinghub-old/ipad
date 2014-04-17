//
//  TXHInfineaManger.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TXHScannerRecognizedValueKey;

extern NSString * const TXHScannerRecognizedQRCodeNotification;
extern NSString * const TXHScannerRecognizedMSRCardDataNotification;
extern NSString * const TXHScannerConnectionStatusDidChangedNotification;

@interface TXHInfineaManger : NSObject

@property (readonly, nonatomic, assign, getter = isScannerConnected) BOOL scannerConnected;

- (void)connect;
- (void)disconnect;

@end
