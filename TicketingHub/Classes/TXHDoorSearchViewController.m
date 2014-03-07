//
//  TXHDoorSearchViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorSearchViewController.h"

#import "TXHBarcodeScanner.h"

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

@property (strong, nonatomic) TXHBarcodeScanner *scanner;
@property (assign, nonatomic) BOOL hasExternalScannerConnected;

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
    
    if ([self shouldUseBuiltInCamera])
        [self showCameraPreviewAnimated:NO];
    else
        [self hideCameraPreviewAnimated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self shouldUseBuiltInCamera])
        [self startScanningWithBuiltInCamera];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopScanningWithBuiltInCamera];
    
    [self unregisterFromKeyboardNotifications];
}

#pragma mark - built-in camera helpers

- (TXHBarcodeScanner *)scanner
{
    if (!_scanner && [self shouldUseBuiltInCamera])
    {
        _scanner = [TXHBarcodeScanner new];
        _scanner.delegate = self;
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

- (void)keyboardWillShow:(NSNotification *)notification {
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

- (void)keyboardWillHide:(NSNotification *)notification {
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
                         }];
    else
    {
        self.cameraPreviewViewHeightConstraint.constant = 300.0;
    }
}

- (void)hideCameraPreviewAnimated:(BOOL)aniamted
{
    if (aniamted)
        [UIView animateWithDuration:CAMERA_PREVIEW_ANIMATION_DURATION
                         animations:^{
                             self.cameraPreviewViewHeightConstraint.constant = 0.0;
                             [self.view layoutIfNeeded];
                         }];
    else
    {
        self.cameraPreviewViewHeightConstraint.constant = 0.0;
    }
}

#pragma mark - BarcodeViewControllerDelegate

- (void)scanViewController:(TXHBarcodeScanner *)barcodeScaner didSuccessfullyScan:(NSString *)scannedValue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHRecognizedQRCodeNotification object:scannedValue];
}


#pragma mark - textField

- (IBAction)searchFieldEditingChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHSearchQueryDidChangeNotification object:self.searchField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
