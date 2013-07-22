// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to VariationOption.h instead.

#import <CoreData/CoreData.h>


extern const struct VariationOptionAttributes {
	__unsafe_unretained NSString *time;
} VariationOptionAttributes;

extern const struct VariationOptionRelationships {
	__unsafe_unretained NSString *variation;
} VariationOptionRelationships;

extern const struct VariationOptionFetchedProperties {
} VariationOptionFetchedProperties;

@class Variation;



@interface VariationOptionID : NSManagedObjectID {}
@end

@interface _VariationOption : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (VariationOptionID*)objectID;





@property (nonatomic, strong) NSNumber* time;



@property double timeValue;
- (double)timeValue;
- (void)setTimeValue:(double)value_;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Variation *variation;

//- (BOOL)validateVariation:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE



#endif

@end

@interface _VariationOption (CoreDataGeneratedAccessors)

@end

@interface _VariationOption (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveTime;
- (void)setPrimitiveTime:(NSNumber*)value;

- (double)primitiveTimeValue;
- (void)setPrimitiveTimeValue:(double)value_;





- (Variation*)primitiveVariation;
- (void)setPrimitiveVariation:(Variation*)value;


@end
