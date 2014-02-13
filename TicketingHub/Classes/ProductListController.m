//
//  ProductListController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "ProductListController.h"

#import "ProductListControllerNotifications.h"

#import "TXHCommonNames.h"
#import "TXHTicketingHubManager.h"
#import "UIColor+TicketingHub.h"
#import "FetchedResultsControllerDataSource.h"

// Declaration of strings declared in ProductListControllerNotifications.h
NSString * const TXHProductChangedNotification = @"TXHProductChangedNotification";
NSString * const TXHSelectedProduct = @"TXHSelectedProduct";

@interface ProductListController () <UITableViewDelegate>


@property (strong, nonatomic) FetchedResultsControllerDataSource *tableViewDataSource;

@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;


@end

@implementation ProductListController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor txhDarkBlueColor];
    
    [self setupDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setHeaderTitle:NSLocalizedString(@"Venues", @"Title for the list of venues")];
    
    [self setLogoutButtonTitle:[TXHTICKETINHGUBCLIENT currentUser].fullName];

    NSError *error;
    BOOL success = [self.tableViewDataSource performFetch:&error];

    if (!success) {
        DLog(@"Could not perform fetch because: %@", error);
    }
}

#pragma mark - setup

- (void)setupDataSource
{
    NSString *cellIdentifier = @"ProductCellIDentifier";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableViewDataSource = [[FetchedResultsControllerDataSource alloc] initWithFetchedResultsController:[self fetchedResultsController]
                                                                                                  tableView:self.tableView
                                                                                             cellIdentifier:cellIdentifier
                                                                                         configureCellBlock:^(id cell, id item) {
                                                                                             [self configureCell:cell withItem:item];
                                                                                         }];
    self.tableView.dataSource = self.tableViewDataSource;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    NSFetchedResultsController *fetchedResultsController;
    
    if (!fetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHProduct entityName]];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:TXHProductAttributes.name ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];

        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:TXHTICKETINHGUBCLIENT.managedObjectContext
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
    }

    return fetchedResultsController;
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TXHProduct *product = [self.tableViewDataSource itemAtIndexPath:indexPath];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHProductChangedNotification
                                                        object:self
                                                      userInfo:@{TXHSelectedProduct: product}];
}

#pragma mark - Cell configuration

- (void)configureCell:(UITableViewCell *)cell withItem:(id)item
{
    if ([item isKindOfClass:[TXHProduct class]])
    {
        cell.textLabel.text = [(TXHProduct *)item name];
    }
    else
    {
        cell.textLabel.text = nil;
    }
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
    [self.logoutButton setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Logout", @"Logout the current user"), title]
                       forState:UIControlStateNormal];
}


@end
