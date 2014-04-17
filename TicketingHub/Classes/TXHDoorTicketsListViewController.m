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
#import "TXHInfineaManger.h"

#import "TXHTicket+Filter.h"
#import "TXHTicket+Title.h"
#import "UIViewController+BHTKeyboardNotifications.h"

@interface TXHDoorTicketsListViewController () <TXHTicketDetailsViewControllerDelegate, TXHDoorTicketCellDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) NSArray *filteredTickets;
@property (strong, nonatomic) TXHActivityLabelView *activityView;

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
    
    [self updateHeader];
    [self setupKeybaordAnimations];
    
    self.ticketsDisabled = [NSMutableSet set];

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
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bQueryCounter == queryCounter)
                wself.filteredTickets = filteredTickets;
        });
    });
}

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    [self applyTicketFilter];
    [self updateHeader];
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
        TXHActivityLabelView *activityView = [TXHActivityLabelView getInstance];
        activityView.frame = self.view.bounds;
        activityView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.view addSubview:activityView];
        _activityView = activityView;
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

- (void)updateHeader
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
    [self registerForScannerNotifications];
    [self registerForProductAndAvailabilityChanges];
}

- (void)unregisterFromNotifications
{
    [self unregisterFromSearchViewNotification];
    [self unregisterFromScannerNotifications];
    [self unregisterForProductAndAvailabilityChanges];
}

- (void)registerForScannerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scannerBarcodeRecognized:) name:TXHScannerRecognizedQRCodeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scannerMSRDataRecognized:) name:TXHScannerRecognizedMSRCardDataNotification object:nil];
}

- (void)unregisterFromScannerNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHScannerRecognizedQRCodeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHScannerRecognizedMSRCardDataNotification object:nil];
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

#pragma mark - notification actions

- (void)scannerMSRDataRecognized:(NSNotification *)note
{
    __unused NSString *cardTrack = [note userInfo][TXHScannerRecognizedValueKey];
}

- (void)scannerBarcodeRecognized:(NSNotification *)note
{
    NSString *barcode = [note userInfo][TXHScannerRecognizedValueKey];

    [self filterTicketsWithBarcode:barcode];
}

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
    
    [self dismissDetailViewController:controller completion:^{
        [wself showOrderForTicekt:ticket];
    }];
}

- (void)dismissDetailViewController:(TXHTicketDetailsViewController *)controller completion: (void (^)(void))completion
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
                            [wself updateHeader];
                        }];
}

@end
