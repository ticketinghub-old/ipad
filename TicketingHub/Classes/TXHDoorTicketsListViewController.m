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
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>


// TODO: almost the same as TXHDoorOrderTicketsListViewController - extract common parts

@interface TXHDoorTicketsListViewController () <TXHTicketDetailsViewControllerDelegate, TXHDoorTicketCellDelegate, UIAlertViewDelegate, TXHScanersManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TXHBorderedButton *toogleAttendingButton;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (strong, nonatomic) TXHScanersManager *scannersManager;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *activityInfoPlaceholder;

@property (strong, nonatomic) NSArray  *tickets;
@property (strong, nonatomic, readonly) NSArray  *ticketsGroupedByDate;
@property (strong, nonatomic) NSString *searchQuery;

@property (strong, nonatomic) TXHTicket *selectedTicket;
@property (strong, nonatomic) TXHOrder  *selectedOrder;
@property (strong, nonatomic) NSMutableSet *ticketsDisabled;

@property (assign, nonatomic, getter = isLoadingData) BOOL loadingData;
@property (assign, nonatomic, getter = isErrorShown) BOOL errorShown;

@property (assign, nonatomic) BOOL hideAttending;

@property (strong, nonatomic) TXHPartialResponsInfo *paginationInfo;

@property (strong, nonatomic) NSMapTable * sectionHeaders;

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
    self.scannersManager.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self unregisterFromNotifications];
    self.scannersManager.delegate = nil;
}

- (void)setHideAttending:(BOOL)hideAttending
{
    _hideAttending = hideAttending;
    
    [self updateToggleAttendingButton];
    [self reload];
}

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    _ticketsGroupedByDate = [self groupTicketsByDate:tickets];
    
    [self.collectionView reloadData];
    [self updateInfoLabel];
}

- (NSArray *)groupTicketsByDate:(NSArray *)tickets;
{
    if (!tickets) return nil;
    NSDate * currentDate = nil;
    NSMutableArray * currentDateArray = [NSMutableArray array];
    NSMutableArray * groupedArray = [NSMutableArray array];
    for (TXHTicket * ticket in tickets) {
        if (![currentDate isEqualToDate:ticket.validFrom])
        {
            if (currentDateArray.count)
                [groupedArray addObject:[currentDateArray copy]];
            currentDate = ticket.validFrom;
            currentDateArray = [NSMutableArray array];
        }
        [currentDateArray addObject:ticket];
    }
    if (currentDateArray && currentDateArray.count)
        [groupedArray addObject:[currentDateArray copy]];
    return [groupedArray copy];
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

- (NSMapTable *)sectionHeaders
{
    if (!_sectionHeaders)
        _sectionHeaders = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory];
    return _sectionHeaders;
}

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
        if (self.selectedTicket)
            [orderViewController setTicket:self.selectedTicket andProductManager:self.productManager];
        else if (self. selectedOrder)
            [orderViewController setOrder:self.selectedOrder andProductManager:self.productManager];
        
        self.selectedOrder  = nil;
        self.selectedTicket = nil;
    }
}

- (TXHTicket *)ticketAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * sectionTickets = self.ticketsGroupedByDate[indexPath.section];
    return sectionTickets[indexPath.item];
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
        
        static NSInteger counter = 0;
        __block NSInteger blockCounter = ++counter;

        __weak typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (counter != blockCounter)
                return;
            
            wself.loadingData = YES;
            [wself.productManager ticketRecordsValidFromDate:[NSDate date]
                                          includingAttended:!wself.hideAttending
                                                      query:nil
                                             paginationInfo:wself.paginationInfo
                                                 completion:^(TXHPartialResponsInfo *info, NSArray *ticketRecords, NSError *error) {
                                                     wself.tickets = [wself.tickets arrayByAddingObjectsFromArray:ticketRecords];
                                                     wself.loadingData = NO;
                                                     wself.paginationInfo = info;
                                                 }];
        });
    }
}

#pragma mark - Info Label

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.activityInfoPlaceholder];

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
    if (self.loadingData)
        [self showInfolabelWithText:NSLocalizedString(@"DOORMAN_TICKETS_LIST_LOOKING_UP_TICKETS", nil) withIndicator:YES];
    else if (![self.tickets count] && !self.isLoadingData)
        [self showInfolabelWithText:NSLocalizedString(@"DOORMAN_TICKETS_LIST_NO_TICKETS_LABEL", nil) withIndicator:NO];
    else
        [self hideInfoLabel];
}

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

- (void)showOrderForOrder:(TXHOrder *)order
{
    if (!order)
        return;
    
    self.selectedOrder = order;
    [self performSegueWithIdentifier:@"TicketOrder" sender:self];
}

- (void)showErrorWithMessage:(NSString *)message
{
    self.errorShown = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
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

- (IBAction)searchFieldEditingChanged:(UITextField *)textField
{
    self.searchQuery = textField.text;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderSelectedNotification:) name:TXHDidSelectOrderNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraBarcodeRecognized:) name:TXHRecognizedQRCodeNotification object:nil];
}

- (void)unregisterFromSearchViewNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHDidSelectOrderNotification object:nil];
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
                                 paginationInfo:nil
                                     completion:^(TXHPartialResponsInfo *info, NSArray *orders, NSError *error) {
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

- (void)orderSelectedNotification:(NSNotification *)notification
{
    TXHOrder *order = notification.userInfo[TXHSelectedOrderKey];
    
    [self showOrderForOrder:order];
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

    if (!ticketSeqID)
    {
        [self showErrorWithMessage:NSLocalizedString(@"SCANNER_ERROR_INCORRECT_DATA", nil)];
        return;
    }
    
    __weak typeof(self) wself = self;
    [self.productManager searchForTicketWithSeqID:ticketSeqID
                                       completion:^(TXHTicket *ticket, NSError *error) {
                                           wself.loadingData = NO;
                                           if (!error)
                                               [wself showDetailsForTicket:ticket];
                                           else
                                               [wself showErrorWithMessage:NSLocalizedString(@"SCANNER_ERROR_TICKET_NOT_FOUND", nil)];
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
    [self reload];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * sectionTickets = self.ticketsGroupedByDate[section];
    return [sectionTickets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXHDoorTicketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TicketCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    if (indexPath.section == self.ticketsGroupedByDate.count-1 && indexPath.item >= [self.ticketsGroupedByDate.lastObject count] - 1)
        if (self.paginationInfo.hasMore)
            [self loadTickets];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.ticketsGroupedByDate count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        TXHDoorTicketsListHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:@"TicketsHeader"
                                                                                  forIndexPath:indexPath];
        [self configureHeader:header atIndexPath:indexPath];
        NSNumber * key = @(indexPath.section);
        [self.sectionHeaders setObject:header forKey:key];
        return header;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSNumber * key = @(indexPath.section);
    if (elementKind == UICollectionElementKindSectionHeader)
        [self.sectionHeaders removeObjectForKey:key];
}

- (void)updateHeaderValuesAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber * key = @(indexPath.section);
    TXHDoorTicketsListHeaderView *header = [self.sectionHeaders objectForKey:key];
    [self configureHeader:header atIndexPath:indexPath];
    
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

- (void)removeCell:(TXHDoorTicketCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView performBatchUpdates:^{
        NSInteger sectionTicketsCount = [self.ticketsGroupedByDate[indexPath.section] count];
        if (sectionTicketsCount == 1)
            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        else
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        [self removeTicket:self.tickets[indexPath.item]];
    } completion:nil];
}

- (void)removeTicket:(TXHTicket *)ticket
{
    if (![self.tickets containsObject:ticket]) return;
    NSMutableArray * mutableTickets = [self.tickets mutableCopy];
    [mutableTickets removeObject:ticket];
    self.tickets = [mutableTickets copy];
}

- (void)configureHeader:(TXHDoorTicketsListHeaderView *)header atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.ticketsGroupedByDate.count) return;
    
    NSArray *tickets = self.ticketsGroupedByDate[indexPath.section];// tickets at index path
    TXHTicket *firstTicket = [tickets firstObject];
    
    [header setTotal:0];
    [header setAttending:0];
    
    [self.productManager getTicketsCountValidFromDate:firstTicket.validFrom attended:NO completion:^(NSNumber *count, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [header setTotal:count.integerValue];
        });
    }];
    
    [self.productManager getTicketsCountValidFromDate:firstTicket.validFrom attended:YES completion:^(NSNumber *count, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [header setAttending:count.integerValue];
        });
    }];
    [header setDate:firstTicket.validFrom];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
    
    [self showDetailsForTicket:ticket];
}

#pragma mark - TXHTicketDetailsViewControllerDelegate

- (void)txhTicketDetailsViewControllerShouldDismiss:(TXHTicketDetailsViewController *)controller
{
    if (self.hideAttending && controller.ticket.attendedAt)
    {
        [self removeTicket:controller.ticket];
        [self.collectionView reloadData];
    }
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
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    TXHTicket *cellTicket = [self ticketAtIndexPath:indexPath];
    
    cell.userInteractionEnabled = NO;
    
    [self.ticketsDisabled addObject:cellTicket.ticketId];
    
    __weak typeof(self) wself = self;
    [self.productManager setTicket:cellTicket
                          attended:cell.switchValue
                        completion:^(TXHTicket *ticket, NSError *error) {
                            cell.userInteractionEnabled = YES;
                            [wself.ticketsDisabled removeObject:cellTicket.ticketId];
                            [cell setAttendedAt:cellTicket.attendedAt animated:YES];
                            if (wself.hideAttending && ticket.attendedAt)
                                [wself removeCell:cell atIndexPath:indexPath];
                            [wself updateHeaderValuesAtIndexPath:indexPath];
                        }];
}

@end
