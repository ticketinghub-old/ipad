// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SeasonOption.h instead.

#import <CoreData/CoreData.h>


extern const struct SeasonOptionAttributes {
	__unsafe_unretained NSString *time;
	__unsafe_unretained NSString *weekDay;
} SeasonOptionAttributes;

extern const struct SeasonOptionRelationships {
	__unsafe_unretained NSString *season;
} SeasonOptionRelationships;

extern const struct SeasonOptionFetchedProperties {
} SeasonOptionFetchedProperties;

@class Season;




@interface SeasonOptionID : NSManagedObjectID {}
@end

@interface _SeasonOption : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SeasonOptionID*)objectID;





@property (nonatomic, strong) NSNumber* time;



@property double timeValue;
- (double)timeValue;
- (void)setTimeValue:(double)value_;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* weekDay;



@property int16_t weekDayValue;
- (int16_t)weekDayValue;
- (void)setWeekDayValue:(int16_t)value_;

//- (BOOL)validateWeekDay:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Season *season;

//- (BOOL)validateSeason:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE



#endif

@end

@interface _SeasonOption (CoreDataGeneratedAccessors)

@end

@interface _SeasonOption (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveTime;
- (void)setPrimitiveTime:(NSNumber*)value;

- (double)primitiveTimeValue;
- (void)setPrimitiveTimeValue:(double)value_;




- (NSNumber*)primitiveWeekDay;
- (void)setPrimitiveWeekDay:(NSNumber*)value;

- (int16_t)primitiveWeekDayValue;
- (void)setPrimitiveWeekDayValue:(int16_t)value_;





- (Season*)primitiveSeason;
- (void)setPrimitiveSeason:(Season*)value;


@end
