//
//  SalesOrDoormanViewController.m
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesmanDoormanContainerViewController.h"
@import CoreData;

#import "TXHOrderManager.h"
#import "TXHProductsManager.h"

#import "TXHDoorMainViewController.h"
#import "TXHSalesMainViewController.h"

#import "TXHEmbeddingSegue.h"
#import "UIResponder+FirstResponder.h"
#import "UIColor+TicketingHub.h"
#import "UIFont+TicketingHub.h"
#import "TXHActivityLabelView.h"
#import <Block-KVO/MTKObserving.h>


@interface TXHSalesmanDoormanContainerViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UIView             *contentDetailView;

@property (strong, nonatomic) TXHProduct      *selectedProduct;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (weak, nonatomic) UIViewController *currentContentController;

@property (strong, nonatomic) UIBarButtonItem *rightItem;

@end

@implementation TXHSalesmanDoormanContainerViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self registerForProductChanges];
    [self setupNavigationBar];
    [self selectMode:nil];
    [self updateUI];
}

- (void)dealloc
{
    [self unregisterFromProductChanges];
    [self removeAllObservations];
}

- (void)registerForProductChanges
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productChanged:) name:TXHProductsChangedNotification object:nil];
}

- (void)unregisterFromProductChanges
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductsChangedNotification object:nil];
}


#pragma mark Actions

- (IBAction)selectMode:(id)__unused sender
{
    [[UIResponder currentFirstResponder] resignFirstResponder];

    NSString *storyboardIdentifier          = [self storyboardIdentifierForSegmentIndex:self.modeSelector.selectedSegmentIndex];
    UIViewController *destinationController = [self initialControllerForStoryboardIdentifier:storyboardIdentifier];
    
    TXHEmbeddingSegue *segue = [[TXHEmbeddingSegue alloc] initWithIdentifier:storyboardIdentifier
                                                                      source:self
                                                                 destination:destinationController];
    
    segue.containerView      = self.contentDetailView;
    segue.previousController = self.currentContentController;
    
    self.currentContentController = segue.destinationViewController;

    [segue perform];
}

- (void)setCurrentContentController:(UIViewController *)currentContentController
{
    _currentContentController = currentContentController;
    
    [self map:@keypath(self.currentContentController.navigationItem.rightBarButtonItem) to:@keypath(self.rightItem) null:nil];
}

- (void)setRightItem:(UIBarButtonItem *)rightItem
{
    _rightItem = rightItem;
    
    if (!rightItem)
        _rightItem = [[UIBarButtonItem alloc]  initWithCustomView:self.modeSelector];
    
    self.navigationItem.rightBarButtonItem = _rightItem;
}

- (UIViewController *)initialControllerForStoryboardIdentifier:(NSString *)storyboardIdentifier
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardIdentifier bundle:nil];
    UIViewController *initialController = [storyboard instantiateInitialViewController];
    
    if ([storyboardIdentifier isEqualToString:@"Doorman"])
    {
        TXHDoorMainViewController *doorMainController = (TXHDoorMainViewController *)initialController;
        doorMainController.prodctManager = self.productManager;
    }
    else if ([storyboardIdentifier isEqualToString:@"Salesman"])
    {
        TXHSalesMainViewController *salesMainController = (TXHSalesMainViewController *)initialController;
        salesMainController.productManager = self.productManager;
        TXHORDERMANAGER.txhManager = self.productManager.txhManager;
        salesMainController.orderManager   = TXHORDERMANAGER;
    }
    
    return initialController;
}

- (NSString *)storyboardIdentifierForSegmentIndex:(NSInteger)segmentIndex
{
    switch (segmentIndex)
    {
        case 0: return @"Salesman";
        case 1: return @"Doorman";
    }
    return nil;
}

#pragma mark - Setters / Getters

- (void)setSelectedProduct:(TXHProduct *)selectedProduct
{
    _selectedProduct = selectedProduct;
    
    [self updateUI];
}

- (void)setProductManager:(TXHProductsManager *)productManager
{
    _productManager = productManager;
    
    self.selectedProduct = productManager.selectedProduct;
}

#pragma mark - Notification handlers

- (void)productChanged:(NSNotification *)notification
{
    self.selectedProduct = [notification userInfo][TXHSelectedProductKey];
}

#pragma mark - Private

- (void)setupNavigationBar
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor txhDarkBlueColor]];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_small"]];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

- (IBAction)toggleMenu:(id)__unused sender
{
    [[UIResponder currentFirstResponder] resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(toggleVenueList) to:nil from:self forEvent:nil];
}

#pragma mark UI stuff

- (void)updateUI
{
    __weak typeof(self) wself = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [wself updateActivityIndicator];
        [wself updateTitle];
        [wself updateModeSelector];
    });
}

- (void)updateActivityIndicator
{
    if (!self.selectedProduct)
        [self.activityView showWithMessage:NSLocalizedString(@"SD_NO_AVAILABILITIES_LABEL", nil) indicatorHidden:YES];
    else
        [self.activityView hide];
}

- (void)updateTitle
{
    self.title = self.selectedProduct ? self.selectedProduct.name : @"";
}

- (void)updateModeSelector
{
    [self.modeSelector setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}
                                     forState:UIControlStateNormal];
    [self.modeSelector setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                                     forState:UIControlStateSelected];

    self.modeSelector.tintColor = [UIColor txhBlueColor];
    self.modeSelector.enabled   = (self.selectedProduct != nil);
}

#pragma mark - loading view

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
    {
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    }
    return _activityView;
}



@end
