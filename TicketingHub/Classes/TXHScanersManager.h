//
//  TXHScanersManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 14/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXHInfineaManger.h"
#import "TXHScanAPIManager.h"

@class TXHScanersManager;

@protocol TXHScanersManagerDelegate <NSObject>

@optional

- (void)scannerConnectionStatusDidChange:(TXHScanersManager *)manager;

- (void)scannerManager:(TXHScanersManager *)manager didRecognizeQRCode:(NSString *)QRCodeString;
- (void)scannerManager:(TXHScanersManager *)manager didRecognizeMSRCardTrack:(NSString *)cardTrackData;

@end

@interface TXHScanersManager : NSObject

- (instancetype)init;// initializes with default shared managers
- (instancetype)initWithInfineaManager:(TXHInfineaManger *)infineaManager andScanApiManager:(TXHScanAPIManager *)scanApiManager;

@property (weak, nonatomic) id<TXHScanersManagerDelegate> delegate;

@property (readonly, nonatomic, assign, getter = isScannerConnected) BOOL scannerConnected;

@end
