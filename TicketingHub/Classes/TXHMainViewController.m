//
//  TXHMainViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMainViewController.h"

#import "TXHProductsManagerNotifications.h"
#import "TXHProductsManager.h"
#import "TXHTicketingHubManager.h"

#import "TXHProductListController.h"
#import "TXHSalesmanDoormanContainerViewController.h"

#import "TXHSensorView.h"

@interface TXHMainViewController () <TXHSensorViewDelegate>

@property (weak, nonatomic) IBOutlet UIView             *venueListContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHandSpace;

@property (weak, nonatomic) IBOutlet TXHSensorView      *sensorView;

@property (strong, nonatomic) TXHProductsManager *productManager;

@end

@implementation TXHMainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sensorView.delegate = self;
    
    [self showVenueListAnimated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self registerForProductChangesNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self unregisterFromProductChangesNotifications];
}

- (void)registerForProductChangesNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productChanged:) name:TXHProductsChangedNotification object:nil];
}

- (void)unregisterFromProductChangesNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductsChangedNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VenueListContainerEmbed"])
    {
        TXHProductListController *productList = segue.destinationViewController;
        productList.productsManager = self.productManager;
        productList.user = [TXHTICKETINHGUBCLIENT currentUser];
    }
    else if ([segue.identifier isEqualToString:@"SalesOrDoormanContainerEmbed"])
    {
        UINavigationController *navController = segue.destinationViewController;
        
        TXHSalesmanDoormanContainerViewController *sdContainer = (TXHSalesmanDoormanContainerViewController *)navController.topViewController;
        sdContainer.productManager = self.productManager;
    }
}

- (TXHProductsManager *)productManager
{
    if (!_productManager)
    {
        _productManager = TXHPRODUCTSMANAGER;
        _productManager.txhManager = [TXHTicketingHubManager sharedManager];
    }
    return _productManager;
}

#pragma mark - NotificationHandlers

- (void)productChanged:(NSNotification *)notification
{
    [self toggleVenueList];
}

#pragma mark Actions

- (BOOL)isVenueListVisible
{
    return (self.leftHandSpace.constant == 0.0f);
}

- (BOOL)isVenueListHidden
{
    return (self.leftHandSpace.constant == -self.venueListContainer.bounds.size.width);
}

- (IBAction)toggleVenueList
{
    if ([self isVenueListVisible])
        [self hideVenueListAnimated];
    else
        [self showVenueListAnimated];
}

- (IBAction)hideVenueList:(id)sender
{
    [self hideVenueListAnimated];
}

- (void)showVenueListAnimated
{
    if (![self isVenueListVisible])
        [self venueListAnimationwithBlock:^{[self showVenueList];}];

}

- (void)hideVenueListAnimated
{
    if (![self isVenueListHidden])
        [self venueListAnimationwithBlock:^{[self hideVenueList];}];
}

- (void)venueListAnimationwithBlock:(void(^)(void))animationBlock
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:animationBlock
                     completion:nil];
}

- (void)hideVenueList
{
    self.leftHandSpace.constant = -self.venueListContainer.bounds.size.width;
    [self.view layoutIfNeeded];
}

- (void)showVenueList
{
    self.leftHandSpace.constant = 0.0f;
    [self.view layoutIfNeeded];
}

#pragma mark - TXHSensorViewDelegate

- (void)sensorViewDidRecognizeTap:(TXHSensorView *)view
{
    [self hideVenueListAnimated];
}

@end
