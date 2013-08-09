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

// Name for notifications dispatched by TXHMenuViewController
static NSString* const NOTIFICATION_TOGGLE_MENU =       @"notificationToggleMenu";
static NSString* const NOTIFICATION_MENU_LOGOUT =       @"notificationMenuLogout";
static NSString* const NOTIFICATION_VENUE_SELECTED =    @"notificationVenueSelected";
static NSString* const NOTIFICATION_MENU_LOGIN =        @"notificationMenuLogin";

// Names for notifications dispatched by TXHServerAccessManager
static NSString* const NOTIFICATION_VENUE_UPDATED =     @"notificationVenueUpdated";

// Names for notifications dispatched by TXHSalesCalendarController
static NSString* const NOTIFICATION_TIMESLOT_SELECTED = @"notificationTimeslotSelected";

#endif
