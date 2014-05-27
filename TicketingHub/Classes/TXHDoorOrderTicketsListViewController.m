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
#import "TXHTicket+Title.h"
#import "TXHBorderedButton.h"

#import "TXHDoorTicketsListHeaderView.h"
#import "TXHDoorTicketCell.h"


// TODO: almost the same as TXHDoorTicketsListViewController - extract common parts

@interface TXHDoorOrderTicketsListViewController () <TXHTicketDetailsViewControllerDelegate, TXHDoorTicketCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSArray *tickets;
@property (weak, nonatomic)   TXHTicket *selectedTicket;
@property (strong, nonatomic) NSMutableSet *ticketsDisabled;

@property (weak, nonatomic) IBOutlet TXHBorderedButton *toogleAttendingButton;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) BOOL ticketsCollapsed;

@property (assign, nonatomic) BOOL hideAttending;

@end

@implementation TXHDoorOrderTicketsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ticketsDisabled = [NSMutableSet set];
}

- (void)setOrder:(TXHOrder *)order
{
    _order = order;
    
    self.tickets = [order.tickets allObjects];
}

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    [self.collectionView reloadData];
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

- (NSUInteger)attendingTicketsFrom:(NSArray *)tickets
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attendedAt != NULL"];
    return [[tickets filteredArrayUsingPredicate:predicate] count];
}

- (IBAction)toggleAttendingAction:(id)sender
{
    self.hideAttending = !self.hideAttending;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TicketDetail"])
    {
        TXHTicketDetailsViewController *detailController = segue.destinationViewController;
        detailController.delegate       = self;
        detailController.productManager = self.productManager;
        detailController.ticket         = self.selectedTicket;
    }
}

//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (section == 1)
//        return self.ticketsCollapsed ? 0 : [self.tickets count];
//    return 0;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [self.headers count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TXHDoorTicketCell *cell = (TXHDoorTicketCell *)[tableView dequeueReusableCellWithIdentifier:@"DoorOrderTicketListCell" forIndexPath:indexPath];
//    [cell setDelegate:self];
//    
////    [cell setIsFirstRow:NO];
////    [cell setIsLastRow:indexPath.row == [self.tickets count] - 1];
////    
////    TXHTicket *ticket     = [self ticketAtIndexPath:indexPath];
////    BOOL isTicketDisabled = [self.ticketsDisabled containsObject:ticket.ticketId];
////    NSString *priceTag    = [self.productManager priceStringForPrice:ticket.price];
////    
////    [cell setTitle:ticket.title];
////    [cell setSubtitle:ticket.tier.name];
////    [cell setAttendedAt:ticket.attendedAt animated:NO];
////    [cell setIsLoading:isTicketDisabled];
////    [cell setPriceTag:priceTag];
////    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat height = 0.0f;
//    switch (section) {
//        case 0:
//            height = self.header1.height;
//            break;
//        case 1:
//            height = self.header2.height;
//            break;
//        case 2:
//            height = self.header3.height;
//            break;
//    }
//    
//    return height;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *header;
//    switch (section) {
//        case 0:
//        {
//            NSDate *validFromDate = [(TXHTicket *)[self.order.tickets anyObject] validFrom];
//            
//            [self.header1 setDate:validFromDate];
//            
//            header = self.header1;
//            break;
//        }
//        case 1:
//        {
//            NSInteger totalTicketCount = [self.order.tickets count];
//
//            [self.header2 setExpanded:!self.ticketsCollapsed];
//            [self.header2 setTotalCount:@(totalTicketCount)];
//            [self.header2 setAttendedCount:@(self.order.attendedTickets)];
//            
//            header = self.header2;
//            break;
//        }
//        case 2:
//        {
//            NSString *priceString = [self.productManager priceStringForPrice:[self.order total]];
//            
//            [self.header3 setTotalValueString:priceString];
//            
//            header = self.header3;
//            break;
//        }
//    }
//    
//    return header;
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
    [self dismissDetailViewController:controller completion:nil];
}

- (void)dismissDetailViewController:(TXHTicketDetailsViewController *)controller completion: (void (^)(void))completion
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
//                            [wself.header2 setAttendedCount:@(wself.order.attendedTickets)];
                        }];
}

@end
