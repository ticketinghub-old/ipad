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

@end

@implementation TXHDoorTicketsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gueryFor:) name:kRecognizedQRCodeNotification object:nil];
    [self registerForProductAndAvailabilityChanges];
}

- (void)dealloc
{
    [self unregisterForProductAndAvailabilityChanges];
}

- (void)gueryFor:(NSNotification *)note
{
    NSString *text = note.object;
    
    DLog(@"%@",text);
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
    
}

- (void)availabilityDidChange:(NSNotification *)note
{
    TXHAvailability *availability = note.userInfo[TXHSelectedAvailability];
    
    [TXHPRODUCTSMANAGER ticketRecordsForAvailability:availability
                                            andQuery:nil
                                          completion:^(NSArray *ticketRecords, NSError *error) {
                                              
                                              DLog(@"%@ %@",ticketRecords, error);

                                              self.tickets = ticketRecords;
                                              
                                              [self.tableView reloadData];
                                          }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tickets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXHDoorTicketCell *cell = (TXHDoorTicketCell *)[tableView dequeueReusableCellWithIdentifier:@"ticketCell" forIndexPath:indexPath];
    
    [cell setIsFirstRow:indexPath.row == 0];
    [cell setIsLastRow:indexPath.row == [self.tickets count] - 1];
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
