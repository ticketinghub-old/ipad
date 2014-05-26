//
//  TXHDoorSearchViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorSearchViewController.h"
#import <UIViewController+BHTKeyboardAnimationBlocks/UIViewController+BHTKeyboardNotifications.h>

#import "TXHScanersManager.h"

#import "TXHBarcodeScanner.h"

NSString *const TXHQueryValueKey                    = @"TXHQueryValueKey";

NSString *const TXHRecognizedQRCodeNotification     = @"TXHRecognizedQRCodeNotification";
NSString *const TXHSearchQueryDidChangeNotification = @"TXHSearchQueryDidChangeNotification";

#define CAMERA_PREVIEW_ANIMATION_DURATION 0.3

@interface TXHDoorSearchViewController () <BarcodeViewControllerDelegate, UITextFieldDelegate, TXHScanersManagerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraPreviewViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelConstraint;

@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (strong, nonatomic) NSDate *lastScanTimestamp;

@property (strong, nonatomic) TXHBarcodeScanner *scanner;
@property (strong, nonatomic) TXHScanersManager *scannersManager;

@end

@implementation TXHDoorSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupKeybaordAnimations];
    
    self.searchField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateCameraView];
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
    [self.scanner setInterfaceOrientation:toInterfaceOrientation];
}

- (TXHScanersManager *)scannersManager
{
    if (!_scannersManager)
    {
        _scannersManager = [[TXHScanersManager alloc] init];
        _scannersManager.delegate = self;
    }
    
    return _scannersManager;
}

#pragma mark - private

- (void)updateCameraView
{
    if ([self shouldUseBuiltInCamera])
        [self showCameraPreviewAnimated:YES];
    else
        [self hideCameraPreviewAnimated:YES];
}

- (BOOL)shouldUseBuiltInCamera
{
    return ([TXHBarcodeScanner isCameraAvailable] && !self.scannersManager.isScannerConnected);
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

- (void)setupKeybaordAnimations
{
    __weak typeof(self) wself = self;
    
    [self setKeyboardWillShowAnimationBlock:^(CGRect keyboardFrame) {
        [wself hideCameraPreviewAnimated:NO];
        
        wself.bottomLabelConstraint.constant = 30;
        wself.bottomConstraint.constant = keyboardFrame.size.width;
    
        [wself.view layoutIfNeeded];
    }];
    
    
    [self setKeyboardWillHideAnimationBlock:^(CGRect keyboardFrame) {
        if ([wself shouldUseBuiltInCamera])
            [wself showCameraPreviewAnimated:NO];
        
        wself.bottomConstraint.constant = 0;
        wself.bottomLabelConstraint.constant = 100;
        
        [wself.view layoutIfNeeded];
    }];
    
    [self setKeyboardDidShowActionBlock:^(CGRect keyboardFrame) {
        [wself stopScanningWithBuiltInCamera];
    }];
    
    [self setKeyboardDidHideActionBlock:^(CGRect keyboardFrame){
        [wself startScanningWithBuiltInCamera];
    }];
}

#pragma mark - lazy loading getters

- (TXHBarcodeScanner *)scanner
{
    if (!_scanner && [self shouldUseBuiltInCamera])
    {
        TXHBarcodeScanner *scanner = [TXHBarcodeScanner new];
        scanner.delegate = self;
        _scanner = scanner;
    }
    return _scanner;
}

#pragma mark - TXHScannersmanagerDelegate

- (void)scannerConnectionStatusDidChange:(TXHScanersManager *)manager
{
    [self updateCameraView];
    
    if ([self shouldUseBuiltInCamera])
        [self startScanningWithBuiltInCamera];
    else
        [self stopScanningWithBuiltInCamera];
}

#pragma mark - update UI

- (void)showCameraPreviewAnimated:(BOOL)animated
{
    [self setCameraPreviewViewHeightConstraintConstant:300.0 aniamted:animated];
}

- (void)hideCameraPreviewAnimated:(BOOL)animated
{
    [self setCameraPreviewViewHeightConstraintConstant:0.0 aniamted:animated];
}

- (void)setCameraPreviewViewHeightConstraintConstant:(CGFloat)constant aniamted:(BOOL)animated
{
    if (animated)
        [UIView animateWithDuration:CAMERA_PREVIEW_ANIMATION_DURATION
                         animations:^{
                             self.cameraPreviewViewHeightConstraint.constant = constant;
                             [self.view layoutIfNeeded];
                         }];
    else
        self.cameraPreviewViewHeightConstraint.constant = constant;
}

#pragma mark - BarcodeViewControllerDelegate

- (void)scanViewController:(TXHBarcodeScanner *)barcodeScaner didSuccessfullyScan:(NSString *)scannedValue
{
    if ([self canMakeNextScan])
    {
        [self recordBarcodeScanTimestamp];
        [self postNotificationWithName:TXHRecognizedQRCodeNotification value:scannedValue];
    }
}

- (BOOL)canMakeNextScan
{
    return (!self.lastScanTimestamp || [self.lastScanTimestamp timeIntervalSinceNow] < -1.0);
}

- (void)recordBarcodeScanTimestamp
{
    self.lastScanTimestamp = [NSDate date];
}


#pragma mark - textField

- (IBAction)searchFieldEditingChanged:(id)sender
{
    [self postNotificationWithName:TXHSearchQueryDidChangeNotification value:self.searchField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - notification helper

- (void)postNotificationWithName:(NSString *)name value:(NSString *)value
{
    if (!name) return;
    
    NSMutableDictionary *payload = @{}.mutableCopy;
    
    if ([value length])
        payload[TXHQueryValueKey] = value;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:[payload copy]];
}

@end
