//
//  MainViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "MainViewController.h"

#import <iOS-api/iOS-api.h>
#import "DataController.h"
#import "SalesOrDoormanViewController.h"
#import "TXHCommonNames.h"
#import "TXHLoginViewController.h"
#import "TXHUserDefaultsKeys.h"
#import "TXHVenueMO.h"
#import "ProductListController.h"
#import "ProductListControllerNotifications.h"

// Segue Identifiers
static NSString * const VenueListContainerEmbedSegue = @"VenueListContainerEmbed";
static NSString * const SalesOrDoormanContainerEmbedSegue = @"SalesOrDoormanContainerEmbed";

@interface MainViewController ()

@property (strong, nonatomic) TXHTicketingHubClient *ticketingHubClient;
@property (strong, nonatomic) UITapGestureRecognizer  *tapRecogniser;
@property (weak, nonatomic) TXHVenueMO *selectedVenue;
@property (strong, nonatomic) DataController *dataController;
@property (strong, nonatomic) SalesOrDoormanViewController *salesOrDoormanViewController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHandSpace;
@property (weak, nonatomic) IBOutlet UIView *venueListContainer;
@property (weak, nonatomic) IBOutlet UIView *salesOrDoormanContainer;


@end

@implementation MainViewController

#pragma mark - Set up and tear down

+ (void)initialize {
    // As this is instantiated early in the app's lifecycle, set up the initial user defaults here
    NSDictionary *defaultsDictionary = @{TXHUserDefaultsLastUserKey : @""};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDictionary];
}

- (void)awakeFromNib {
    // Stand up the client library early on so it is available for the segues.
    self.ticketingHubClient = [[TXHTicketingHubClient alloc] initWithStoreURL:[[self class] storeURL]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.leftHandSpace.constant = -self.venueListContainer.bounds.size.width;

    [self presentLoginViewControllerAnimated:NO completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueChanged:) name:TXHProductChangedNotification object:nil];
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
        ProductListController *productListController = (ProductListController *)destinationViewController;
        productListController.ticketingHubClient = self.ticketingHubClient;
    }

    if ([segueIdentifier isEqualToString:SalesOrDoormanContainerEmbedSegue]) {
        // The storyboard has the this container loading a navigation controller, don't know why.
        UINavigationController *navController = (UINavigationController *)destinationViewController;
        self.salesOrDoormanViewController = [navController viewControllers][0];
        self.salesOrDoormanViewController.selectedVenue = self.selectedVenue;
    }

}

#pragma mark - Public methods

- (void)presentLoginViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion {
    TXHLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:LoginViewControllerStoryboardIdentifier];
    loginViewController.ticketingHubClient = self.ticketingHubClient;
    
    [self presentViewController:loginViewController animated:animated completion:completion];
}

#pragma mark - Delegate Methods

#pragma mark VenueSelectionProtocol methods

#pragma mark - NotificationHandlers
- (void)venueChanged:(NSNotification *)notification {
    self.selectedVenue = [notification userInfo][TXHSelectedVenue];
    [self showOrHideVenueList:nil];
}

#pragma mark - Private methods

// Convenience method to return the URL for the Core Data Store
+ (NSURL *)storeURL {
    NSURL *documentDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDirectoryURL URLByAppendingPathComponent:@"TicktingHub.sqlite"];

    return storeURL;
}

- (void)tap:(UITapGestureRecognizer *)recogniser {
    [self showOrHideVenueList:nil];
}

#pragma mark Actions

- (IBAction)showOrHideVenueList:(id)sender {
    [UIView animateWithDuration:0.40f animations:^{
        if (self.leftHandSpace.constant == 0.0f) {
            self.leftHandSpace.constant = -self.venueListContainer.bounds.size.width;
        } else {
            self.leftHandSpace.constant = 0.0f;
        }
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)logOut:(id)sender {
    [self presentLoginViewControllerAnimated:YES completion:nil];
}

@end
