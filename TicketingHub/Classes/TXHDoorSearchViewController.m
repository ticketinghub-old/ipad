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
#import "TXHProductsManager.h"

#import "TXHOrderCell.h"
#import <iOS-api/TXHPartialResponsInfo.h>

// TODO: this supposed to be search controller, then all change with no time do it the right way

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

@property (strong, nonatomic) NSMutableArray *orders;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TXHPartialResponsInfo *paginationInfo;
@property (assign, nonatomic, getter = isLoadingData) BOOL loadingData;

@property (copy, nonatomic) NSString *searchQuery;

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
    self.scannersManager.delegate = self;
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
    self.scannersManager.delegate = nil;
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


-(void)setSearchQuery:(NSString *)searchQuery
{
    _searchQuery = searchQuery;
    
    [self resetOrders];
}

- (void)resetOrders
{
    self.paginationInfo = nil;
    [self.orders removeAllObjects];
    [self.tableView reloadData];

    [self reloadOrders];
}

- (NSMutableArray *)orders
{
    if (!_orders)
        _orders = [NSMutableArray array];
    
    return _orders;
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

- (void)reloadOrders
{
    static NSInteger counter = 0;
    __block NSInteger blockCounter = ++counter;
    __weak typeof(self) wself = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (counter != blockCounter)
            return;
        
        wself.loadingData = YES;
        [wself.productsManger getOrderForQuery:self.searchQuery
                                paginationInfo:self.paginationInfo
                                    completion:^(TXHPartialResponsInfo *info, NSArray *orders, NSError *error) {
                                        wself.loadingData    = NO;
                                        
                                        if (counter != blockCounter)
                                            return;
                                        
                                        wself.paginationInfo = info;
        
                                        [wself addOders:orders];
                                    }];
    });
}

- (void)addOders:(NSArray *)orders
{
    [self.orders addObjectsFromArray:orders];
    [self.tableView reloadData];
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

- (IBAction)searchFieldEditingChanged:(UITextField *)textField
{
    self.searchQuery = textField.text;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXHOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    
    TXHOrder *order = [self orderAtIndexPath:indexPath];
    
    [cell setOrderReference:order.reference];
    [cell setPrice:[self.productsManger priceStringForPrice:order.total]];
    [cell setGuestCount:0];
    [cell setAttendingCount:0];
    
    if (self.paginationInfo.hasMore && !self.loadingData && indexPath.row == [self.orders count] - 1 )
        [self reloadOrders];
    
    return cell;
}

- (TXHOrder *)orderAtIndexPath:(NSIndexPath *)indexPath
{
    return self.orders[indexPath.row];
}

#pragma mark - UITableViewDelegate


@end
