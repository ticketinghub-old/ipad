//
//  TXHDoorOrderViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorOrderViewController.h"

#import <iOS-api/TXHTicketingHubClient.h>
#import "TXHProductsManager.h"

#import "TXHDoorOrderDetailsViewController.h"
#import "TXHDoorOrderTicketsListViewController.h"

#import "TXHOrderFooterViewController.h"

#import "TXHActivityLabelPrintersUtilityDelegate.h"
#import "TXHActivityLabelView.h"

#import "UIColor+TicketingHub.h"
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>

@interface TXHDoorOrderViewController () <TXHOrderFooterViewControllerDelegate>

@property (weak, nonatomic) TXHDoorOrderDetailsViewController     *orderDetailsViewController;
@property (weak, nonatomic) TXHDoorOrderTicketsListViewController *orderTicketsListViewController;
@property (weak, nonatomic) TXHOrderFooterViewController          *printButtonsViewController;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (strong, nonatomic) TXHOrder *order;
@property (strong, nonatomic) TXHTicket *ticket;
@property (strong, nonatomic) TXHProductsManager *productManager;

@end

@implementation TXHDoorOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateTitle];
}

- (void)updateTitle
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_small"]];
}

- (void)setTicket:(TXHTicket *)ticket andProductManager:(TXHProductsManager *)productManager
{
    self.ticket = ticket;
    self.productManager = productManager;

    [self loadOrder];
}

- (void)setOrder:(TXHOrder *)order andProductManager:(TXHProductsManager *)productManager
{
    self.order = order;
    self.productManager = productManager;
    
    [self updateOrder];
}

- (void)setOrder:(TXHOrder *)order
{
    _order = order;
    
    self.orderDetailsViewController.order     = order;
    self.orderTicketsListViewController.order = order;
    self.printButtonsViewController.order     = order;
}

- (void)loadOrder
{
    if (!self.ticket)
        return;
        
    __weak typeof(self) wself = self;
    //[self showLoadingIndicator];
    [self.productManager getOrderForTicket:self.ticket
                                completion:^(TXHOrder *order, NSError *error) {
                                    [wself hideLoadingIndicator];
                                    
                                    if (error)
                                        [wself dismissWithError:error];
                                    else
                                        wself.order = order;
                                }];
}

- (void)updateOrder
{
    if (!self.order)
        return;
    
    __weak typeof(self) wself = self;
    //[self showLoadingIndicator];
    [self.productManager getUpdatedOrder:self.order
                              completion:^(TXHOrder *order, NSError *error) {
                                  [wself hideLoadingIndicator];
                                  
                                  if (error)
                                      [wself dismissWithError:error];
                                  else
                                      wself.order = order;
                              }];
}

#pragma mark - error helper

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message action:(void(^)(void))action
{
    [self.activityView hide];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                                                    action:^{
                                                        if (action)
                                                            action();
                                                    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems: nil];
    [alertView show];
}

- (void)dismissWithError:(NSError *)error
{
    [self showLoadingIndicator];
    
    __weak typeof(self) wself = self;
    
    RIButtonItem *confirmItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                                                     action:^{
                                                         [wself hideLoadingIndicator];
                                                         //TODO: this should be done with delegation
                                                         [wself.navigationController popViewControllerAnimated:YES];
                                                     }];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                    message:error.errorDescription
                                           cancelButtonItem:confirmItem
                                           otherButtonItems:nil];
    [alert show];
}


- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    return _activityView;
}

#pragma mark - private methods

- (void)showLoadingIndicator
{
    [self.activityView showWithMessage:@"" indicatorHidden:NO];
}

- (void)hideLoadingIndicator
{
    [self.activityView hide];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OrderDetails"])
    {
        self.orderDetailsViewController = segue.destinationViewController;
        self.orderDetailsViewController.productManager = self.productManager;
    }
    else if ([segue.identifier isEqualToString:@"OrderTickets"])
    {
        self.orderTicketsListViewController = segue.destinationViewController;
        self.orderTicketsListViewController.productManager = self.productManager;
    }
    else if ([segue.identifier isEqualToString:@"PrintButtons"])
    {
        self.printButtonsViewController = segue.destinationViewController;
        self.printButtonsViewController.delegate = self;
    }
}

#pragma mark - TXHPrintButtonsViewControllerDelegate

- (void)txhPrintButtonsViewControllerMarkAttendingButtonAction:(TXHBorderedButton *)button
{
    __weak typeof(self) wself = self;
    
    [self.productManager setAllTicketsAttendedForOrder:self.order
                                            completion:^(TXHOrder *order, NSError *error) {
                                                if (error)
                                                    [wself showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                                      message:error.errorDescription
                                                                       action:nil];
                                                else if (order)
                                                    wself.order = order;
                                            }];
}



@end
