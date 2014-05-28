//
//  TXHDoorMainViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorMainViewController.h"

#import "TXHProductsManager.h"

#import "TXHDoorSearchViewController.h"
#import "TXHDoorTicketsListViewController.h"

@interface TXHDoorMainViewController ()

@end

@implementation TXHDoorMainViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TXHDoorTicketsListViewController"])
    {
        TXHDoorTicketsListViewController *ticketsList = segue.destinationViewController;
        ticketsList.productManager = self.prodctManager;
    }
    else if ([segue.identifier isEqualToString:@"TXHDoorSearchViewController"])
    {
        TXHDoorSearchViewController *search = segue.destinationViewController;
        search.productsManger = self.prodctManager;
    }

}


@end
