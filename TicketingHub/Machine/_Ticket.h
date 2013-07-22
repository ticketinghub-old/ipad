// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Ticket.h instead.

#import <CoreData/CoreData.h>


extern const struct TicketAttributes {
	__unsafe_unretained NSString *barcode;
	__unsafe_unretained NSString *commission;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *ticketID;
	__unsafe_unretained NSString *validFrom;
	__unsafe_unretained NSString *validTo;
} TicketAttributes;

extern const struct TicketRelationships {
	__unsafe_unretained NSString *customer;
	__unsafe_unretained NSString *tier;
} TicketRelationships;

extern const struct TicketFetchedProperties {
} TicketFetchedProperties;

@class Customer;
@class Tier;








@interface TicketID : NSManagedObjectID {}
@end

@interface _Ticket : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TicketID*)objectID;





@property (nonatomic, strong) NSString* barcode;



//- (BOOL)validateBarcode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* commission;



//- (BOOL)validateCommission:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* price;



//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* ticketID;



@property int32_t ticketIDValue;
- (int32_t)ticketIDValue;
- (void)setTicketIDValue:(int32_t)value_;

//- (BOOL)validateTicketID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* validFrom;



//- (BOOL)validateValidFrom:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* validTo;



//- (BOOL)validateValidTo:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Customer *customer;

//- (BOOL)validateCustomer:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Tier *tier;

//- (BOOL)validateTier:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE





#endif

@end

@interface _Ticket (CoreDataGeneratedAccessors)

@end

@interface _Ticket (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBarcode;
- (void)setPrimitiveBarcode:(NSString*)value;




- (NSDecimalNumber*)primitiveCommission;
- (void)setPrimitiveCommission:(NSDecimalNumber*)value;




- (NSDecimalNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSDecimalNumber*)value;




- (NSNumber*)primitiveTicketID;
- (void)setPrimitiveTicketID:(NSNumber*)value;

- (int32_t)primitiveTicketIDValue;
- (void)setPrimitiveTicketIDValue:(int32_t)value_;




- (NSDate*)primitiveValidFrom;
- (void)setPrimitiveValidFrom:(NSDate*)value;




- (NSDate*)primitiveValidTo;
- (void)setPrimitiveValidTo:(NSDate*)value;





- (Customer*)primitiveCustomer;
- (void)setPrimitiveCustomer:(Customer*)value;



- (Tier*)primitiveTier;
- (void)setPrimitiveTier:(Tier*)value;


@end
