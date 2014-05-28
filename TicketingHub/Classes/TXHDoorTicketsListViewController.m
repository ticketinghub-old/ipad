//
//  TXHDoorTicketsListViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketsListViewController.h"

#import "TXHDoorSearchViewController.h"
#import "TXHTicketDetailsViewController.h"
#import "TXHDoorOrderViewController.h"

#import "TXHDoorTicketsListHeaderView.h"
#import "TXHDoorTicketCell.h"
#import "TXHActivityLabelView.h"

#import "TXHProductsManager.h"
#import "TXHScanersManager.h"

#import "TXHBorderedButton.h"
#import "TXHTicket+Filter.h"
#import "TXHTicket+Title.h"
#import "TXHOrder+Helpers.h"
#import <UIViewController+BHTKeyboardAnimationBlocks/UIViewController+BHTKeyboardNotifications.h>
#import "TXHRMPickerViewControllerDelegate.h"
#import <iOS-api/TXHPartialResponsInfo.h>

// TODO: almost the same as TXHDoorOrderTicketsListViewController - extract common parts

@interface TXHDoorTicketsListViewController () <TXHTicketDetailsViewControllerDelegate, TXHDoorTicketCellDelegate, UIAlertViewDelegate, TXHScanersManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TXHBorderedButton *toogleAttendingButton;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (strong, nonatomic) TXHScanersManager *scannersManager;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) NSString *searchQuery;

@property (strong, nonatomic) TXHTicket *selectedTicket;
@property (strong, nonatomic) NSMutableSet *ticketsDisabled;

@property (assign, nonatomic, getter = isLoadingData) BOOL loadingData;
@property (assign, nonatomic, getter = isErrorShown) BOOL errorShown;

@property (assign, nonatomic) BOOL hideAttending;

@property (strong, nonatomic) TXHPartialResponsInfo *paginationInfo;

@end

@implementation TXHDoorTicketsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupKeybaordAnimations];
    [self setupScannersManager];
    
    [self reload];
}

- (void)setupScannersManager
{
    self.scannersManager = [[TXHScanersManager alloc] init];
    self.scannersManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self registerForNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self unregisterFromNotifications];
}

//- (void)applyTicketFilter
//{
//    static NSInteger queryCounter = 0;
//    queryCounter++;
//    
//    if (!self.searchQuery.length)
//    {
//        self.filteredTickets = self.tickets;
//        return;
//    }
//    
//    NSInteger bQueryCounter = queryCounter;
//    __weak typeof(self) wself = self;
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSArray *filteredTickets = [TXHTicket filterTickets:wself.tickets withQuery:wself.searchQuery];
//        if (bQueryCounter == queryCounter)
//            dispatch_async(dispatch_get_main_queue(), ^{
//                    wself.filteredTickets = filteredTickets;
//            });
//    });
//}

- (void)setHideAttending:(BOOL)hideAttending
{
    _hideAttending = hideAttending;
    
    [self updateToggleAttendingButton];
    [self reload];
}

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    [self.collectionView reloadData];
}

- (void)setLoadingData:(BOOL)loadingData
{
    _loadingData = loadingData;
    
    [self updateInfoLabel];
}

- (void)setSearchQuery:(NSString *)searchQuery
{
    if (![_searchQuery isEqualToString:searchQuery])
    {
        _searchQuery = searchQuery;
        
        [self reload];
    }
}

//- (void)setSearchQuery:(NSString *)searchQuery
//{
//    _searchQuery = searchQuery;
//    
//    [self applyTicketFilter];
//}

//- (void)setFilteredTickets:(NSArray *)filteredTickets
//{
//    _filteredTickets = filteredTickets;
////    [self updateInfoLabel];
//    [self.tableView reloadData];
//}

//- (void)setLoadingData:(BOOL)loadingData
//{
//    _loadingData = loadingData;
//    
////    [self updateInfoLabel];
//}

- (NSMutableSet *)ticketsDisabled
{
    if (!_ticketsDisabled)
        _ticketsDisabled = [NSMutableSet new];

    return _ticketsDisabled;
}

- (NSUInteger)attendingTicketsFrom:(NSArray *)tickets
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attendedAt != NULL"];
    return [[tickets filteredArrayUsingPredicate:predicate] count];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TicketDetail"])
    {
        TXHTicketDetailsViewController *detailController = segue.destinationViewController;
        detailController.delegate       = self;
        detailController.productManager = self.productManager;
        detailController.ticket         = self.selectedTicket;
    }
    else if ([segue.identifier isEqualToString:@"TicketOrder"])
    {
        TXHDoorOrderViewController *orderViewController = segue.destinationViewController;
        [orderViewController setTicket:self.selectedTicket andProductManager:self.productManager];
    }
}

- (TXHTicket *)ticketAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tickets[indexPath.item];
}

- (void)setupKeybaordAnimations
{
    __weak typeof(self) wself = self;
    
    [self setKeyboardWillShowAnimationBlock:^(CGRect keyboardFrame) {
        CGFloat height = keyboardFrame.size.width;
        wself.collectionView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
        wself.activityView.height = wself.view.height - height;
    }];
    
    
    [self setKeyboardWillHideAnimationBlock:^(CGRect keyboardFrame) {
        wself.collectionView.contentInset = UIEdgeInsetsZero;
        wself.activityView.height = wself.view.height;
    }];
}

- (void)reload
{
    self.paginationInfo = nil;
    self.tickets = [NSArray array];
    
    [self loadTickets];
    
    [self updateView];
}

- (void)loadTickets
{
    if (!self.isLoadingData)
    {
        self.loadingData = YES;
        __weak typeof(self) wself = self;
        [self.productManager ticketRecordsValidFromDate:[NSDate date]
                                      includingAttended:!self.hideAttending
                                                  query:nil
                                         paginationInfo:self.paginationInfo
                                             completion:^(TXHPartialResponsInfo *info, NSArray *ticketRecords, NSError *error) {
                                                 wself.tickets = [wself.tickets arrayByAddingObjectsFromArray:ticketRecords];
                                                 wself.loadingData = NO;
                                                 wself.paginationInfo = info;
                                             }];
    }
}

#pragma mark - Info Label

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.collectionView];

    return _activityView;
}

- (void)showInfolabelWithText:(NSString *)text withIndicator:(BOOL)indicator
{
    [self.activityView showWithMessage:text indicatorHidden:!indicator];
}

- (void)hideInfoLabel
{
    [self.activityView hide];
}

- (void)updateView
{
    [self updateToggleAttendingButton];
}

- (void)updateToggleAttendingButton
{
    NSString *title;
    
    if (self.hideAttending)
        title = NSLocalizedString(@"DOORMAN_TICKETS_LIST_SHOW_ATTENDING_BUTTON_TITLE", nil);
    else
        title = NSLocalizedString(@"DOORMAN_TICKETS_LIST_HIDE_ATTENDING_BUTTON_TITLE", nil);
    
    [self.toogleAttendingButton setTitle:title forState:UIControlStateNormal];
}

- (void)updateInfoLabel
{
    if (!self.paginationInfo && self.loadingData)
        [self showInfolabelWithText:NSLocalizedString(@"DOORMAN_TICKETS_LIST_LOOKING_UP_TICKETS", nil) withIndicator:YES];
    else if (![self.tickets count] && !self.isLoadingData)
        [self showInfolabelWithText:NSLocalizedString(@"DOORMAN_TICKETS_LIST_NO_TICKETS_LABEL", nil) withIndicator:NO];
    else
        [self hideInfoLabel];
}

//- (void)updateHeaderLabels
//{
//    BOOL anyTickets = [self.filteredTickets count] > 0;
//    
//    self.titleLabel.hidden    = !anyTickets;
//    self.subtitleLabel.hidden = !anyTickets;
//    
//    if (anyTickets)
//    {
//        NSString *attendeesFormat = NSLocalizedString(@"DOORMAN_TICKETS_LIST_ATTENDEES_FORMAT", nil);
//        NSString *attendingFormat = NSLocalizedString(@"DOORMAN_TICKETS_LIST_ATTENDING_FORMAT", nil);
//        
//        self.titleLabel.text    = [NSString stringWithFormat:attendeesFormat,(unsigned long)[self.tickets count]];
//        self.subtitleLabel.text = [NSString stringWithFormat:attendingFormat,(unsigned long)[self attendingTickets]];
//    }
//}

- (IBAction)toggleAttendingAction:(id)sender
{
    self.hideAttending = !self.hideAttending;
}

- (void)showDetailsForTicket:(TXHTicket *)ticket
{
    if (!ticket)
        return;
    
    self.selectedTicket = ticket;
    [self performSegueWithIdentifier:@"TicketDetail" sender:self];
}

- (void)showOrderForTicekt:(TXHTicket *)ticket
{
    if (!ticket)
        return;
    
    self.selectedTicket = ticket;
    [self performSegueWithIdentifier:@"TicketOrder" sender:self];
}

- (void)showErrorWithMessage:(NSString *)message
{
    self.errorShown = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.searchQuery = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField resignFirstResponder];
    });
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.searchQuery = textField.text;
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.errorShown = NO;
}

#pragma mark - Notyfications

- (void)registerForNotifications
{
    [self registerForSearchViewNotification];
    [self registerForProductChanges];
}

- (void)unregisterFromNotifications
{
    [self unregisterFromSearchViewNotification];
    [self unregisterForProductChanges];
}

- (void)registerForSearchViewNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraBarcodeRecognized:) name:TXHRecognizedQRCodeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchQueryDidChange:) name:TXHSearchQueryDidChangeNotification object:nil];
}

- (void)unregisterFromSearchViewNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHSearchQueryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHRecognizedQRCodeNotification object:nil];
}

- (void)registerForProductChanges
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productDidChange:)
                                                 name:TXHProductsChangedNotification
                                               object:nil];
}

- (void)unregisterForProductChanges
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductsChangedNotification object:nil];
}

#pragma mark - TXHScannerManagerDelegate

- (void)scannerManager:(TXHScanersManager *)manager didRecognizeQRCode:(NSString *)QRCodeString
{
    [self lookupTicketWithQRCode:QRCodeString];
}

- (void)scannerManager:(TXHScanersManager *)manager didRecognizeMSRCardTrack:(NSString *)cardTrack
{

    self.loadingData = YES;
    
    __weak typeof(self) wself = self;
    
    [self.productManager getOrderForCardMSRData:cardTrack
                                     completion:^(NSArray *orders, NSError *error) {
                                         wself.loadingData = NO;
                                         
                                         if (!error)
                                             if (![orders count])
                                                 [wself showNoOrdersForCardDataAlert];
                                             else
                                                 [wself selectOrderFromOrders:orders];
                                         else
                                             [wself showAlertForError:error];
                                     }];
}

- (void)showNoOrdersForCardDataAlert
{
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DOORMAN_TICKETS_LIST_NO_ORDERS_FOR_CARD_TITLE", nil)
                                                   message:NSLocalizedString(@"DOORMAN_TICKETS_LIST_NO_ORDERS_FOR_CARD_MESSAGE", nil)
                                                  delegate:nil
                                         cancelButtonTitle:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                                         otherButtonTitles:nil];
    [aler show];

}

- (void)selectOrderFromOrders:(NSArray *)orders
{
    if ([orders count] == 1)
    {
        TXHOrder *order = [orders firstObject];
        [self showOrderForTicekt:[order.tickets anyObject]];
    }
    else
    {
        __weak typeof(self) wself = self;
        
        TXHRMPickerViewControllerDelegate *delegate = [[TXHRMPickerViewControllerDelegate alloc] init];

        [delegate showWithItems:[TXHOrder ordersTitles:orders]
               selectionHandler:^(RMPickerViewController *vc, NSArray *selectedRows) {
                   TXHOrder *selectedOrder = orders[[[selectedRows firstObject] intValue]];
                   [wself showOrderForTicekt:[selectedOrder.tickets anyObject]];
               }];
    }
}

#pragma mark - Soft Barcode Scanner

- (void)cameraBarcodeRecognized:(NSNotification *)note
{
    NSString *barcode = [note userInfo][TXHQueryValueKey];

    [self lookupTicketWithQRCode:barcode];
}

- (void)showAlertForError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)lookupTicketWithQRCode:(NSString *)barcode
{
    NSDictionary *decodedBarcode = [TXHTicket decodeBarcode:barcode];
    NSNumber *ticketSeqID = decodedBarcode[kTXHBarcodeTicketSeqIdKey];
    
    self.loadingData = YES;
    
    __weak typeof(self) wself = self;
    
    [self.productManager searchForTicketWithSeqID:ticketSeqID
                                       completion:^(TXHTicket *ticket, NSError *error) {
                                           wself.loadingData = NO;
                                           if (!error)
                                               [wself showDetailsForTicket:ticket];
                                           else
                                               [wself showErrorWithMessage:@"Couldn't find ticket data."];
                                       }];
}

- (void)searchQueryDidChange:(NSNotification *)note
{
    NSString *query = [note userInfo][TXHQueryValueKey];
    
    if (![self canSearch])
        return;

    self.searchQuery = query;
}

- (BOOL)canSearch
{
    return !(self.isLoadingData || self.errorShown);
}

- (void)productDidChange:(NSNotification *)note
{
    self.tickets = nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tickets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXHDoorTicketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TicketCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.tickets count] ? 1 : 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        TXHDoorTicketsListHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:@"TicketsHeader"
                                                                                  forIndexPath:indexPath];
        [self configureHeader:header atIndexPath:indexPath];
        
        return header;
    }
    
    return nil;
}

- (void)configureCell:(TXHDoorTicketCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
    
    BOOL isTicketDisabled = [self.ticketsDisabled containsObject:ticket.ticketId];

    [cell setDelegate:self];
    [cell setName:ticket.customer.fullName];
    [cell setTierName:ticket.tier.name];
    [cell setReference:ticket.reference];
    [cell setPrice:[self.productManager priceStringForPrice:ticket.price]];
    [cell setAttendedAt:ticket.attendedAt animated:NO];
    [cell setIsLoading:isTicketDisabled];
}

- (void)configureHeader:(TXHDoorTicketsListHeaderView *)header atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tickets = self.tickets;// tickets at index path
    TXHTicket *firstTicket = [tickets firstObject];
    
    NSInteger attendingTickets = [self attendingTicketsFrom:tickets];

    [header setAttending:attendingTickets];
    [header setTotal:[tickets count]];
    [header setDate:firstTicket.validFrom];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
    
    [self showDetailsForTicket:ticket];
}

//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.filteredTickets count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TXHDoorTicketCell *cell = (TXHDoorTicketCell *)[tableView dequeueReusableCellWithIdentifier:@"DoorTicketListCell" forIndexPath:indexPath];
//    [cell setDelegate:self];
//    
//    [cell setIsFirstRow:indexPath.row == 0];
//    [cell setIsLastRow:indexPath.row == [self.filteredTickets count] - 1];
//    
//    TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
//    BOOL isTicketDisabled = [self.ticketsDisabled containsObject:ticket.ticketId];
//
//    [cell setTitle:ticket.title];
//    [cell setSubtitle:ticket.tier.name];
//    [cell setAttendedAt:ticket.attendedAt animated:NO];
//    [cell setIsLoading:isTicketDisabled];
//    
//    if (self.paginationInfo.hasMore && indexPath.row == [self.tickets count] - 1)
//        [self loadMoreTickets];
//    
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
//    
//    [self showDetailsForTicket:ticket];
//}

#pragma mark - TXHTicketDetailsViewControllerDelegate

- (void)txhTicketDetailsViewControllerShouldDismiss:(TXHTicketDetailsViewController *)controller
{
    [self dismissDetailViewController:controller completion:nil];
}

- (void)txhTicketDetailsViewController:(TXHTicketDetailsViewController *)controller didChangeTicket:(TXHTicket *)ticket
{
    [self.collectionView reloadData];
}

- (void)txhTicketDetailsViewController:(TXHTicketDetailsViewController *)controller wantsToPresentOrderForTicket:(TXHTicket *)ticket
{
    __weak typeof(self) wself = self;
    
    [self dismissDetailViewController:controller completion:^{
        [wself showOrderForTicekt:ticket];
    }];
}

- (void)dismissDetailViewController:(TXHTicketDetailsViewController *)controller completion:(void (^)(void))completion
{
    [self.navigationController dismissViewControllerAnimated:YES completion:completion];
}

#pragma mark - TXHDoorTicketCellDelegate

- (void)txhDoorTicketCelldidChangeSwitch:(TXHDoorTicketCell *)cell
{
    TXHTicket *cellTicket = [self ticketAtIndexPath:[self.collectionView indexPathForCell:cell]];
    
    [self.ticketsDisabled addObject:cellTicket.ticketId];
    
    __weak typeof(self) wself = self;
    [self.productManager setTicket:cellTicket
                          attended:cell.switchValue
                        completion:^(TXHTicket *ticket, NSError *error) {
                            [wself.ticketsDisabled removeObject:cellTicket.ticketId];
                            [cell setAttendedAt:cellTicket.attendedAt animated:YES];
//                            [wself.collectionView reloadData];// TODO: update header....
                        }];
}

@end
