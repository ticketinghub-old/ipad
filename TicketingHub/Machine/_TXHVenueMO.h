// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHVenueMO.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHVenueMOAttributes {
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *currency;
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
	__unsafe_unretained NSString *venueId;
	__unsafe_unretained NSString *venueName;
	__unsafe_unretained NSString *website;
} TXHVenueMOAttributes;

extern const struct TXHVenueMORelationships {
	__unsafe_unretained NSString *options;
	__unsafe_unretained NSString *permissions;
	__unsafe_unretained NSString *user;
} TXHVenueMORelationships;

extern const struct TXHVenueMOFetchedProperties {
} TXHVenueMOFetchedProperties;

@class TXHOptionMO;
@class TXHPermissionMO;
@class TXHUserMO;



















@interface TXHVenueMOID : NSManagedObjectID {}
@end

@interface _TXHVenueMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHVenueMOID*)objectID;





@property (nonatomic, strong) NSString* city;



//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* country;



//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* currency;



//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* establishmentType;



//- (BOOL)validateEstablishmentType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

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





@property (nonatomic, strong) NSNumber* venueId;



@property int32_t venueIdValue;
- (int32_t)venueIdValue;
- (void)setVenueIdValue:(int32_t)value_;

//- (BOOL)validateVenueId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* venueName;



//- (BOOL)validateVenueName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* website;



//- (BOOL)validateWebsite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *options;

- (NSMutableSet*)optionsSet;




@property (nonatomic, strong) NSSet *permissions;

- (NSMutableSet*)permissionsSet;




@property (nonatomic, strong) TXHUserMO *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newOptionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;



- (NSFetchedResultsController*)newPermissionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;




#endif

@end

@interface _TXHVenueMO (CoreDataGeneratedAccessors)

- (void)addOptions:(NSSet*)value_;
- (void)removeOptions:(NSSet*)value_;
- (void)addOptionsObject:(TXHOptionMO*)value_;
- (void)removeOptionsObject:(TXHOptionMO*)value_;

- (void)addPermissions:(NSSet*)value_;
- (void)removePermissions:(NSSet*)value_;
- (void)addPermissionsObject:(TXHPermissionMO*)value_;
- (void)removePermissionsObject:(TXHPermissionMO*)value_;

@end

@interface _TXHVenueMO (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;




- (NSString*)primitiveCurrency;
- (void)setPrimitiveCurrency:(NSString*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveEstablishmentType;
- (void)setPrimitiveEstablishmentType:(NSString*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




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




- (NSNumber*)primitiveVenueId;
- (void)setPrimitiveVenueId:(NSNumber*)value;

- (int32_t)primitiveVenueIdValue;
- (void)setPrimitiveVenueIdValue:(int32_t)value_;




- (NSString*)primitiveVenueName;
- (void)setPrimitiveVenueName:(NSString*)value;




- (NSString*)primitiveWebsite;
- (void)setPrimitiveWebsite:(NSString*)value;





- (NSMutableSet*)primitiveOptions;
- (void)setPrimitiveOptions:(NSMutableSet*)value;



- (NSMutableSet*)primitivePermissions;
- (void)setPrimitivePermissions:(NSMutableSet*)value;



- (TXHUserMO*)primitiveUser;
- (void)setPrimitiveUser:(TXHUserMO*)value;


@end
