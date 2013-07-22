// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Variation.h instead.

#import <CoreData/CoreData.h>


extern const struct VariationAttributes {
	__unsafe_unretained NSString *date;
} VariationAttributes;

extern const struct VariationRelationships {
	__unsafe_unretained NSString *options;
	__unsafe_unretained NSString *venue;
} VariationRelationships;

extern const struct VariationFetchedProperties {
} VariationFetchedProperties;

@class VariationOption;
@class Venue;



@interface VariationID : NSManagedObjectID {}
@end

@interface _Variation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (VariationID*)objectID;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *options;

- (NSMutableSet*)optionsSet;




@property (nonatomic, strong) Venue *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newOptionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;




#endif

@end

@interface _Variation (CoreDataGeneratedAccessors)

- (void)addOptions:(NSSet*)value_;
- (void)removeOptions:(NSSet*)value_;
- (void)addOptionsObject:(VariationOption*)value_;
- (void)removeOptionsObject:(VariationOption*)value_;

@end

@interface _Variation (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;





- (NSMutableSet*)primitiveOptions;
- (void)setPrimitiveOptions:(NSMutableSet*)value;



- (Venue*)primitiveVenue;
- (void)setPrimitiveVenue:(Venue*)value;


@end
