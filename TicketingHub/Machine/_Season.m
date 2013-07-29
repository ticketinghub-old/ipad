// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Season.m instead.

#import "_Season.h"

const struct SeasonAttributes SeasonAttributes = {
	.endsOn = @"endsOn",
	.startsOn = @"startsOn",
};

const struct SeasonRelationships SeasonRelationships = {
	.options = @"options",
	.venue = @"venue",
};

const struct SeasonFetchedProperties SeasonFetchedProperties = {
};

@implementation SeasonID
@end

@implementation _Season

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Season" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Season";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Season" inManagedObjectContext:moc_];
}

- (SeasonID*)objectID {
	return (SeasonID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic endsOn;






@dynamic startsOn;






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
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"SeasonOption" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"season == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}




#endif

@end
