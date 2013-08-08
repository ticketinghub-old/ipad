// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHUserMO.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHUserMOAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *lastName;
} TXHUserMOAttributes;

extern const struct TXHUserMORelationships {
	__unsafe_unretained NSString *venues;
} TXHUserMORelationships;

extern const struct TXHUserMOFetchedProperties {
} TXHUserMOFetchedProperties;

@class TXHVenueMO;





@interface TXHUserMOID : NSManagedObjectID {}
@end

@interface _TXHUserMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHUserMOID*)objectID;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *venues;

- (NSMutableSet*)venuesSet;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newVenuesFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;


#endif

@end

@interface _TXHUserMO (CoreDataGeneratedAccessors)

- (void)addVenues:(NSSet*)value_;
- (void)removeVenues:(NSSet*)value_;
- (void)addVenuesObject:(TXHVenueMO*)value_;
- (void)removeVenuesObject:(TXHVenueMO*)value_;

@end

@interface _TXHUserMO (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;





- (NSMutableSet*)primitiveVenues;
- (void)setPrimitiveVenues:(NSMutableSet*)value;


@end
