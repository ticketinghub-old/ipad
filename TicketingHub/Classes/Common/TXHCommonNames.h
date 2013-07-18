//
//  TXHCommonNames.h
//  TicketingHub
//
//  Created by Mark on 15/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#ifndef TicketingHub_TXHCommonNames_h
#define TicketingHub_TXHCommonNames_h

// Names for notifications between TXHDoorMainController embedded containers
#define doorDateSelected      @"doorDateSelected"
#define doorDateCellSelected  @"doorDateCellSelected"
#define doorTimeCellSelected  @"doorTimeCellSelected"

// A key for the last user who logged in; stored in NSUserDefaults
#define LAST_USER @"lastUser"

// Name for notifications dispatched by TXHMenuViewController
#define TOGGLE_MENU     @"toggleMenu"
#define VENUE_SELECTED  @"venueSelected"

// Names for notifications dispatched by TXHServerAccessManager
#define VENUE_UPDATED @"venueUpdated"

// Names for notifications dispatched by TXHSalesCalendarController
#define TIMESLOT_SELECTED @"timeslotSelected"

#endif
