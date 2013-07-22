// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TicketMaster.h instead.

#import <CoreData/CoreData.h>


extern const struct TicketMasterAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *telephone;
} TicketMasterAttributes;

extern const struct TicketMasterRelationships {
	__unsafe_unretained NSString *permissions;
} TicketMasterRelationships;

extern const struct TicketMasterFetchedProperties {
} TicketMasterFetchedProperties;

@class Permission;






@interface TicketMasterID : NSManagedObjectID {}
@end

@interface _TicketMaster : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TicketMasterID*)objectID;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* telephone;



//- (BOOL)validateTelephone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *permissions;

- (NSMutableSet*)permissionsSet;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newPermissionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;


#endif

@end

@interface _TicketMaster (CoreDataGeneratedAccessors)

- (void)addPermissions:(NSSet*)value_;
- (void)removePermissions:(NSSet*)value_;
- (void)addPermissionsObject:(Permission*)value_;
- (void)removePermissionsObject:(Permission*)value_;

@end

@interface _TicketMaster (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSString*)primitiveTelephone;
- (void)setPrimitiveTelephone:(NSString*)value;





- (NSMutableSet*)primitivePermissions;
- (void)setPrimitivePermissions:(NSMutableSet*)value;


@end
