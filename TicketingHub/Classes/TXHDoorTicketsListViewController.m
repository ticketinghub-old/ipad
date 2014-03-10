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
#import "TXHTicketDetailsViewController.h"

#import "UIColor+TicketingHub.h"
#import "UIView+Additions.h"

@interface TXHDoorTicketsListViewController () <TXHTicketDetailsViewControllerDelegate>

@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) NSArray *filteredTickets;
@property (strong, nonatomic) UILabel *infolabel;

@property (strong, nonatomic) NSString *searchQuery;
@property (weak, nonatomic)   TXHTicket *selectedTicket;

@end

@implementation TXHDoorTicketsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForNotifications];
}

- (void)dealloc
{
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
        NSPredicate *predicate = [self predicateForQuery:self.searchQuery];
        NSArray *filteredTickets = [self.tickets filteredArrayUsingPredicate:predicate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bQueryCounter == queryCounter)
                wself.filteredTickets = filteredTickets;
        });
    });
}

// TODO: could go o model as test method
- (NSPredicate *)predicateForQuery:(NSString *)queryString
{
    NSString *predicateFormat =
    @"(customer.fullName CONTAINS[cd] '%1$@') OR "
    @"(customer.firstName CONTAINS[cd] '%1$@') OR "
    @"(customer.lastName CONTAINS[cd] '%1$@') OR "
    @"(customer.email CONTAINS[cd] '%1$@') OR "
    @"(customer.country CONTAINS[cd] '%1$@') OR "
    @"(customer.telephone CONTAINS[cd] '%1$@') OR"
    @"(tier.name CONTAINS[cd] '%1$@') OR"
    @"(tier.tierDescription CONTAINS[cd] '%1$@')";
    
    NSString *format = [NSString stringWithFormat:predicateFormat, queryString];
    
    return [NSPredicate predicateWithFormat:format];
}

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    [self applyTicketFilter];
}

- (void)setFilteredTickets:(NSArray *)filteredTickets
{
    _filteredTickets = filteredTickets;
    [self updateInfoLabel];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TicketDetail"])
    {
        TXHTicketDetailsViewController *detailController = segue.destinationViewController;
        detailController.delegate = self;
        detailController.ticket   = self.selectedTicket;
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
    else
    {
        [self hideInfoLabel];
    }
}

#pragma mark - Notyfications

- (void)registerForNotifications
{
    [self registerForKeyboardNotifications];
    [self registerForSearchViewNotification];
    [self registerForProductAndAvailabilityChanges];
}

- (void)unregisterFromNotifications
{
    [self unregisterFromKeyboardNotifications];
    [self unregisterFromSearchViewNotification];
    [self unregisterForProductAndAvailabilityChanges];
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

- (void)barcodeRecognized:(NSNotification *)note
{
    NSString *barcode = note.object;
    
    DLog(@"%@",barcode);
}

- (void)searchQueryDidChange:(NSNotification *)note
{
    NSString *query = note.object;
    
    self.searchQuery = query;
    
    [self applyTicketFilter];
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
    
    TXHAvailability *availability = note.userInfo[TXHSelectedAvailability];
    
    [self showInfolabelWithText:@"Loading tickets"];
    
    [TXHPRODUCTSMANAGER ticketRecordsForAvailability:availability
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
    TXHDoorTicketCell *cell = (TXHDoorTicketCell *)[tableView dequeueReusableCellWithIdentifier:@"ticketCell" forIndexPath:indexPath];
    
    [cell setIsFirstRow:indexPath.row == 0];
    [cell setIsLastRow:indexPath.row == [self.filteredTickets count] - 1];
    
    TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
    
    [cell setTitle:ticket.customer.fullName];
    [cell setSubtitle:ticket.tier.name];
    [cell setAttendedAt:ticket.attendedAt];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedTicket = [self ticketAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"TicketDetail" sender:self];
}

#pragma mark - TXHTicketDetailsViewControllerDelegate

- (void)txhTicketDetailsViewControllerShouldDismiss:(TXHTicketDetailsViewController *)controller
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
