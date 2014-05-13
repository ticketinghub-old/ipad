//
//  TXHScanAPIManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const TXHScanAPIScannerRecognizedValueKey;

NSString * const TXHScanAPIScannerRecognizedCodeNotification;
NSString * const TXHScanAPIScannerConnectionStatusDidChangedNotification;


@interface TXHScanAPIManager : NSObject

- (void)connect;
- (void)disconnect; // IMPORTANT to call disconnect as api helper hold reference to its delegate... wtf

@end
