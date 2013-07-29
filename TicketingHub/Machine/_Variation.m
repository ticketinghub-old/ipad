// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Variation.m instead.

#import "_Variation.h"

const struct VariationAttributes VariationAttributes = {
	.date = @"date",
};

const struct VariationRelationships VariationRelationships = {
	.options = @"options",
	.venue = @"venue",
};

const struct VariationFetchedProperties VariationFetchedProperties = {
};

@implementation VariationID
@end

@implementation _Variation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Variation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Variation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Variation" inManagedObjectContext:moc_];
}

- (VariationID*)objectID {
	return (VariationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic date;






@dynamic options;

	
- (NSMutableSet*)optionsSet {
	[self willAccessValueForKey:@"options"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"options"];
  
	[self didAccessValueForKey:@"options"];
	return result;
}
	

@dynamic venue;

	






#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newOptionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"VariationOption" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"variation == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}




#endif

@end
