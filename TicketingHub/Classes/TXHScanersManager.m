//
//  TXHScanersManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 14/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHScanersManager.h"


@interface TXHScanersManager ()

@property (strong, nonatomic) TXHScanAPIManager *scanAPIManager;
@property (strong, nonatomic) TXHInfineaManger  *infineaManager;

@end

@implementation TXHScanersManager

- (instancetype)initWithInfineaManager:(TXHInfineaManger *)infineaManager andScanApiManager:(TXHScanAPIManager *)scanApiManager
{
    if (!(self = [super init]))
        return nil;
    
    _infineaManager = infineaManager;
    _scanAPIManager = scanApiManager;
    
    [self registerForNotifications];
    
    return self;
}

- (instancetype)init
{
    return [self initWithInfineaManager:[TXHInfineaManger sharedManager] andScanApiManager:[TXHScanAPIManager sharedManager]];
}

- (void)dealloc
{
    [self unregisterFromNotifications];
}

- (BOOL)isScannerConnected
{
    return self.scanAPIManager.isScannerConnected || self.infineaManager.isScannerConnected;
}

#pragma mark - notifications

- (void)registerForNotifications
{
    [self registerForScannersConnectionNotifications];
    [self registerForScannersRecognitionNotifications];
}

- (void)unregisterFromNotifications
{
    [self unregisterFromScannersConnectionNotifications];
    [self unregisterFromScannersRecognitionNotifications];
}

- (void)registerForScannersConnectionNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scannerConnectionDidChange:) name:TXHScannerConnectionStatusDidChangedNotification object:self.infineaManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scannerConnectionDidChange:) name:TXHScanAPIScannerConnectionStatusDidChangedNotification object:self.scanAPIManager];
}

- (void)unregisterFromScannersConnectionNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHScannerConnectionStatusDidChangedNotification object:self.infineaManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHScanAPIScannerConnectionStatusDidChangedNotification object:self.scanAPIManager];
}


- (void)registerForScannersRecognitionNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scannerBarcodeRecognized:) name:TXHScannerRecognizedQRCodeNotification object:self.infineaManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scannerMSRDataRecognized:) name:TXHScannerRecognizedMSRCardDataNotification object:self.infineaManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scannerBarcodeRecognized:) name:TXHScanAPIScannerRecognizedCodeNotification object:self.scanAPIManager];
}

- (void)unregisterFromScannersRecognitionNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHScannerRecognizedQRCodeNotification object:self.infineaManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHScannerRecognizedMSRCardDataNotification object:self.infineaManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHScanAPIScannerRecognizedCodeNotification object:self.scanAPIManager];
}

- (void)scannerMSRDataRecognized:(NSNotification *)note
{
    if (note.object == self.infineaManager)
    {
        if ([self.delegate respondsToSelector:@selector(scannerManager:didRecognizeMSRCardTrack:)])
        {
            NSString *cardTrack = [note userInfo][TXHScannerRecognizedValueKey];
            [self.delegate scannerManager:self didRecognizeMSRCardTrack:cardTrack];
        }
    }
}

- (void)scannerBarcodeRecognized:(NSNotification *)note
{
    if (![self.delegate respondsToSelector:@selector(scannerManager:didRecognizeQRCode:)])
        return;
    
    NSString *barcodeDataString;
    
    if (note.object == self.infineaManager)
        barcodeDataString = [note userInfo][TXHScannerRecognizedValueKey];
    else if  (note.object == self.scanAPIManager)
        barcodeDataString = [note userInfo][TXHScanAPIScannerRecognizedValueKey];
    
    if ([barcodeDataString length])
        [self.delegate scannerManager:self didRecognizeQRCode:barcodeDataString];
}

- (void)scannerConnectionDidChange:(NSNotification *)note
{
    if ([self.delegate respondsToSelector:@selector(scannerConnectionStatusDidChange:)])
        [self.delegate scannerConnectionStatusDidChange:self];
}

@end
