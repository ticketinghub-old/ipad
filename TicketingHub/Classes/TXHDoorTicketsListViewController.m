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

#import "UIColor+TicketingHub.h"
#import "UIView+Additions.h"

@interface TXHDoorTicketsListViewController ()

@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) NSArray *filteredTickets;
@property (strong, nonatomic) UILabel *infolabel;

@property (strong, nonatomic) NSString *searchQuery;

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
    //TODO: apply filter in background
    self.filteredTickets = self.tickets;
    
    [self updateInfoLabel];
    [self.tableView reloadData];
}

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    [self applyTicketFilter];
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
    DLog(@"%@",query);
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
