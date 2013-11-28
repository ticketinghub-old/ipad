//
//  VenueListController.h
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import UIKit;

@class TXHTicketingHubClient;

@interface VenueListController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) TXHTicketingHubClient *ticketingHubClient;

@end
