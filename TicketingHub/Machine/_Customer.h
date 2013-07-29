// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Customer.h instead.

#import <CoreData/CoreData.h>


extern const struct CustomerAttributes {
	__unsafe_unretained NSString *customerID;
	__unsafe_unretained NSString *email;
} CustomerAttributes;

extern const struct CustomerRelationships {
	__unsafe_unretained NSString *tickets;
} CustomerRelationships;

extern const struct CustomerFetchedProperties {
} CustomerFetchedProperties;

@class Ticket;




@interface CustomerID : NSManagedObjectID {}
@end

@interface _Customer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CustomerID*)objectID;





@property (nonatomic, strong) NSNumber* customerID;



@property int32_t customerIDValue;
- (int32_t)customerIDValue;
- (void)setCustomerIDValue:(int32_t)value_;

//- (BOOL)validateCustomerID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *tickets;

- (NSMutableSet*)ticketsSet;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newTicketsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;


#endif

@end

@interface _Customer (CoreDataGeneratedAccessors)

- (void)addTickets:(NSSet*)value_;
- (void)removeTickets:(NSSet*)value_;
- (void)addTicketsObject:(Ticket*)value_;
- (void)removeTicketsObject:(Ticket*)value_;

@end

@interface _Customer (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCustomerID;
- (void)setPrimitiveCustomerID:(NSNumber*)value;

- (int32_t)primitiveCustomerIDValue;
- (void)setPrimitiveCustomerIDValue:(int32_t)value_;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;





- (NSMutableSet*)primitiveTickets;
- (void)setPrimitiveTickets:(NSMutableSet*)value;


@end
