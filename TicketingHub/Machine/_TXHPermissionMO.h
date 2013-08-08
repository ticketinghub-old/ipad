// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHPermissionMO.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHPermissionMOAttributes {
	__unsafe_unretained NSString *name;
} TXHPermissionMOAttributes;

extern const struct TXHPermissionMORelationships {
	__unsafe_unretained NSString *venues;
} TXHPermissionMORelationships;

extern const struct TXHPermissionMOFetchedProperties {
} TXHPermissionMOFetchedProperties;

@class TXHVenueMO;



@interface TXHPermissionMOID : NSManagedObjectID {}
@end

@interface _TXHPermissionMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHPermissionMOID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *venues;

- (NSMutableSet*)venuesSet;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newVenuesFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;


#endif

@end

@interface _TXHPermissionMO (CoreDataGeneratedAccessors)

- (void)addVenues:(NSSet*)value_;
- (void)removeVenues:(NSSet*)value_;
- (void)addVenuesObject:(TXHVenueMO*)value_;
- (void)removeVenuesObject:(TXHVenueMO*)value_;

@end

@interface _TXHPermissionMO (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveVenues;
- (void)setPrimitiveVenues:(NSMutableSet*)value;


@end
