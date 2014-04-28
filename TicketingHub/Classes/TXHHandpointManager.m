//
//  TXHHandpointManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHHandpointManager.h"

#import "HeftClient.h"
#import "HeftManager.h"
#import "HeftStatusReportPublic.h"

#import "TXHConfiguration.h"

@interface TXHHandpointManager () <HeftDiscoveryDelegate, HeftStatusReportDelegate>

@property (nonatomic, strong) NSMutableArray   *availableDevices;
@property (nonatomic, strong) HeftRemoteDevice *selectedDevice;
@property (nonatomic, strong) id<HeftClient>    heftClient;

@property (nonatomic, assign, getter = isBluetoothAvailable) BOOL bluetoothAvailable;

@end


@implementation TXHHandpointManager

#pragma mark - Public

- (void)reset
{
    HeftManager* manager = [HeftManager sharedManager];
    manager.delegate = self;
    
    self.availableDevices = [NSMutableArray array];
    
    [manager resetDevices];
}

#pragma mark - HeftDiscoveryDelegate

- (void)hasSources
{
    DLog(@"Bluetooth available");
}

- (void)noSources
{
    DLog(@"Bluetooth isn't available anymore");
}

- (void)didDiscoverDevice:(HeftRemoteDevice*)newDevice
{
    DLog(@"device found: %@",newDevice);
    [self.availableDevices addObject:newDevice];
}

- (void)didDiscoverFinished
{
    // Notifies that search of all available devices was completed.
    
    DLog(@"discovered devices: %@",self.availableDevices);
    
    if ([self.availableDevices count])
    {
        [self txh_connectToDevice:[self.availableDevices firstObject]];
    }
}

- (void)txh_connectToDevice:(HeftRemoteDevice*)newDevice
{
    DLog(@"connected to device: %@",newDevice);
    
    self.heftClient = nil;
    
    if (!newDevice)
        return;
    
    
    NSData *secretData = [self secretDataFromSecretString:CONFIGURATION[kHandpointSecretKey]];

    [[HeftManager sharedManager] clientForDevice:newDevice sharedSecret:secretData delegate:self];
}

- (NSData *)secretDataFromSecretString:(NSString *)secretString
{
    NSMutableData *secretData = [NSMutableData data];
    
    for (int i = 0 ; i < 32; i++)
    {
        NSRange range = NSMakeRange (i*2, 2);
        NSString *bytes = [secretString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:bytes];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [secretData appendBytes:&intValue length:1];
    }
    
    return secretData;
}

- (void)didFindAccessoryDevice:(HeftRemoteDevice*)newDevice
{
    DLog(@"new accessory device was connected");
    
    self.selectedDevice = newDevice;
    // update
}

- (void)didLostAccessoryDevice:(HeftRemoteDevice*)oldDevice
{
    DLog(@"accessory device was disconnected");

    self.selectedDevice = nil;
    // update
}



#pragma mark - HeftStatusReportDelegate

- (void)didConnect:(id<HeftClient>)client
{
    self.heftClient = client;
}

- (void)responseStatus:(id<ResponseInfo>)info
{
    DLog(@"status info: %@",info);
}

- (void)responseScannerEvent:(id<ScannerEventResponseInfo>)info
{
    DLog(@"scan performed: %@",info);
}

- (void)responseEnableScanner:(id<EnableScannerResponseInfo>)info
{
    DLog(@"scanner disabled: %@",info);
}

- (void)responseError:(id<ResponseInfo>)info
{
    DLog(@"error during transaction %@", info);
}

- (void)responseFinanceStatus:(id<FinanceResponseInfo>)info
{
    DLog(@"transaction completed: %@",info);
}

- (void)responseLogInfo:(id<LogInfo>)info
{
    DLog(@"requested log informations: %@",info);
}

- (void)requestSignature:(NSString*)receipt
{
    DLog(@"signature request: %@",receipt);
}

- (void)cancelSignature
{
    DLog(@"signature validation timed out");
}

@end
