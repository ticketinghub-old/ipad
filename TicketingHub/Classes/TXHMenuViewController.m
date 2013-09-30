//
//  TXHMenuViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMenuViewController.h"

#import "DCTCoreDataStack.h"
#import "TXHCommonNames.h"
#import "TXHLoginViewController.h"
#import "TXHMainViewController.h"
#import "TXHMenuController.h"
#import "TXHNetworkController.h"
#import "TXHUserDefaultsKeys.h"
#import "TXHVenueMO.h"

// Segue Identifiers
static NSString * const ModalLoginSegue = @"ModalLogin";
static NSString * const ReLoginSegue = @"ReLogin";
static NSString * const MenuContainerEmbedSegue = @"MenuContainerEmbed";
static NSString * const DetailContainerEmbedSegue = @"DetailContainerEmbed";

@interface TXHMenuViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UITapGestureRecognizer  *tapRecogniser;
@property (weak, nonatomic) TXHVenueMO *currentVenue;
@property (strong, nonatomic) TXHNetworkController *networkController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHandSpace;
@property (weak, nonatomic) IBOutlet UIView *menuContainer;
@property (weak, nonatomic) IBOutlet UIView *tabContainer;


@end

@implementation TXHMenuViewController

#pragma mark - Set up and tear down

+ (void)initialize {
    // As this is instantiated early in the app's lifecycle, set up the initial user defaults here
    NSDictionary *defaultsDictionary = @{TXHUserDefaultsLastUserKey : @""};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDictionary];
}

- (void)awakeFromNib {
    // Stand up the stack and network controller as early as possible so they are available for the embed segues.
    [self standUpCoreDataStack];
    self.networkController = [[TXHNetworkController alloc] initWithManagedObjectContext:self.managedObjectContext];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.leftHandSpace.constant = -self.menuContainer.bounds.size.width;

    [self performSegueWithIdentifier:ModalLoginSegue sender:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.leftHandSpace.constant = -self.menuContainer.bounds.size.width;
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.4f delay:0.15f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.leftHandSpace.constant = 0.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Superclass overrides

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = segue.identifier;
    id destinationViewController = segue.destinationViewController;

    // The segues for which a managed object context needs to be set on the destination.
    NSArray *coreDataSegues = @[ModalLoginSegue, ReLoginSegue, MenuContainerEmbedSegue];

    // The segues for which a network controller needs to be set.
    NSArray *networkControllerSegues = @[ModalLoginSegue, ReLoginSegue];

    // These controllers all need to have an NSManagedObjectContext set
    if ([coreDataSegues containsObject:segueIdentifier]) {
        if ([destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
            [destinationViewController setManagedObjectContext:self.managedObjectContext];
        }
    }

    if ([networkControllerSegues containsObject:segueIdentifier]) {
        if ([destinationViewController respondsToSelector:@selector(setNetworkController:)]) {
            [destinationViewController setNetworkController:self.networkController];
        }
    }

    if ([segueIdentifier isEqualToString:MenuContainerEmbedSegue]) {
        TXHMenuController *menuController = (TXHMenuController *)destinationViewController;
        menuController.venueSelectionDelegate = self;
    }
}

#pragma mark - Delegate Methods

#pragma mark TXHVenueSelectionProtocol methods

- (void)setSelectedVenue:(TXHVenueMO *)venueMO {
    self.currentVenue = venueMO;
    [self showOrHideVenueList:nil];
}


#pragma mark - Private methods

- (void)standUpCoreDataStack {
    NSDictionary *options = @{DCTCoreDataStackExcludeFromBackupStoreOption : @YES,
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES};

    NSURL *documentDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDirectoryURL URLByAppendingPathComponent:@"TicktingHub.sqlite"];

    DCTCoreDataStack *coreDataStack = [[DCTCoreDataStack alloc] initWithStoreURL:storeURL storeType:NSSQLiteStoreType storeOptions:options modelConfiguration:nil modelURL:nil];

    self.managedObjectContext = coreDataStack.managedObjectContext;
}

- (void)tap:(UITapGestureRecognizer *)recogniser {
    [self showOrHideVenueList:nil];
}

#pragma mark Actions

- (IBAction)showOrHideVenueList:(id)sender {
    [UIView animateWithDuration:0.40f animations:^{
        if (self.leftHandSpace.constant == 0.0f) {
            self.leftHandSpace.constant = -self.menuContainer.bounds.size.width;
        } else {
            self.leftHandSpace.constant = 0.0f;
        }
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)logOut:(id)sender {
    [self performSegueWithIdentifier:ReLoginSegue sender:self];
}

@end
