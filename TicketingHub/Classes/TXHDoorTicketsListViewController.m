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

#import "TXHDoorTicketCell.h"
#import "TXHActivityLabelView.h"

#import "TXHProductsManager.h"
#import "TXHScanersManager.h"

#import "TXHTicket+Filter.h"
#import "TXHTicket+Title.h"
#import "TXHOrder+Helpers.h"
#import <UIViewController+BHTKeyboardAnimationBlocks/UIViewController+BHTKeyboardNotifications.h>
#import "TXHRMPickerViewControllerDelegate.h"

@interface TXHDoorTicketsListViewController () <TXHTicketDetailsViewControllerDelegate, TXHDoorTicketCellDelegate, UIAlertViewDelegate, TXHScanersManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (strong, nonatomic) TXHScanersManager *scannersManager;

@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) NSArray *filteredTickets;

@property (strong, nonatomic) NSString *searchQuery;
@property (strong, nonatomic) TXHTicket *selectedTicket;
@property (strong, nonatomic) NSMutableSet *ticketsDisabled;

@property (assign, nonatomic, getter = isLoadingData) BOOL loadingData;
@property (assign, nonatomic, getter = isErrorShown) BOOL errorShown;


@end

@implementation TXHDoorTicketsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateHeaderLabels];
    [self setupKeybaordAnimations];
    [self setupScannersManager];
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

- (void)applyTicketFilter
{
    static NSInteger queryCounter = 0;
    queryCounter++;
    
    if (!self.searchQuery.length)
    {
        self.filteredTickets = self.tickets;
        return;
    }
    
    NSInteger bQueryCounter = queryCounter;
    __weak typeof(self) wself = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *filteredTickets = [TXHTicket filterTickets:wself.tickets withQuery:wself.searchQuery];
        if (bQueryCounter == queryCounter)
            dispatch_async(dispatch_get_main_queue(), ^{
                    wself.filteredTickets = filteredTickets;
            });
    });
}

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    [self applyTicketFilter];
    [self updateHeaderLabels];
}

- (void)setSearchQuery:(NSString *)searchQuery
{
    _searchQuery = searchQuery;
    
    [self applyTicketFilter];
}

- (void)setFilteredTickets:(NSArray *)filteredTickets
{
    _filteredTickets = filteredTickets;
    [self updateInfoLabel];
    [self.tableView reloadData];
}

- (void)setLoadingData:(BOOL)loadingData
{
    _loadingData = loadingData;
    
    [self updateInfoLabel];
}

- (NSMutableSet *)ticketsDisabled
{
    if (!_ticketsDisabled)
    {
        _ticketsDisabled = [NSMutableSet new];
    }
    return _ticketsDisabled;
}

- (NSUInteger)attendingTickets
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attendedAt != NULL"];
    return [[self.tickets filteredArrayUsingPredicate:predicate] count];
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
    return self.filteredTickets[indexPath.row];
}

- (void)setupKeybaordAnimations
{
    __weak typeof(self) wself = self;
    
    [self setKeyboardWillShowAnimationBlock:^(CGRect keyboardFrame) {
        CGFloat height = keyboardFrame.size.width;
        wself.tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
        wself.activityView.height = wself.view.height - height;
    }];
    
    
    [self setKeyboardWillHideAnimationBlock:^(CGRect keyboardFrame) {
        wself.tableView.contentInset = UIEdgeInsetsZero;
        wself.activityView.height = wself.view.height;
    }];
}

#pragma mark - Info Label

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
    {
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    }
    return _activityView;
}

- (void)showInfolabelWithText:(NSString *)text withIndicator:(BOOL)indicator
{
    self.tableView.scrollEnabled = NO;
    [self.activityView showWithMessage:text indicatorHidden:!indicator];
}

- (void)hideInfoLabel
{
    self.tableView.scrollEnabled = YES;
    [self.activityView hide];
}

- (void)updateInfoLabel
{
    if (![self.tickets count])
    {
        [self showInfolabelWithText:NSLocalizedString(@"DOORMAN_TICKETS_LIST_NO_TICKETS_LABEL", nil) withIndicator:NO];
    }
    else if (![self.filteredTickets count])
    {
        NSString *format = NSLocalizedString(@"DOORMAN_TICKETS_LIST_NO_TICKETS_FOR_QUERY_FORMAT", nil);
        [self showInfolabelWithText:[NSString stringWithFormat:format,self.searchQuery] withIndicator:NO];
    }
    else if (self.loadingData)
    {
        [self showInfolabelWithText:NSLocalizedString(@"DOORMAN_TICKETS_LIST_LOOKING_UP_TICKETS", nil) withIndicator:NO];
    }
    else
    {
        [self hideInfoLabel];
    }
}

- (void)updateHeaderLabels
{
    BOOL anyTickets = [self.filteredTickets count] > 0;
    
    self.titleLabel.hidden    = !anyTickets;
    self.subtitleLabel.hidden = !anyTickets;
    
    if (anyTickets)
    {
        NSString *attendeesFormat = NSLocalizedString(@"DOORMAN_TICKETS_LIST_ATTENDEES_FORMAT", nil);
        NSString *attendingFormat = NSLocalizedString(@"DOORMAN_TICKETS_LIST_ATTENDING_FORMAT", nil);
        
        self.titleLabel.text    = [NSString stringWithFormat:attendeesFormat,(unsigned long)[self.tickets count]];
        self.subtitleLabel.text = [NSString stringWithFormat:attendingFormat,(unsigned long)[self attendingTickets]];
    }
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

#pragma mark UIalertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.errorShown = NO;
}

#pragma mark - Notyfications

- (void)registerForNotifications
{
    [self registerForSearchViewNotification];
    [self registerForProductAndAvailabilityChanges];
}

- (void)unregisterFromNotifications
{
    [self unregisterFromSearchViewNotification];
    [self unregisterForProductAndAvailabilityChanges];
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

- (void)registerForProductAndAvailabilityChanges
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productDidChange:)
                                                 name:TXHProductsChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(availabilityDidChange:)
                                                 name:TXHAvailabilityChangedNotification
                                               object:nil];
}

- (void)unregisterForProductAndAvailabilityChanges
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductsChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHAvailabilityChangedNotification object:nil];
}

#pragma mark - TXHScannerManagerDelegate

- (void)scannerManager:(TXHScanersManager *)manager didRecognizeQRCode:(NSString *)QRCodeString
{
    [self filterTicketsWithBarcode:QRCodeString];
}

- (void)scannerManager:(TXHScanersManager *)manager didRecognizeMSRCardTrack:(NSString *)cardTrack
{
    [self showInfolabelWithText:NSLocalizedString(@"DOORMAN_TICKETS_LIST_SEARCHING_LABEL", nil)
                  withIndicator:YES];
    
    __weak typeof(self) wself = self;
    
    [self.productManager getOrderForCardMSRData:cardTrack
                                     completion:^(NSArray *orders, NSError *error) {
                                         
                                         [wself hideInfoLabel];
                                         
                                         if (!error)
                                         {
                                             if (![orders count])
                                             {
                                                 [wself showNoOrdersForCardDataAlert];
                                                 return;
                                             }
                                             
                                             [wself selectOrderFromOrders:orders];
                                         }
                                         else
                                         {
                                             [wself showAlertForError:error];
                                         }
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

    [self filterTicketsWithBarcode:barcode];
}

- (void)filterTicketsWithBarcode:(NSString *)barcode
{
    if (![barcode length] || ![self canSearch])
        return;
    
    DLog(@"search for ticket with barcode: %@",barcode);
    
    NSArray *filteredTickets = [TXHTicket filterTickets:self.tickets withQuery:barcode];
    
    if ([filteredTickets count])
    {
        TXHTicket *scannedTicket = [filteredTickets firstObject];
        [self showDetailsForTicket:scannedTicket];
    }
    else
    {
        [self lookupTicketWithBarcode:barcode];
    }
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

- (void)lookupTicketWithBarcode:(NSString *)barcode
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

- (void)availabilityDidChange:(NSNotification *)note
{
    __weak typeof(self) wself = self;
    
    TXHAvailability *availability = note.userInfo[TXHSelectedAvailabilityKey];
    
    [self showInfolabelWithText:NSLocalizedString(@"DOORMAN_TICKETS_LIST_LOADING_TICKETS", nil) withIndicator:YES];
    
    [self.productManager ticketRecordsForAvailability:availability
                                             andQuery:nil
                                           completion:^(NSArray *ticketRecords, NSError *error) {
                                               
                                               wself.tickets = ticketRecords;
                                           }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredTickets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXHDoorTicketCell *cell = (TXHDoorTicketCell *)[tableView dequeueReusableCellWithIdentifier:@"DoorTicketListCell" forIndexPath:indexPath];
    [cell setDelegate:self];
    
    [cell setIsFirstRow:indexPath.row == 0];
    [cell setIsLastRow:indexPath.row == [self.filteredTickets count] - 1];
    
    TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
    BOOL isTicketDisabled = [self.ticketsDisabled containsObject:ticket.ticketId];

    [cell setTitle:ticket.title];
    [cell setSubtitle:ticket.tier.name];
    [cell setAttendedAt:ticket.attendedAt animated:NO];
    [cell setIsLoading:isTicketDisabled];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
    
    [self showDetailsForTicket:ticket];
}

#pragma mark - TXHTicketDetailsViewControllerDelegate

- (void)txhTicketDetailsViewControllerShouldDismiss:(TXHTicketDetailsViewController *)controller
{
    [self dismissDetailViewController:controller completion:nil];
}

- (void)txhTicketDetailsViewController:(TXHTicketDetailsViewController *)controller didChangeTicket:(TXHTicket *)ticket
{
    [self.tableView reloadData];
}

- (void)txhTicketDetailsViewController:(TXHTicketDetailsViewController *)controller wantsToPresentOrderForTicket:(TXHTicket *)ticket
{
    __weak typeof(self) wself = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissDetailViewController:controller completion:^{
            [wself showOrderForTicekt:ticket];
        }];
    });
}

- (void)dismissDetailViewController:(TXHTicketDetailsViewController *)controller completion:(void (^)(void))completion
{
    [self.navigationController dismissViewControllerAnimated:YES completion:completion];
}

#pragma mark - TXHDoorTicketCellDelegate

- (void)txhDoorTicketCelldidChangeSwitch:(TXHDoorTicketCell *)cell
{
    TXHTicket *cellTicket = [self ticketAtIndexPath:[self.tableView indexPathForCell:cell]];
    
    [self.ticketsDisabled addObject:cellTicket.ticketId];
    
    __weak typeof(self) wself = self;
    [self.productManager setTicket:cellTicket
                          attended:cell.switchValue
                        completion:^(TXHTicket *ticket, NSError *error) {
                            [wself.ticketsDisabled removeObject:cellTicket.ticketId];
                            [cell setAttendedAt:cellTicket.attendedAt animated:YES];
                            [wself updateHeaderLabels];
                        }];
}

@end
