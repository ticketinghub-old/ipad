// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Venue.h instead.

#import <CoreData/CoreData.h>


extern const struct VenueAttributes {
	__unsafe_unretained NSString *businessName;
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *currencyCode;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *establishmentType;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *postcode;
	__unsafe_unretained NSString *region;
	__unsafe_unretained NSString *street1;
	__unsafe_unretained NSString *street2;
	__unsafe_unretained NSString *stripePublishableKey;
	__unsafe_unretained NSString *telephone;
	__unsafe_unretained NSString *timeZoneName;
	__unsafe_unretained NSString *venueID;
	__unsafe_unretained NSString *websiteURL;
} VenueAttributes;

extern const struct VenueRelationships {
	__unsafe_unretained NSString *permissions;
	__unsafe_unretained NSString *seasons;
	__unsafe_unretained NSString *ticketTypes;
	__unsafe_unretained NSString *variations;
} VenueRelationships;

extern const struct VenueFetchedProperties {
} VenueFetchedProperties;

@class Permission;
@class Season;
@class TicketType;
@class Variation;



















@interface VenueID : NSManagedObjectID {}
@end

@interface _Venue : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (VenueID*)objectID;





@property (nonatomic, strong) NSString* businessName;



//- (BOOL)validateBusinessName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* city;



//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* country;



//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* currencyCode;



//- (BOOL)validateCurrencyCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* establishmentType;



//- (BOOL)validateEstablishmentType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* postcode;



//- (BOOL)validatePostcode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* region;



//- (BOOL)validateRegion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* street1;



//- (BOOL)validateStreet1:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* street2;



//- (BOOL)validateStreet2:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* stripePublishableKey;



//- (BOOL)validateStripePublishableKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* telephone;



//- (BOOL)validateTelephone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* timeZoneName;



//- (BOOL)validateTimeZoneName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* venueID;



@property int32_t venueIDValue;
- (int32_t)venueIDValue;
- (void)setVenueIDValue:(int32_t)value_;

//- (BOOL)validateVenueID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* websiteURL;



//- (BOOL)validateWebsiteURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *permissions;

- (NSMutableSet*)permissionsSet;




@property (nonatomic, strong) NSSet *seasons;

- (NSMutableSet*)seasonsSet;




@property (nonatomic, strong) NSSet *ticketTypes;

- (NSMutableSet*)ticketTypesSet;




@property (nonatomic, strong) NSSet *variations;

- (NSMutableSet*)variationsSet;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newPermissionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;



- (NSFetchedResultsController*)newSeasonsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;



- (NSFetchedResultsController*)newTicketTypesFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;



- (NSFetchedResultsController*)newVariationsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;


#endif

@end

@interface _Venue (CoreDataGeneratedAccessors)

- (void)addPermissions:(NSSet*)value_;
- (void)removePermissions:(NSSet*)value_;
- (void)addPermissionsObject:(Permission*)value_;
- (void)removePermissionsObject:(Permission*)value_;

- (void)addSeasons:(NSSet*)value_;
- (void)removeSeasons:(NSSet*)value_;
- (void)addSeasonsObject:(Season*)value_;
- (void)removeSeasonsObject:(Season*)value_;

- (void)addTicketTypes:(NSSet*)value_;
- (void)removeTicketTypes:(NSSet*)value_;
- (void)addTicketTypesObject:(TicketType*)value_;
- (void)removeTicketTypesObject:(TicketType*)value_;

- (void)addVariations:(NSSet*)value_;
- (void)removeVariations:(NSSet*)value_;
- (void)addVariationsObject:(Variation*)value_;
- (void)removeVariationsObject:(Variation*)value_;

@end

@interface _Venue (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBusinessName;
- (void)setPrimitiveBusinessName:(NSString*)value;




- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;




- (NSString*)primitiveCurrencyCode;
- (void)setPrimitiveCurrencyCode:(NSString*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveEstablishmentType;
- (void)setPrimitiveEstablishmentType:(NSString*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;




- (NSString*)primitivePostcode;
- (void)setPrimitivePostcode:(NSString*)value;




- (NSString*)primitiveRegion;
- (void)setPrimitiveRegion:(NSString*)value;




- (NSString*)primitiveStreet1;
- (void)setPrimitiveStreet1:(NSString*)value;




- (NSString*)primitiveStreet2;
- (void)setPrimitiveStreet2:(NSString*)value;




- (NSString*)primitiveStripePublishableKey;
- (void)setPrimitiveStripePublishableKey:(NSString*)value;




- (NSString*)primitiveTelephone;
- (void)setPrimitiveTelephone:(NSString*)value;




- (NSString*)primitiveTimeZoneName;
- (void)setPrimitiveTimeZoneName:(NSString*)value;




- (NSNumber*)primitiveVenueID;
- (void)setPrimitiveVenueID:(NSNumber*)value;

- (int32_t)primitiveVenueIDValue;
- (void)setPrimitiveVenueIDValue:(int32_t)value_;




- (NSString*)primitiveWebsiteURL;
- (void)setPrimitiveWebsiteURL:(NSString*)value;





- (NSMutableSet*)primitivePermissions;
- (void)setPrimitivePermissions:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSeasons;
- (void)setPrimitiveSeasons:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTicketTypes;
- (void)setPrimitiveTicketTypes:(NSMutableSet*)value;



- (NSMutableSet*)primitiveVariations;
- (void)setPrimitiveVariations:(NSMutableSet*)value;


@end
