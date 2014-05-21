//
//  TXHProductListController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHProductListController.h"

#import "TXHProductsManager.h"
#import "FetchedResultsControllerDataSource.h"

static void * const kUserFullNameKVOContext = (void*)&kUserFullNameKVOContext;

@interface TXHProductListController () <UITableViewDelegate>

@property (strong, nonatomic) FetchedResultsControllerDataSource *tableViewDataSource;

@property (weak, nonatomic) IBOutlet UIView      *logoutView;
@property (weak, nonatomic) IBOutlet UIButton    *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel     *headerViewLabel;

@end

@implementation TXHProductListController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self registerForProductChangesNotifications];

    [self setHeaderTitle:NSLocalizedString(@"Venues", @"Title for the list of venues")];
    
    [self updateLogoutButtonTitle];
    [self setupDataSource];
}

- (void)dealloc
{
    [self unregisterFromCurrentUserFullNameChanges];
    [self unregisterFromProductChangesNotifications];
}

#pragma mark - accessors

- (void)setUser:(TXHUser *)user
{
    [self unregisterFromCurrentUserFullNameChanges];
    
    _user = user;
    
    if (_user)
        [self registerForCurrentUserFullNameChanges];
}

- (void)setProductsManager:(TXHProductsManager *)productsManager
{
    _productsManager = productsManager;
    
    [self setupDataSource];
}

#pragma mark - notyfications

- (void)registerForProductChangesNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedProductChanged:) name:TXHProductsChangedNotification object:nil];
}

- (void)unregisterFromProductChangesNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductsChangedNotification object:nil];
}

- (void)registerForCurrentUserFullNameChanges
{
    [self.user addObserver:self
                forKeyPath:@"fullName"
                   options:NSKeyValueObservingOptionNew
                   context:kUserFullNameKVOContext];
}

- (void)unregisterFromCurrentUserFullNameChanges
{
    [self.user removeObserver:self forKeyPath:@"fullName" context:kUserFullNameKVOContext];
}

#pragma mark - notifications

- (void)selectedProductChanged:(NSNotification *)note
{
    TXHProduct *product = [note userInfo][TXHSelectedProductKey];
    
    NSIndexPath *indexPath = [self.tableViewDataSource indexPathForItem:product];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - setup

- (void)setupDataSource
{
    if (!self.productsManager)
        return;
    
    NSString *cellIdentifier = @"ProductCellIdentifier";
    __weak typeof(self) wself = self;
    
    NSManagedObjectContext *context = self.productsManager.txhManager.client.managedObjectContext;
    NSFetchedResultsController *fetchedController = [TXHProductsManager productsFetchedResultsControllerWithManagedContext:context];
    
    self.tableViewDataSource = [[FetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedController
                                                                                                  tableView:self.tableView
                                                                                             cellIdentifier:cellIdentifier
                                                                                         configureCellBlock:^(id cell, id item) {
                                                                                             [wself configureCell:cell withItem:item];
                                                                                         }];
    self.tableView.dataSource = self.tableViewDataSource;
    
    [self reloadData];
}

- (void)reloadData
{
    NSError *error;
    BOOL success = [self.tableViewDataSource performFetch:&error];
    
    if (!success) {
        DLog(@"Could not perform fetch because: %@", error);
    }
    
    [self selectFirstProduct];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TXHProduct *product = [self.tableViewDataSource itemAtIndexPath:indexPath];

    [self.productsManager setSelectedProduct:product];
}

#pragma mark - Cell configuration

- (void)configureCell:(UITableViewCell *)cell withItem:(id)item
{
    if ([item isKindOfClass:[TXHProduct class]])
        cell.textLabel.text = [(TXHProduct *)item name];
    else
        cell.textLabel.text = nil;
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kUserFullNameKVOContext)
    {
        [self updateLogoutButtonTitle];
        return;
    }

    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)updateLogoutButtonTitle
{
    [self setLogoutButtonTitle:self.user.fullName];
}

#pragma mark Action methods
    
- (IBAction)logout:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(logOut:) to:nil from:self forEvent:nil];
}

#pragma mark - Private methods

- (void)setHeaderTitle:(NSString *)title
{
    self.headerViewLabel.text = title;
}

- (void)setLogoutButtonTitle:(NSString *)title
{
    NSString *logoutTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Logout", nil), title];
    [self.logoutButton setTitle:logoutTitle
                       forState:UIControlStateNormal];
}

- (void)selectFirstProduct
{
    NSArray *allProducts = [self.tableViewDataSource allItems];
    TXHProduct *product = [allProducts firstObject];
    self.productsManager.selectedProduct = product;
}

@end
