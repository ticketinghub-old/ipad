// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHOptionMO.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHOptionMOAttributes {
	__unsafe_unretained NSString *duration;
	__unsafe_unretained NSString *timeString;
	__unsafe_unretained NSString *weekdayIndex;
} TXHOptionMOAttributes;

extern const struct TXHOptionMORelationships {
	__unsafe_unretained NSString *venue;
} TXHOptionMORelationships;

extern const struct TXHOptionMOFetchedProperties {
} TXHOptionMOFetchedProperties;

@class TXHVenueMO;





@interface TXHOptionMOID : NSManagedObjectID {}
@end

@interface _TXHOptionMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHOptionMOID*)objectID;





@property (nonatomic, strong) NSString* duration;



//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* timeString;



//- (BOOL)validateTimeString:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* weekdayIndex;



@property int16_t weekdayIndexValue;
- (int16_t)weekdayIndexValue;
- (void)setWeekdayIndexValue:(int16_t)value_;

//- (BOOL)validateWeekdayIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHVenueMO *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE



#endif

@end

@interface _TXHOptionMO (CoreDataGeneratedAccessors)

@end

@interface _TXHOptionMO (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDuration;
- (void)setPrimitiveDuration:(NSString*)value;




- (NSString*)primitiveTimeString;
- (void)setPrimitiveTimeString:(NSString*)value;




- (NSNumber*)primitiveWeekdayIndex;
- (void)setPrimitiveWeekdayIndex:(NSNumber*)value;

- (int16_t)primitiveWeekdayIndexValue;
- (void)setPrimitiveWeekdayIndexValue:(int16_t)value_;





- (TXHVenueMO*)primitiveVenue;
- (void)setPrimitiveVenue:(TXHVenueMO*)value;


@end
