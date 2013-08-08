// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHPermissionMO.m instead.

#import "_TXHPermissionMO.h"

const struct TXHPermissionMOAttributes TXHPermissionMOAttributes = {
	.name = @"name",
};

const struct TXHPermissionMORelationships TXHPermissionMORelationships = {
	.venues = @"venues",
};

const struct TXHPermissionMOFetchedProperties TXHPermissionMOFetchedProperties = {
};

@implementation TXHPermissionMOID
@end

@implementation _TXHPermissionMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TXHPermissionMO" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TXHPermissionMO";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TXHPermissionMO" inManagedObjectContext:moc_];
}

- (TXHPermissionMOID*)objectID {
	return (TXHPermissionMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic venues;

	
- (NSMutableSet*)venuesSet {
	[self willAccessValueForKey:@"venues"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"venues"];
  
	[self didAccessValueForKey:@"venues"];
	return result;
}
	






#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newVenuesFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"TXHVenueMO" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"permissions CONTAINS %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}


#endif

@end
