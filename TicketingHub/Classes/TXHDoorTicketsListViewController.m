//
//  TXHDoorTicketsListViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketsListViewController.h"

#import "TXHProductsManager.h"
#import "TXHInfineaManger.h"

#import "TXHDoorSearchViewController.h"
#import "TXHDoorTicketCell.h"
#import "TXHTicketDetailsViewController.h"
#import "TXHTicket+Filter.h"
#import "TXHTicket+Title.h"
#import "TXHDoorOrderViewController.h"

#import "UIColor+TicketingHub.h"
#import <iOS-api/NSDateFormatter+TicketingHubFormat.h>


@interface TXHDoorTicketsListViewController () <TXHTicketDetailsViewControllerDelegate, TXHDoorTicketCellDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) NSArray *filteredTickets;
@property (strong, nonatomic) UILabel *infolabel;

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
    
    self.ticketsDisabled = [NSMutableSet set];
    [self updateHeader];
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

#pragma mark - Info Label

- (UILabel *)infolabel
{
    if (!_infolabel)
    {
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        infoLabel.textColor        = [UIColor txhDarkBlueColor];
        infoLabel.font             = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28];
        infoLabel.textAlignment    = NSTextAlignmentCenter;
        infoLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        infoLabel.translatesAutoresizingMaskIntoConstraints = YES;
        [self.view addSubview:infoLabel];
        _infolabel = infoLabel;
    }
    return _infolabel;
}

- (void)showInfolabelWithText:(NSString *)text
{
    self.infolabel.text = text;
    self.infolabel.hidden = NO;
}

- (void)hideInfoLabel
{
    self.infolabel.hidden = YES;
}

- (void)updateInfoLabel
{
    if (![self.tickets count])
    {
        [self showInfolabelWithText:@"No Tickets"];
    }
    else if (![self.filteredTickets count])
    {
        [self showInfolabelWithText:[NSString stringWithFormat:@"No Tickets for: %@",self.searchQuery]];
    }
    else if (self.loadingData)
    {
        [self showInfolabelWithText:@"Looking up ticket"];
    }
    else
    {
        [self hideInfoLabel];
    }
}

- (void)updateHeader
{
    self.titleLabel.text    = [NSString stringWithFormat:@"%lu Attendees",(unsigned long)[self.tickets count]];
    self.subtitleLabel.text = [NSString stringWithFormat:@"%lu Attending",(unsigned long)[self attendingTickets]];
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
    [self registerForKeyboardNotifications];
    [self registerForSearchViewNotification];
    [self registerForScannerNotifications];
    [self registerForProductAndAvailabilityChanges];
}

- (void)unregisterFromNotifications
{
    [self unregisterFromKeyboardNotifications];
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

#pragma mark - keyboard notification

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    NSInteger curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    CGFloat height = keyboardFrame.size.width;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:curve
                     animations:^{
                         self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
                         self.infolabel.height = self.view.height - height;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:curve
                     animations:^{
                         self.tableView.contentInset = UIEdgeInsetsZero;
                         self.infolabel.height = self.view.height;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark notifications

- (void)productDidChange:(NSNotification *)note
{
    self.tickets = nil;
}

- (void)availabilityDidChange:(NSNotification *)note
{
    __weak typeof(self) wself = self;
    
    TXHAvailability *availability = note.userInfo[TXHSelectedAvailabilityKey];
    
    [self showInfolabelWithText:@"Loading tickets"];
    
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
