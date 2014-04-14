//
//  TXHProductsManagerNotifications.h
//  TicketingHub
//
//  Created by Abizer Nasir on 17/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

/**
 Notification sent by the TXHProductManager when the selected venue is changed.
 
 The `object` will be the instance of TXHProductManager
 The `userInfo` contain the following key:value
      TXHSelectedProductKey : a reference to the TXHProduct object that has been selected. The object is in the main managed object context.
 */
extern NSString * const TXHProductsChangedNotification;

/**
 The key used by the `userInfo` dictionary containing the selected venue reference
 */
extern NSString * const TXHSelectedProductKey;


/**
 Notification sent by the TXHProductManager when the selected availability is changed.
 
 The `object` will be the instance of TXHProductManager
 The `userInfo` contain the following key:value
 TXHSelectedAvailabilityKey : a reference to the TXHProduct object that has been selected. The object is in the main managed object context.
 */
extern NSString * const TXHAvailabilityChangedNotification;

/**
 The key used by the `userInfo` dictionary containing the selected venavailability reference
 */
extern NSString * const TXHSelectedAvailabilityKey;