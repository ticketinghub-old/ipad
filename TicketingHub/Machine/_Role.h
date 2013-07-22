// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Role.h instead.

#import <CoreData/CoreData.h>


extern const struct RoleAttributes {
	__unsafe_unretained NSString *name;
} RoleAttributes;

extern const struct RoleRelationships {
	__unsafe_unretained NSString *permissions;
} RoleRelationships;

extern const struct RoleFetchedProperties {
} RoleFetchedProperties;

@class Permission;



@interface RoleID : NSManagedObjectID {}
@end

@interface _Role : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RoleID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *permissions;

- (NSMutableSet*)permissionsSet;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newPermissionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;


#endif

@end

@interface _Role (CoreDataGeneratedAccessors)

- (void)addPermissions:(NSSet*)value_;
- (void)removePermissions:(NSSet*)value_;
- (void)addPermissionsObject:(Permission*)value_;
- (void)removePermissionsObject:(Permission*)value_;

@end

@interface _Role (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitivePermissions;
- (void)setPrimitivePermissions:(NSMutableSet*)value;


@end
