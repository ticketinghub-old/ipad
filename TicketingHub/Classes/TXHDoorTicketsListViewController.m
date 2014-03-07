//
//  TXHDoorTicketsListViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketsListViewController.h"

#import "TXHTicketingHubManager.h"
#import "TXHProductsManager.h"

#import "TXHDoorSearchViewController.h"
#import "TXHDoorTicketCell.h"

@interface TXHDoorTicketsListViewController ()

@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) NSArray *filteredTickets;

@end

@implementation TXHDoorTicketsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForSearchViewNotification];
    [self registerForProductAndAvailabilityChanges];
}

- (void)dealloc
{
    [self unregisterFromSearchViewNotification];
    [self unregisterForProductAndAvailabilityChanges];
}

- (void)barcodeRecognized:(NSNotification *)note
{
    NSString *barcode = note.object;
    
    DLog(@"%@",barcode);
}

- (void)searchQueryDidChange:(NSNotification *)note
{
    NSString *query = note.object;
    
    DLog(@"%@",query);
    [self applyTicketFilter];
}

- (void)applyTicketFilter
{
    //TODO: apply filter in background
    self.filteredTickets = self.tickets;

    [self.tableView reloadData];
}

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    [self applyTicketFilter];
}

- (void)registerForSearchViewNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barcodeRecognized:) name:TXHRecognizedQRCodeNotification object:nil];
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
                                                 name:TXHProductChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(availabilityDidChange:)
                                                 name:TXHAvailabilityChangedNotification
                                               object:nil];
}

- (void)unregisterForProductAndAvailabilityChanges
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHAvailabilityChangedNotification object:nil];
}

#pragma mark notifications

- (void)productDidChange:(NSNotification *)note
{
    self.tickets = nil;
}

- (void)availabilityDidChange:(NSNotification *)note
{
    __weak typeof(self) wself = self;
    
    TXHAvailability *availability = note.userInfo[TXHSelectedAvailability];
    
    [TXHPRODUCTSMANAGER ticketRecordsForAvailability:availability
                                            andQuery:nil
                                          completion:^(NSArray *ticketRecords, NSError *error) {
                                              
                                              DLog(@"%@ %@",ticketRecords, error);

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
    TXHDoorTicketCell *cell = (TXHDoorTicketCell *)[tableView dequeueReusableCellWithIdentifier:@"ticketCell" forIndexPath:indexPath];
    
    [cell setIsFirstRow:indexPath.row == 0];
    [cell setIsLastRow:indexPath.row == [self.filteredTickets count] - 1];
    [cell setTitle:@"John Appleseed"];
    [cell setSubtitle:@"Adult"];
    [cell setAttendedAt:[NSDate date]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
