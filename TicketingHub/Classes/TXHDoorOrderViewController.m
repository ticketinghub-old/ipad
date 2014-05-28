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

#import "TXHPrintButtonsViewController.h"

#import "TXHPrinterSelectionViewController.h"
#import "TXHPrintersUtility.h"
#import "TXHPrintersManager.h"

#import "TXHActivityLabelPrintersUtilityDelegate.h"
#import "TXHActivityLabelView.h"

#import "UIColor+TicketingHub.h"
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>

@interface TXHDoorOrderViewController () <TXHPrintButtonsViewControllerDelegate, TXHPrinterSelectionViewControllerDelegate>

@property (weak, nonatomic) TXHDoorOrderDetailsViewController     *orderDetailsViewController;
@property (weak, nonatomic) TXHDoorOrderTicketsListViewController *orderTicketsListViewController;
@property (weak, nonatomic) TXHPrintButtonsViewController         *printButtonsViewController;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (strong, nonatomic) TXHOrder *order;
@property (strong, nonatomic) TXHTicket *ticket;
@property (strong, nonatomic) TXHProductsManager *productManager;

@property (assign, nonatomic) TXHPrintType selectedPrintType;
@property (strong, nonatomic) TXHPrintersUtility *printingUtility;
@property (strong, nonatomic) TXHActivityLabelPrintersUtilityDelegate *printingUtilityDelegate;
@property (strong, nonatomic) UIPopoverController *printerSelectionPopover;

@end

@implementation TXHDoorOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    // fix for preapre for segue
    [self.activityView removeFromSuperview];
    self.activityView.frame = self.navigationController.view.bounds;
    [self.navigationController.view addSubview:self.activityView];
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

- (void)setOrder:(TXHOrder *)order
{
    _order = order;
    
    self.orderDetailsViewController.order     = order;
    self.orderTicketsListViewController.order = order;
    self.printButtonsViewController.order     = order;
}


- (void)loadOrder
{
    __weak typeof(self) wself = self;
    [self showLoadingIndicator];
    [self.productManager getOrderForTicket:self.ticket
                                completion:^(TXHOrder *order, NSError *error) {
                                    [wself hideLoadingIndicator];
                                    
                                    if (error)
                                        [wself dismissWithError:error];
                                    else
                                        wself.order = order;
                                }];
}

- (void)dismissWithError:(NSError *)error
{
    [self showLoadingIndicator];
    
    __weak typeof(self) wself = self;
    
    RIButtonItem *confirmItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"", nil)
                                                     action:^{
                                                         [wself hideLoadingIndicator];
                                                         //TODO: this should be done with delegation
                                                         [wself.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil)
                                                    message:error.localizedDescription
                                           cancelButtonItem:confirmItem
                                           otherButtonItems:nil];
    [alert show];
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
    {
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    }
    return _activityView;
}

- (TXHPrintersUtility *)printingUtility
{
    if (!_printingUtility)
    {
        TXHActivityLabelPrintersUtilityDelegate *printingUtilityDelegate =
        [TXHActivityLabelPrintersUtilityDelegate new];
        printingUtilityDelegate.activityView = self.activityView;
        
        TXHPrintersUtility *printingUtility = [[TXHPrintersUtility alloc] initWithTicketingHubCLient:self.productManager.txhManager.client];
        printingUtility.delegate = printingUtilityDelegate;
        
        _printingUtility = printingUtility;
        _printingUtilityDelegate = printingUtilityDelegate;
    }
    return _printingUtility;
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

- (void)txhPrintButtonsViewControllerCancelButtonAction:(TXHBorderedButton *)button
{
    __weak typeof(self) wself = self;
    
    [self.productManager cancelOrder:self.order
                          completion:^(TXHOrder *order, NSError *error) {
                              wself.order = order;
                          }];
}

- (void)txhPrintButtonsViewControllerMarkAttendingButtonAction:(TXHBorderedButton *)button
{
    
}

- (void)txhPrintButtonsViewControllerPrintReciptAction:(TXHBorderedButton *)button
{
    self.selectedPrintType = TXHPrintTypeRecipt;
    [self showPrinterSelectorFromButton:(UIButton *)button];
}

- (void)txhPrintButtonsViewControllerPrintTicketsAction:(TXHBorderedButton *)button
{
    self.selectedPrintType = TXHPrintTypeTickets;
    [self showPrinterSelectorFromButton:(UIButton *)button];
}

- (void)showPrinterSelectorFromButton:(UIButton *)button
{
    TXHPrinterSelectionViewController *printerSelector = [[TXHPrinterSelectionViewController alloc] initWithPrintersManager:TXHPRINTERSMANAGER];
    printerSelector.delegate = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:printerSelector];
    popover.popoverContentSize = CGSizeMake(200, 110);
    
    CGRect fromRect = [button.superview convertRect:button.frame toView:self.view];
    
    [popover presentPopoverFromRect:fromRect
                             inView:self.view
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];
    
    self.printerSelectionPopover = popover;
}

#pragma mark - TXHPrinterSelectionViewControllerDelegate

- (void)txhPrinterSelectionViewController:(TXHPrinterSelectionViewController *)controller
                         didSelectPrinter:(TXHPrinter *)printer
{
    [self.printerSelectionPopover dismissPopoverAnimated:YES];
    self.printerSelectionPopover = nil;
    
    [self.printingUtility startPrintingWithType:self.selectedPrintType onPrinter:printer withOrder:self.order];
}


@end
