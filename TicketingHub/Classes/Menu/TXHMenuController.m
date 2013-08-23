//
//  TXHMenuController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMenuController.h"

#import "TXHCommonNames.h"
#import "TXHServerAccessManager.h"
#import "TXHUserMO.h"
#import "TXHVenueMO.h"

@interface TXHMenuController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSArray *venues;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TXHMenuController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *backgroundColor = [UIColor colorWithRed:16.0f / 255.0f
                                               green:46.0f / 255.0f
                                                blue:66.0f / 255.0f
                                               alpha:1.0f];

    self.view.backgroundColor = backgroundColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self.logoutButton setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Logout", @"Logout the current user"), [self userName]] forState:UIControlStateNormal];

    NSError *error;
    BOOL success = [self.fetchedResultsController performFetch:&error];

    if (!success) {
        DLog(@"Could not perform fetch because: %@", error);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Reset the fetched results controller
    self.fetchedResultsController = nil;
}

#pragma mark - Custom accessors

- (NSFetchedResultsController *)fetchedResultsController {
    // lazily loaded.
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHVenueMO entityName]];
        // Since the only venues are those attached to the user, there is no need for a predicate
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:TXHVenueMOAttributes.venueName ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];

        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }

    return _fetchedResultsController;
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
            changedCell.textLabel.text = ((TXHVenueMO *)[controller objectAtIndexPath:indexPath]).venueName;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    TXHVenueMO *venueMO = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = venueMO.venueName;

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.headerView == nil) {
        CGRect frame = tableView.bounds;
        frame.size.height = 64.0f;
        self.headerView = [[UIView alloc] initWithFrame:frame];
        self.headerView.backgroundColor = self.view.backgroundColor;
        NSString *titleString = @"Venues";
        UIFont *font = [UIFont systemFontOfSize:34.0f];
        NSDictionary *attributesDict = @{NSFontAttributeName : font};
        NSAttributedString *attributedTitleString = [[NSAttributedString alloc] initWithString:titleString attributes:attributesDict];
        CGSize titleSize = [attributedTitleString size];

        CGRect titleLabelFrame = CGRectZero;
        titleLabelFrame.origin.x = 17.50f;
        titleLabelFrame.origin.y = self.headerView.bounds.size.height - titleSize.height;
        titleLabelFrame.size = titleSize;

        UILabel *title = [[UILabel alloc] initWithFrame:titleLabelFrame];
        title.backgroundColor = self.headerView.backgroundColor;
        title.textColor = [UIColor whiteColor];
        title.font = font;
        title.text = titleString;
        [self.headerView addSubview:title];
    }
    return self.headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXHVenue *venue = [self.venues objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VENUE_SELECTED object:venue];
}

#pragma mark - Private methods

- (NSString *)userName {
    NSFetchRequest *userRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHUserMO entityName]];

    NSError *error;
    NSArray *users = [self.managedObjectContext executeFetchRequest:userRequest error:&error];

    if (!users) {
        DLog(@"Unable to fetch users because: %@", error);
    }

    TXHUserMO *user = [users lastObject];

    return [user fullName];
}

#pragma mark Action methods

- (IBAction)logout:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(logOut:) to:nil from:self forEvent:nil];
}


@end
