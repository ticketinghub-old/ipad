//
//  TXHScanAPIManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHScanAPIManager.h"
#import "ScanApiHelper.h"

NSString * const TXHScanAPIScannerRecognizedValueKey                     = @"TXHScanAPIScannerRecognizedValueKey";

NSString * const TXHScanAPIScannerRecognizedCodeNotification             = @"TXHScanAPIScannerRecognizedCodeNotification";
NSString * const TXHScanAPIScannerConnectionStatusDidChangedNotification = @"TXHScanAPIScannerConnectionStatusDidChangedNotification";


@interface TXHScanAPIManager () <ScanApiHelperDelegate>

@property (strong, nonatomic) ScanApiHelper * scanApiHelper;
@property (strong, nonatomic) NSTimer       * scanApiConsumer;
@property (strong, nonatomic) NSMutableSet  * devices;

@end

@implementation TXHScanAPIManager

+ (instancetype)sharedManager
{
    static TXHScanAPIManager *_sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TXHScanAPIManager alloc] init];
        [_sharedManager connect];
    });
    
    return _sharedManager;
}

- (void)connect
{
    self.devices = [NSMutableSet set];
    
    ScanApiHelper *scanApiHelper = [[ScanApiHelper alloc] init];
    [scanApiHelper setDelegate:self];
    [scanApiHelper open];

    self.scanApiHelper   = scanApiHelper;
    self.scanApiConsumer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(consumeAsyncData:) userInfo:nil repeats:YES];
}

- (void)disconnect
{
    [self.scanApiHelper setDelegate:nil];
    [self.scanApiHelper close];
}

- (BOOL)isScannerConnected
{
    return [self.devices count] > 0;
}

#pragma mark - Pulling Data - WTF?

- (void)consumeAsyncData:(NSTimer *)tiemr
{
    if (tiemr == self.scanApiConsumer)
        [self.scanApiHelper doScanApiReceive];
}

#pragma mark - ScanApiHelperDelegate

- (void)onDeviceArrival:(SKTRESULT)result Device:(DeviceInfo*)deviceInfo
{
    [self.devices addObject:deviceInfo];
    [self postNotificationWithName:TXHScanAPIScannerConnectionStatusDidChangedNotification value:nil];
}

- (void)onDeviceRemoval:(DeviceInfo*) deviceRemoved
{
    [self.devices removeObject:deviceRemoved];
    [self postNotificationWithName:TXHScanAPIScannerConnectionStatusDidChangedNotification value:nil];
}

- (void)onError:(SKTRESULT) result
{
    DLog(@"Scan API Scanner error: %ld", result);
}

- (void)onDecodedData:(DeviceInfo*) device DecodedData:(id<ISktScanDecodedData>) decodedData
{
    NSString *decodedString = [NSString stringWithUTF8String:(const char *)[decodedData getData]];
    [self postNotificationWithName:TXHScanAPIScannerRecognizedCodeNotification value:decodedString];
}

- (void)onScanApiInitializeComplete:(SKTRESULT) result
{
    DLog(@"Scan API Scanner onScanApiInitializeComplete: %ld", result);
}

- (void)onScanApiTerminated
{
    DLog(@"Scan API Scanner onScanApiTerminated");
}

- (void)onErrorRetrievingScanObject:(SKTRESULT) result
{
    DLog(@"Scan API Scanner onErrorRetrievingScanObject: %ld", result);
}

#pragma mark - helpers

#pragma mark - helper

- (void)postNotificationWithName:(NSString *)name value:(NSString *)value
{
    if (!name) return;
    
    NSMutableDictionary *payload = @{}.mutableCopy;
    
    if ([value length])
        payload[TXHScanAPIScannerRecognizedValueKey] = value;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:[payload copy]];
}

@end
