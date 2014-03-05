//
//  TXHDoorSearchViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorSearchViewController.h"

#import "TXHBarcodeScanner.h"

#define CAMERA_PREVIEW_ANIMATION_DURATION 0.3

@interface TXHDoorSearchViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraPreviewViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (strong, nonatomic) TXHBarcodeScanner *scanner;
@property (assign, nonatomic) BOOL hasExternalScannerConnected;

@end

@implementation TXHDoorSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self shouldUseBuiltInCamera])
        [self showCameraPreview:NO];
    else
        [self hideCameraPreview:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self shouldUseBuiltInCamera])
        [self startScanningWithBuiltInCamera];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopScanningWithBuiltInCamera];
}

#pragma mark - built-in camera helpers

- (TXHBarcodeScanner *)scanner
{
    if (!_scanner) {
        _scanner = [TXHBarcodeScanner new];
    }
    return _scanner;
}

- (BOOL)shouldUseBuiltInCamera
{
    return ([TXHBarcodeScanner isCameraAvailable] && !self.hasExternalScannerConnected);
}

- (void)startScanningWithBuiltInCamera
{
    [self.scanner showPreviewInView:self.cameraPreviewView];
    [self.scanner startScanning];
}

- (void)stopScanningWithBuiltInCamera
{
    [self.scanner showPreviewInView:nil];
    [self.scanner stopScanning];
}

#pragma mark - update UI

- (void)showCameraPreview:(BOOL)aniamted
{
    [UIView animateWithDuration:aniamted ? CAMERA_PREVIEW_ANIMATION_DURATION : 0.0
                     animations:^{
                         self.cameraPreviewViewHeightConstraint.constant = 300.0;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)hideCameraPreview:(BOOL)aniamted
{
    [UIView animateWithDuration:aniamted ? CAMERA_PREVIEW_ANIMATION_DURATION : 0.0
                     animations:^{
                         self.cameraPreviewViewHeightConstraint.constant = 300.0;
                         [self.view layoutIfNeeded];
                     }];
}

@end
