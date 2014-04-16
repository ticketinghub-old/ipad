//
//  TXHDoorSearchViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorSearchViewController.h"

#import "TXHInfineaManger.h"
#import "TXHBarcodeScanner.h"

NSString *const TXHQueryValueKey                    = @"TXHQueryValueKey";

NSString *const TXHRecognizedQRCodeNotification     = @"TXHRecognizedQRCodeNotification";
NSString *const TXHSearchQueryDidChangeNotification = @"TXHSearchQueryDidChangeNotification";

#define CAMERA_PREVIEW_ANIMATION_DURATION 0.3

@interface TXHDoorSearchViewController () <BarcodeViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraPreviewViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelConstraint;

@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (strong, nonatomic) NSDate *lastScanTimestamp;

@property (strong, nonatomic) TXHBarcodeScanner *scanner;
@property (strong, nonatomic) TXHInfineaManger *infineaManager;
@end

@implementation TXHDoorSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [self registerForKeyboardNotifications];
    [self registerForScannerNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopScanningWithBuiltInCamera];
    
    [self unregisterFromKeyboardNotifications];
    [self unregisterFromScannerNotifications];
}

- (void)updateCameraView
{
    if ([self shouldUseBuiltInCamera])
        [self showCameraPreviewAnimated:YES];
    else
        [self hideCameraPreviewAnimated:YES];
}

- (TXHInfineaManger *)infineaManager
{
    if (!_infineaManager)
    {
        _infineaManager = [[TXHInfineaManger alloc] init];
    }
    return  _infineaManager;
}

#pragma mark - built-in camera helpers

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

- (BOOL)shouldUseBuiltInCamera
{
    return ([TXHBarcodeScanner isCameraAvailable] && !self.infineaManager.isScannerConnected);
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

#pragma mark - infinea scanner notifications

- (void)registerForScannerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scannerConnectionDidChange:) name:TXHScannerConnectionStatusDidChangedNotification object:self.infineaManager];
}

- (void)unregisterFromScannerNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self.infineaManager];
}

- (void)scannerConnectionDidChange:(NSNotification *)notification
{
    [self updateCameraView];
}

#pragma mark - keyboard notification

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    NSInteger curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    CGFloat height = keyboardFrame.size.width;

    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:curve
                     animations:^{
                         [self stopScanningWithBuiltInCamera];

                         [self hideCameraPreviewAnimated:NO];
                         
                         self.bottomLabelConstraint.constant = 30;
                         self.bottomConstraint.constant = height;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;

    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:curve
                      animations:^{
                          if ([self shouldUseBuiltInCamera])
                              [self showCameraPreviewAnimated:NO];
                        
                          self.bottomConstraint.constant = 0;
                          self.bottomLabelConstraint.constant = 100;

                          [self.view layoutIfNeeded];
                      }
                     completion:^(BOOL finished) {
                         [self startScanningWithBuiltInCamera];
                     }];
}

#pragma mark - update UI

- (void)showCameraPreviewAnimated:(BOOL)aniamted
{
    if (aniamted)
        [UIView animateWithDuration:CAMERA_PREVIEW_ANIMATION_DURATION
                         animations:^{
                             self.cameraPreviewViewHeightConstraint.constant = 300.0;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             [self startScanningWithBuiltInCamera];
                         }];
    else
    {
        self.cameraPreviewViewHeightConstraint.constant = 300.0;
        [self startScanningWithBuiltInCamera];
    }
}

- (void)hideCameraPreviewAnimated:(BOOL)aniamted
{
    if (aniamted)
        [UIView animateWithDuration:CAMERA_PREVIEW_ANIMATION_DURATION
                         animations:^{
                             self.cameraPreviewViewHeightConstraint.constant = 0.0;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             [self stopScanningWithBuiltInCamera];
                         }];
    else
    {
        self.cameraPreviewViewHeightConstraint.constant = 0.0;
        [self stopScanningWithBuiltInCamera];
    }
}

#pragma mark - BarcodeViewControllerDelegate

- (void)scanViewController:(TXHBarcodeScanner *)barcodeScaner didSuccessfullyScan:(NSString *)scannedValue
{
    @synchronized (self)
    {
        if ([self canMakeNextScan])
        {
            [self postNotificationWithName:TXHRecognizedQRCodeNotification value:scannedValue];
            [self recordBarcodeScan];
        }
    }
}

- (BOOL)canMakeNextScan
{
    return (!self.lastScanTimestamp || [self.lastScanTimestamp timeIntervalSinceNow] < -2.0);
}

- (void)recordBarcodeScan
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
