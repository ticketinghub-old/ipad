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
#import "TXHMenuController.h"
#import "TXHUserDefaultsKeys.h"

// Segue Identifiers
static NSString * const ModalLoginSegue = @"ModalLogin";
static NSString * const ReLoginSegue = @"ReLogin";
static NSString * const MenuContainerEmbedSegue = @"MenuContainerEmbed";
static NSString * const DetailContainerEmbedSegue = @"DetailContainerEmbed";

@interface TXHMenuViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHandSpace;
@property (weak, nonatomic) IBOutlet UIView *menuContainer;
@property (weak, nonatomic) IBOutlet UIView *tabContainer;

@property (strong, nonatomic) UITapGestureRecognizer  *tapRecogniser;

@end

@implementation TXHMenuViewController

#pragma mark - Set up and tear down

+ (void)initialize {
    // As this is instantiated early in the app's lifecycle, set up the initial user defaults here
    NSDictionary *defaultsDictionary = @{TXHUserDefaultsLastUserKey : @""};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDictionary];
}

- (void)awakeFromNib {
    // Stand up the stack as early as possible, so that the moc is set up in time for the embed segues.
    [self standUpCoreDataStack];
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

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrHideVenueList:) name:NOTIFICATION_TOGGLE_MENU object:nil];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Superclass overrides

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = segue.identifier;

    // The segues for which a managed object context needs to be set on the destination.
    NSArray *coreDataSegues = @[ModalLoginSegue, ReLoginSegue, MenuContainerEmbedSegue];

    if ([coreDataSegues containsObject:segueIdentifier]) {
        // Doing it this way saves casting, and probably not worth setting up a protocol at this stage.
        if ([segue.destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
            [segue.destinationViewController setManagedObjectContext:self.managedObjectContext];
        }
    }
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
