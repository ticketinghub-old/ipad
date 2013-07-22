// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Season.h instead.

#import <CoreData/CoreData.h>


extern const struct SeasonAttributes {
	__unsafe_unretained NSString *endsOn;
	__unsafe_unretained NSString *startsOn;
} SeasonAttributes;

extern const struct SeasonRelationships {
	__unsafe_unretained NSString *options;
	__unsafe_unretained NSString *venue;
} SeasonRelationships;

extern const struct SeasonFetchedProperties {
} SeasonFetchedProperties;

@class SeasonOption;
@class Venue;




@interface SeasonID : NSManagedObjectID {}
@end

@interface _Season : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SeasonID*)objectID;





@property (nonatomic, strong) NSDate* endsOn;



//- (BOOL)validateEndsOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startsOn;



//- (BOOL)validateStartsOn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *options;

- (NSMutableSet*)optionsSet;




@property (nonatomic, strong) Venue *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newOptionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;




#endif

@end

@interface _Season (CoreDataGeneratedAccessors)

- (void)addOptions:(NSSet*)value_;
- (void)removeOptions:(NSSet*)value_;
- (void)addOptionsObject:(SeasonOption*)value_;
- (void)removeOptionsObject:(SeasonOption*)value_;

@end

@interface _Season (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveEndsOn;
- (void)setPrimitiveEndsOn:(NSDate*)value;




- (NSDate*)primitiveStartsOn;
- (void)setPrimitiveStartsOn:(NSDate*)value;





- (NSMutableSet*)primitiveOptions;
- (void)setPrimitiveOptions:(NSMutableSet*)value;



- (Venue*)primitiveVenue;
- (void)setPrimitiveVenue:(Venue*)value;


@end
