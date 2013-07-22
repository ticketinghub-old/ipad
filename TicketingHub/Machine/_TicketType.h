// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TicketType.h instead.

#import <CoreData/CoreData.h>


extern const struct TicketTypeAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *duration;
	__unsafe_unretained NSString *limit;
	__unsafe_unretained NSString *time;
} TicketTypeAttributes;

extern const struct TicketTypeRelationships {
	__unsafe_unretained NSString *tiers;
	__unsafe_unretained NSString *venue;
} TicketTypeRelationships;

extern const struct TicketTypeFetchedProperties {
} TicketTypeFetchedProperties;

@class Tier;
@class Venue;






@interface TicketTypeID : NSManagedObjectID {}
@end

@interface _TicketType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TicketTypeID*)objectID;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* duration;



@property double durationValue;
- (double)durationValue;
- (void)setDurationValue:(double)value_;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* limit;



@property int16_t limitValue;
- (int16_t)limitValue;
- (void)setLimitValue:(int16_t)value_;

//- (BOOL)validateLimit:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* time;



@property double timeValue;
- (double)timeValue;
- (void)setTimeValue:(double)value_;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *tiers;

- (NSMutableSet*)tiersSet;




@property (nonatomic, strong) Venue *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newTiersFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;




#endif

@end

@interface _TicketType (CoreDataGeneratedAccessors)

- (void)addTiers:(NSSet*)value_;
- (void)removeTiers:(NSSet*)value_;
- (void)addTiersObject:(Tier*)value_;
- (void)removeTiersObject:(Tier*)value_;

@end

@interface _TicketType (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSNumber*)primitiveDuration;
- (void)setPrimitiveDuration:(NSNumber*)value;

- (double)primitiveDurationValue;
- (void)setPrimitiveDurationValue:(double)value_;




- (NSNumber*)primitiveLimit;
- (void)setPrimitiveLimit:(NSNumber*)value;

- (int16_t)primitiveLimitValue;
- (void)setPrimitiveLimitValue:(int16_t)value_;




- (NSNumber*)primitiveTime;
- (void)setPrimitiveTime:(NSNumber*)value;

- (double)primitiveTimeValue;
- (void)setPrimitiveTimeValue:(double)value_;





- (NSMutableSet*)primitiveTiers;
- (void)setPrimitiveTiers:(NSMutableSet*)value;



- (Venue*)primitiveVenue;
- (void)setPrimitiveVenue:(Venue*)value;


@end
