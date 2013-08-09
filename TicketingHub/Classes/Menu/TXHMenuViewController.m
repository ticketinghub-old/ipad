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

@interface TXHMenuViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHandSpace;
@property (weak, nonatomic) IBOutlet UIView *menuContainer;
@property (weak, nonatomic) IBOutlet UIView *tabContainer;

@property (strong, nonatomic) UITapGestureRecognizer  *tapRecogniser;

@property (assign, nonatomic) BOOL  loggedIn;

@end

@implementation TXHMenuViewController

#pragma mark - Set up and tear down

+ (void)initialize {
    // As this is instantiated early in the app's lifecycle, set up the initial user defaults here
    NSDictionary *defaultsDictionary = @{TXHUserDefaultsLastUserKey : @""};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDictionary];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.leftHandSpace.constant = -self.menuContainer.bounds.size.width;

    [self standUpCoreDataStack];

    [self performSegueWithIdentifier:@"modalLogin" sender:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.4f delay:0.15f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.leftHandSpace.constant = 0.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:NOTIFICATION_MENU_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu:) name:NOTIFICATION_TOGGLE_MENU object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Superclass overrides

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    [self toggleMenu:nil];
}

#pragma mark Actions

- (IBAction)toggleMenu:(id)sender {
    [UIView animateWithDuration:0.40f animations:^{
        if (self.leftHandSpace.constant == 0.0f) {
            self.leftHandSpace.constant = -self.menuContainer.bounds.size.width;
        } else {
            self.leftHandSpace.constant = 0.0f;
        }
        [self.view layoutIfNeeded];
    }];
}

//- (IBAction)mySegueHandler:(UIStoryboardSegue *)sender {
//  // Do some interesting stuff
//  TXHLoginViewController *controller = sender.sourceViewController;
//  [controller dismissViewControllerAnimated:YES completion:nil];
//  [UIView animateWithDuration:0.5
//                   animations:^{
//
//                     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//                   }
//                   completion:^(BOOL finished){
//                     self.loggedIn = finished;
//                   }];
//  [self.navigationController popViewControllerAnimated:NO];
//}

#pragma mark Notifications

- (void)logout:(NSNotification *)notification {
    self.loggedIn = YES;
    [self performSegueWithIdentifier:@"reLogin" sender:self];
}

@end
