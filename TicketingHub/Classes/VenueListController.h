//
//  VenueListController.h
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import CoreData;
@import UIKit;

#import "VenueSelectionProtocol.h"

@interface VenueListController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id<VenueSelectionProtocol> venueSelectionDelegate;

@end
