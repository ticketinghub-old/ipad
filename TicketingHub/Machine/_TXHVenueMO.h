// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHVenueMO.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHVenueMOAttributes {
} TXHVenueMOAttributes;

extern const struct TXHVenueMORelationships {
	__unsafe_unretained NSString *user;
} TXHVenueMORelationships;

extern const struct TXHVenueMOFetchedProperties {
} TXHVenueMOFetchedProperties;

@class TXHUserMO;


@interface TXHVenueMOID : NSManagedObjectID {}
@end

@interface _TXHVenueMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHVenueMOID*)objectID;





@property (nonatomic, strong) TXHUserMO *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE



#endif

@end

@interface _TXHVenueMO (CoreDataGeneratedAccessors)

@end

@interface _TXHVenueMO (CoreDataGeneratedPrimitiveAccessors)



- (TXHUserMO*)primitiveUser;
- (void)setPrimitiveUser:(TXHUserMO*)value;


@end
