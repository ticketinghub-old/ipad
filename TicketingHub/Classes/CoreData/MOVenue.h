//
//  MOVenue.h
//  TicketingHub
//
//  Created by Mark on 15/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MOVenue : NSManagedObject

@property (nonatomic, retain) NSNumber * venueID;
@property (nonatomic, retain) NSString * businessName;
@property (nonatomic, retain) NSString * currencyCode;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * timeZoneName;
@property (nonatomic, retain) NSString * websiteURL;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * establishmentType;
@property (nonatomic, retain) NSString * stripePublishableKey;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSString * street1;
@property (nonatomic, retain) NSString * street2;

@end
