//
//  TXHDoorOrderTicketsListViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorOrderTicketsListViewController.h"
#import "TXHDoorTicketCell.h"
#import "TXHTicketDetailsViewController.h"
#import "TXHProductsManager.h"
#import "UIView+Additions.h"

#import "TXHDoorTicketsDateHeaderView.h"
#import "TXHDoorTicketsTotalHeaderView.h"
#import "TXHDoorTicketsAttendedHeaderView.h"

@interface TXHDoorOrderTicketsListViewController () <TXHTicketDetailsViewControllerDelegate, TXHDoorTicketCellDelegate, TXHDoorTicketsAttendedHeaderViewDelegate>

@property (strong, nonatomic) NSArray *tickets;
@property (weak, nonatomic)   TXHTicket *selectedTicket;
@property (strong, nonatomic) NSMutableSet *ticketsDisabled;

@property (strong, nonatomic) TXHDoorTicketsDateHeaderView     *header1;
@property (strong, nonatomic) TXHDoorTicketsAttendedHeaderView *header2;
@property (strong, nonatomic) TXHDoorTicketsTotalHeaderView    *header3;
@property (strong, nonatomic) NSArray *headers;
@property (assign, nonatomic) BOOL ticketsCollapsed;

@end

@implementation TXHDoorOrderTicketsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadHeaders];
    
    self.ticketsDisabled = [NSMutableSet set];
}

- (void)loadHeaders
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TicketListHeaders" owner:nil options:nil];
    
    if ([views count] == 3)
    {
        self.header1 = views[0];
        self.header2 = views[1];
        self.header3 = views[2];
        self.headers = views;
        self.header2.delegate = self;
    }
}

- (void)setOrder:(TXHOrder *)order
{
    _order = order;
    
    self.tickets = [order.tickets allObjects];
}

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    [self.tableView reloadData];
}

- (void)showDetailsForTicket:(TXHTicket *)ticket
{
    if (!ticket)
        return;
    
    self.selectedTicket = ticket;
    [self performSegueWithIdentifier:@"TicketDetail" sender:self];
}

- (TXHTicket *)ticketAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tickets[indexPath.row];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TicketDetail"])
    {
        TXHTicketDetailsViewController *detailController = segue.destinationViewController;
        detailController.delegate = self;
        detailController.ticket   = self.selectedTicket;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
        return self.ticketsCollapsed ? 0 : [self.tickets count];
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.headers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXHDoorTicketCell *cell = (TXHDoorTicketCell *)[tableView dequeueReusableCellWithIdentifier:@"DoorOrderTicketListCell" forIndexPath:indexPath];
    [cell setDelegate:self];
    
    [cell setIsFirstRow:NO];
    [cell setIsLastRow:indexPath.row == [self.tickets count] - 1];
    
    TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
    BOOL isTicketDisabled = [self.ticketsDisabled containsObject:ticket.ticketId];
    NSString *priceTag = [TXHPRODUCTSMANAGER priceStringForPrice:ticket.price];
    
    [cell setTitle:ticket.customer.fullName];
    [cell setSubtitle:ticket.tier.name];
    [cell setAttendedAt:ticket.attendedAt animated:NO];
    [cell setIsLoading:isTicketDisabled];
    [cell setPriceTag:priceTag];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.0f;
    switch (section) {
        case 0:
            height = self.header1.height;
            break;
        case 1:
            height = self.header2.height;
            break;
        case 2:
            height = self.header3.height;
            break;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header;
    switch (section) {
        case 0:
        {
            NSDate *validFromDate = [(TXHTicket *)[self.order.tickets anyObject] validFrom];
            
            [self.header1 setDate:validFromDate];
            
            header = self.header1;
            break;
        }
        case 1:
        {
            NSInteger totalTicketCount = [self.order.tickets count];

            [self.header2 setExpanded:!self.ticketsCollapsed];
            [self.header2 setTotalCount:@(totalTicketCount)];
            [self.header2 setAttendedCount:@(self.order.attendedTickets)];
            
            header = self.header2;
            break;
        }
        case 2:
        {
            NSString *priceString = [TXHPRODUCTSMANAGER priceStringForPrice:[self.order total]];
            
            [self.header3 setTotalValueString:priceString];
            
            header = self.header3;
            break;
        }
    }
    
    return header;
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
    [self dismissDetailViewController:controller completion:nil];
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

    [TXHPRODUCTSMANAGER setTicket:cellTicket
                         attended:cell.switchValue
                       completion:^(TXHTicket *ticket, NSError *error) {
                           [wself.ticketsDisabled removeObject:cellTicket.ticketId];
                           [cell setAttendedAt:cellTicket.attendedAt animated:YES];
                           [wself.header2 setAttendedCount:@(wself.order.attendedTickets)];
                       }];
}

#pragma  mark - TXHDoorTicketsAttendedHeaderViewDelegate

- (void)txhDoorTicketsAttendedHeaderViewDelegateIsExpandedDidChange:(TXHDoorTicketsAttendedHeaderView *)header
{
    self.ticketsCollapsed = !header.isExpanded;
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

}

@end
