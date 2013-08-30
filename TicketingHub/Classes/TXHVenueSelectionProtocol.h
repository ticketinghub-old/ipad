//
//  TXHVenueSelectionProtocol.h
//  TicketingHub
//
//  Created by Abizer Nasir on 30/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

@class TXHVenueMO;

@protocol TXHVenueSelectionProtocol <NSObject>

@optional
- (void)setSelectedVenue:(TXHVenueMO *)venueMO;

@end
