//
//  MainViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "MainViewController.h"

#import "ProductListController.h"
#import "ProductListControllerNotifications.h"

#import "SalesOrDoormanViewController.h"

#import "TXHCommonNames.h"
#import "TXHLoginViewController.h"
#import "TXHSensorView.h"

// Segue Identifiers
static NSString * const VenueListContainerEmbedSegue = @"VenueListContainerEmbed";
static NSString * const SalesOrDoormanContainerEmbedSegue = @"SalesOrDoormanContainerEmbed";

@interface MainViewController () <TXHSensorViewDelegate>

@property (strong, nonatomic) SalesOrDoormanViewController *salesOrDoormanViewController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHandSpace;
@property (weak, nonatomic) IBOutlet UIView *venueListContainer;
@property (weak, nonatomic) IBOutlet UIView *salesOrDoormanContainer;
@property (weak, nonatomic) IBOutlet TXHSensorView *sensorView;

@end

@implementation MainViewController


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.leftHandSpace.constant = -self.venueListContainer.bounds.size.width;
    self.sensorView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productChanged:) name:TXHProductChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.leftHandSpace.constant = -self.venueListContainer.bounds.size.width;
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.4f delay:0.15f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.leftHandSpace.constant = 0.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Superclass overrides

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = segue.identifier;
    id destinationViewController = segue.destinationViewController;

    if ([segueIdentifier isEqualToString:VenueListContainerEmbedSegue]) {
        __unused ProductListController *productListController = (ProductListController *)destinationViewController;
    }

    if ([segueIdentifier isEqualToString:SalesOrDoormanContainerEmbedSegue]) {
        // The storyboard has the this container loading a navigation controller, don't know why.
        UINavigationController *navController = (UINavigationController *)destinationViewController;
        self.salesOrDoormanViewController = [navController viewControllers][0];
    }

}

#pragma mark - Public methods

- (void)presentLoginViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion {
    TXHLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:LoginViewControllerStoryboardIdentifier];

    [self presentViewController:loginViewController animated:animated completion:completion];
}

#pragma mark - Delegate Methods

#pragma mark - NotificationHandlers

- (void)productChanged:(NSNotification *)notification {
    
    [self showOrHideVenueList:nil];
}

#pragma mark - Private methods


#pragma mark Actions

- (IBAction)showOrHideVenueList:(id)sender {
    if (self.leftHandSpace.constant == 0.0f) {
        [self hideVenueListAnimated];
    } else {
        [self showVenueListAnimated];
    }
}

- (IBAction)hideVenueList:(id)sender
{
    [self hideVenueListAnimated];
}

- (void)showVenueListAnimated
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.leftHandSpace.constant = 0.0f;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)hideVenueListAnimated
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.leftHandSpace.constant = -self.venueListContainer.bounds.size.width;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - TXHSensorViewDelegate

- (void)sensorViewDidRecognizeTap:(TXHSensorView *)view
{
    [self hideVenueListAnimated];
}

@end
