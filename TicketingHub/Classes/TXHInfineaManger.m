//
//  TXHInfineaManger.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHInfineaManger.h"
#import "DTDevices.h"

NSString * const TXHScannerRecognizedValueKey                     = @"TXHScannerRecognizedValueKey";

NSString * const TXHScannerRecognizedQRCodeNotification           = @"TXHScannerRecognizedQRCodeNotification";
NSString * const TXHScannerRecognizedMSRCardDataNotification      = @"TXHScannerRecognizedMSRCardDataotification";
NSString * const TXHScannerConnectionStatusDidChangedNotification = @"TXHScannerConnectionStatusDidChangedNotification";

@interface TXHInfineaManger () <DTDeviceDelegate>

@property (strong, nonatomic) DTDevices *dtDevices;
@property (nonatomic, assign, getter = isScannerConnected) BOOL scannerConnected;

@end

@implementation TXHInfineaManger

+ (instancetype)sharedManager
{
    static TXHInfineaManger *_sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TXHInfineaManger alloc] init];
        [_sharedManager connect];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (!self) return nil;
    
    return self;
}

- (void)connect
{
    self.dtDevices = [DTDevices sharedDevice];
    [self.dtDevices addDelegate:self];
    [self.dtDevices connect];
    
    self.scannerConnected = self.dtDevices.connstate == CONN_CONNECTED;
}

- (void)disconnect
{
    [self.dtDevices removeDelegate:self];
    [self.dtDevices disconnect];
}

- (void)setScannerConnected:(BOOL)scannerConnected
{
    if (_scannerConnected != scannerConnected)
    {
        _scannerConnected = scannerConnected;
        [[NSNotificationCenter defaultCenter] postNotificationName:TXHScannerConnectionStatusDidChangedNotification
                                                            object:self];
    }
}

#pragma mark - DTDeviceDelegate

- (void)connectionState:(int)state
{    
	switch (state)
    {
		case CONN_DISCONNECTED:
            self.scannerConnected = NO;
            break;
		case CONN_CONNECTING:
			break;
		case CONN_CONNECTED:
            self.scannerConnected = YES;
            break;
	}
}

- (void)barcodeData:(NSString *)barcode type:(int)type
{
    [self postNotificationWithName:TXHScannerRecognizedQRCodeNotification value:barcode];
}

- (void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{
    [self postNotificationWithName:TXHScannerRecognizedMSRCardDataNotification value:track1];
}

#pragma mark - helper

- (void)postNotificationWithName:(NSString *)name value:(NSString *)value
{
    if (!name) return;
    
    NSMutableDictionary *payload = @{}.mutableCopy;
    
    if ([value length])
        payload[TXHScannerRecognizedValueKey] = value;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:[payload copy]];
}


@end
