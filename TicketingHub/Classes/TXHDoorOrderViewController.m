//
//  TXHDoorOrderViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorOrderViewController.h"
#import "TXHProductsManager.h"
#import "UIColor+TicketingHub.h"

#import "TXHDoorOrderDetailsViewController.h"
#import "TXHDoorOrderTicketsListViewController.h"

@interface TXHDoorOrderViewController ()

@property (nonatomic, weak) TXHDoorOrderDetailsViewController *orderDetailsViewController;
@property (nonatomic, weak) TXHDoorOrderTicketsListViewController *orderTicketsListViewController;

@property (nonatomic, strong) TXHOrder *order;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation TXHDoorOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup
{
    self.title = [[TXHPRODUCTSMANAGER selectedProduct] name];
}

- (void)setTicket:(TXHTicket *)ticket
{
    _ticket = ticket;
    
    [self loadOrder];
}

- (void)setOrder:(TXHOrder *)order
{
    _order = order;
    
    self.orderDetailsViewController.order     = order;
    self.orderTicketsListViewController.order = order;
}


- (void)loadOrder
{
    __weak typeof(self) wself = self;
    [self showLoadingIndicator];
    [TXHPRODUCTSMANAGER getOrderForTicket:self.ticket
                               completion:^(TXHOrder *order, NSError *error) {
                                   wself.order = order;
                                   [wself hideLoadingIndicator];
                               }];
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator)
    {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        indicatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        indicatorView.hidesWhenStopped = YES;
        indicatorView.color = [UIColor txhDarkBlueColor];
        [self.view addSubview:indicatorView];
        _activityIndicator = indicatorView;
    }
    return _activityIndicator;
}

#pragma mark - private methods

- (void)showLoadingIndicator
{
    [self.activityIndicator startAnimating];
}

- (void)hideLoadingIndicator
{
    [self.activityIndicator stopAnimating];
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
    }
}


@end
