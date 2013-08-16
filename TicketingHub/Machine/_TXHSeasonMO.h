// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHSeasonMO.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHSeasonMOAttributes {
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *startDate;
} TXHSeasonMOAttributes;

extern const struct TXHSeasonMORelationships {
} TXHSeasonMORelationships;

extern const struct TXHSeasonMOFetchedProperties {
} TXHSeasonMOFetchedProperties;





@interface TXHSeasonMOID : NSManagedObjectID {}
@end

@interface _TXHSeasonMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHSeasonMOID*)objectID;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;






#if TARGET_OS_IPHONE

#endif

@end

@interface _TXHSeasonMO (CoreDataGeneratedAccessors)

@end

@interface _TXHSeasonMO (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




@end
