// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Permission.h instead.

#import <CoreData/CoreData.h>


extern const struct PermissionAttributes {
} PermissionAttributes;

extern const struct PermissionRelationships {
	__unsafe_unretained NSString *role;
	__unsafe_unretained NSString *ticketMaster;
	__unsafe_unretained NSString *venue;
} PermissionRelationships;

extern const struct PermissionFetchedProperties {
} PermissionFetchedProperties;

@class Role;
@class TicketMaster;
@class Venue;


@interface PermissionID : NSManagedObjectID {}
@end

@interface _Permission : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PermissionID*)objectID;





@property (nonatomic, strong) Role *role;

//- (BOOL)validateRole:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TicketMaster *ticketMaster;

//- (BOOL)validateTicketMaster:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Venue *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE







#endif

@end

@interface _Permission (CoreDataGeneratedAccessors)

@end

@interface _Permission (CoreDataGeneratedPrimitiveAccessors)



- (Role*)primitiveRole;
- (void)setPrimitiveRole:(Role*)value;



- (TicketMaster*)primitiveTicketMaster;
- (void)setPrimitiveTicketMaster:(TicketMaster*)value;



- (Venue*)primitiveVenue;
- (void)setPrimitiveVenue:(Venue*)value;


@end
