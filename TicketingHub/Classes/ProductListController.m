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
#import "TXHProductsManager.h"
#import "TXHTicketingHubManager.h"
#import "FetchedResultsControllerDataSource.h"

static void * const kUserFullNameKVOContext = (void*)&kUserFullNameKVOContext;

@interface ProductListController () <UITableViewDelegate>


@property (strong, nonatomic) FetchedResultsControllerDataSource *tableViewDataSource;

@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;

@property (nonatomic, strong) TXHUser *user;

@end

@implementation ProductListController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setHeaderTitle:NSLocalizedString(@"Venues", @"Title for the list of venues")];
    
    self.user = [TXHTICKETINHGUBCLIENT currentUser];
    
    [self setLogoutButtonTitle:self.user.fullName];
    
    [self.user addObserver:self
                  forKeyPath:@"fullName"
                     options:NSKeyValueObservingOptionNew
                     context:kUserFullNameKVOContext];
    
    NSError *error;
    BOOL success = [self.tableViewDataSource performFetch:&error];

    if (!success) {
        DLog(@"Could not perform fetch because: %@", error);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[TXHTICKETINHGUBCLIENT currentUser] removeObserver:self forKeyPath:@"fullName" context:@"user.fullName"];
}

#pragma mark - setup

- (void)setupDataSource
{
    NSString *cellIdentifier = @"ProductCellIdentifier";
    self.tableViewDataSource = [[FetchedResultsControllerDataSource alloc] initWithFetchedResultsController:[TXHProductsManager productsFetchedResultsController]
                                                                                                  tableView:self.tableView
                                                                                             cellIdentifier:cellIdentifier
                                                                                         configureCellBlock:^(id cell, id item) {
                                                                                             [self configureCell:cell withItem:item];
                                                                                         }];
    self.tableView.dataSource = self.tableViewDataSource;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TXHProduct *product = [self.tableViewDataSource itemAtIndexPath:indexPath];
    
    [TXHPRODUCTSMANAGER setSelectedProduct:product];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kUserFullNameKVOContext) {
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
