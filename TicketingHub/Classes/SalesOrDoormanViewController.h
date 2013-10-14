//
//  SalesOrDoormanViewController.h
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import UIKit;

#import "VenueSelectionProtocol.h"

@interface SalesOrDoormanViewController : UIViewController <VenueSelectionProtocol>

- (IBAction)selectMode:(id)sender;

@end
