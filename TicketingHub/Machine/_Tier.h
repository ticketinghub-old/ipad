// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tier.h instead.

#import <CoreData/CoreData.h>


extern const struct TierAttributes {
	__unsafe_unretained NSString *commission;
	__unsafe_unretained NSString *limit;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *size;
	__unsafe_unretained NSString *tierDescription;
	__unsafe_unretained NSString *tierID;
} TierAttributes;

extern const struct TierRelationships {
	__unsafe_unretained NSString *ticketType;
	__unsafe_unretained NSString *tickets;
} TierRelationships;

extern const struct TierFetchedProperties {
} TierFetchedProperties;

@class TicketType;
@class Ticket;









@interface TierID : NSManagedObjectID {}
@end

@interface _Tier : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TierID*)objectID;





@property (nonatomic, strong) NSDecimalNumber* commission;



//- (BOOL)validateCommission:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* limit;



@property int16_t limitValue;
- (int16_t)limitValue;
- (void)setLimitValue:(int16_t)value_;

//- (BOOL)validateLimit:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* price;



//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* size;



@property int16_t sizeValue;
- (int16_t)sizeValue;
- (void)setSizeValue:(int16_t)value_;

//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tierDescription;



//- (BOOL)validateTierDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* tierID;



@property int32_t tierIDValue;
- (int32_t)tierIDValue;
- (void)setTierIDValue:(int32_t)value_;

//- (BOOL)validateTierID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TicketType *ticketType;

//- (BOOL)validateTicketType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *tickets;

- (NSMutableSet*)ticketsSet;





#if TARGET_OS_IPHONE




- (NSFetchedResultsController*)newTicketsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;


#endif

@end

@interface _Tier (CoreDataGeneratedAccessors)

- (void)addTickets:(NSSet*)value_;
- (void)removeTickets:(NSSet*)value_;
- (void)addTicketsObject:(Ticket*)value_;
- (void)removeTicketsObject:(Ticket*)value_;

@end

@interface _Tier (CoreDataGeneratedPrimitiveAccessors)


- (NSDecimalNumber*)primitiveCommission;
- (void)setPrimitiveCommission:(NSDecimalNumber*)value;




- (NSNumber*)primitiveLimit;
- (void)setPrimitiveLimit:(NSNumber*)value;

- (int16_t)primitiveLimitValue;
- (void)setPrimitiveLimitValue:(int16_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSDecimalNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSDecimalNumber*)value;




- (NSNumber*)primitiveSize;
- (void)setPrimitiveSize:(NSNumber*)value;

- (int16_t)primitiveSizeValue;
- (void)setPrimitiveSizeValue:(int16_t)value_;




- (NSString*)primitiveTierDescription;
- (void)setPrimitiveTierDescription:(NSString*)value;




- (NSNumber*)primitiveTierID;
- (void)setPrimitiveTierID:(NSNumber*)value;

- (int32_t)primitiveTierIDValue;
- (void)setPrimitiveTierIDValue:(int32_t)value_;





- (TicketType*)primitiveTicketType;
- (void)setPrimitiveTicketType:(TicketType*)value;



- (NSMutableSet*)primitiveTickets;
- (void)setPrimitiveTickets:(NSMutableSet*)value;


@end
