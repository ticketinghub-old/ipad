//
//  TXHDoorSearchViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorSearchViewController.h"

#import "TXHBarcodeScanner.h"

@interface TXHDoorSearchViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraPreviewViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (strong, nonatomic) TXHBarcodeScanner *scanner;

@end

@implementation TXHDoorSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scanner = [TXHBarcodeScanner new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.scanner isCameraAvailable])
    {
        self.cameraPreviewViewHeightConstraint.constant = 300.0;
    }
    else
    {
        self.cameraPreviewViewHeightConstraint.constant = 0.0;
    }
    
    [self.view layoutSubviews];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.scanner isCameraAvailable])
    {
        [self.scanner showPreviewInView:self.cameraPreviewView];
        [self.scanner startScanning];
    }
}

@end
