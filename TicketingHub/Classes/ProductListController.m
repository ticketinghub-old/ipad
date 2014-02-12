//
//  ProductListController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "ProductListController.h"

#import <iOS-api/iOS-api.h>

#import "ProductListControllerNotifications.h"

#import "TXHCommonNames.h"
#import "TXHTicketingHubManager.h"

// Declaration of strings declared in ProductListControllerNotifications.h
NSString * const TXHProductChangedNotification = @"TXHProductChangedNotification";
NSString * const TXHSelectedProduct = @"TXHSelectedProduct";

@interface ProductListController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly, nonatomic) TXHUser *user;
@property (strong, nonatomic) NSDateFormatter *isoDateFormatter;

@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *headerViewLabel;

@end

@implementation ProductListController {
    NSManagedObjectContext *_managedObjectContext;
    TXHUser *_user;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [self customBackgroundColour];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self setHeaderTitle:NSLocalizedString(@"Venues", @"Title for the list of venues")];
    [self setLogoutButtonTitle:self.user.fullName];

    [_user addObserver:self forKeyPath:@"fullName" options:NSKeyValueObservingOptionNew context:@"user.fullName"];

    NSError *error;
    BOOL success = [self.fetchedResultsController performFetch:&error];

    if (!success) {
        DLog(@"Could not perform fetch because: %@", error);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.user removeObserver:self forKeyPath:@"fullName" context:@"user.fullName"];

    self.fetchedResultsController = nil;
    _user = nil;
    _managedObjectContext = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

#pragma mark - Custom accessor

- (NSFetchedResultsController *)fetchedResultsController {
    // lazily loaded.
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHProduct entityName]];
        // Since the only products are those attached to the supplier (user), there is no need for a predicate
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:TXHProductAttributes.name ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];

        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }

    return _fetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = TXHTICKETINHGUBCLIENT.managedObjectContext;
    }

    return _managedObjectContext;
}

- (NSDateFormatter *)isoDateFormatter {
    if (!_isoDateFormatter) {
        _isoDateFormatter = [NSDateFormatter new];
        [_isoDateFormatter setDateFormat:@"yyyy-MM-dd"];
    }

    return _isoDateFormatter;
}

#pragma mark - NSFetchedResultsController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]  withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate: {
            UITableViewCell *changedCell = [tableView cellForRowAtIndexPath:indexPath];
            changedCell.textLabel.text = ((TXHProduct *)[controller objectAtIndexPath:indexPath]).name;
            break;
        }

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    cell.backgroundColor = [self customBackgroundColour];
    
    TXHProduct *product = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = product.name;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXHProduct *product = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [self fetchAvailabilitiesForNextThreeMonthsForProduct:product];
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHProductChangedNotification object:self userInfo:@{TXHSelectedProduct: product}];
}

#pragma mark - Custom accessors

- (TXHUser *)user {
    if (!_user) {
        NSFetchRequest *userRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHUser entityName]];

        NSError *error;
        NSArray *users = [self.managedObjectContext executeFetchRequest:userRequest error:&error];

        if (!users) {
            DLog(@"Unable to fetch users because: %@", error);
        }

        _user = [users firstObject];

    }

    return _user;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == @"user.fullName") {
        [self setLogoutButtonTitle:change[NSKeyValueChangeNewKey]];
        return;
    }

    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark Action methods

- (IBAction)logout:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(logOut:) to:nil from:self forEvent:nil];
}

#pragma mark - Private methods

// Set the string to be displayed in header view
- (void)setHeaderTitle:(NSString *)title {
    self.headerViewLabel.text = title;
}

- (void)setLogoutButtonTitle:(NSString *)title {
    [self.logoutButton setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Logout", @"Logout the current user"), title] forState:UIControlStateNormal];
}

// Get the colour to use as a background
- (UIColor *)customBackgroundColour {
    static UIColor *customBackgroundColour = nil;

    if (!customBackgroundColour) {
        customBackgroundColour = [UIColor colorWithRed:14.0f / 255.0f
                                                 green:47.0f / 255.0f
                                                  blue:67.0f / 255.0f
                                                 alpha:1.0f];
    }

    return customBackgroundColour;
}

- (void)fetchAvailabilitiesForNextThreeMonthsForProduct:(TXHProduct *)product {
    NSDate *today = [NSDate date];

    NSDateComponents *components = [NSDateComponents new];
    [components setMonth:3];

    NSDate *forwardDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:kNilOptions];
    NSString *forwardDateString = [self.isoDateFormatter stringFromDate:forwardDate];

    [self fetchAvailabilitiesToDate:forwardDateString forProduct:product];
}

- (void)fetchAvailabilitiesForNextYearForProduct:(TXHProduct *)product {
    // Check against last update time so that this isn't called too often
    // NSTimeInterval checkInterval = 60 * 5.0; // Not using components, as 5 minutes is the absolute time between checks.

    NSDateComponents *components = [NSDateComponents new];
    [components setYear:1];

    NSDate *forwardDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:kNilOptions];
    NSString *forwardDateString = [self.isoDateFormatter stringFromDate:forwardDate];

    [self fetchAvailabilitiesToDate:forwardDateString forProduct:product];

}

- (void)fetchAvailabilitiesToDate:(NSString *)isoDateString forProduct:(TXHProduct *)product {
    [TXHTICKETINHGUBCLIENT availabilitiesForProduct:product from:nil to:isoDateString completion:^(NSArray *availabilities, NSError *error) {
        DLog(@"Availability update to %@ for Product: %@", isoDateString, product.name);
    }];
}

@end
