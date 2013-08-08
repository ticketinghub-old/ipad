// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHUserMO.m instead.

#import "_TXHUserMO.h"

const struct TXHUserMOAttributes TXHUserMOAttributes = {
	.email = @"email",
	.firstName = @"firstName",
	.secondName = @"secondName",
};

const struct TXHUserMORelationships TXHUserMORelationships = {
	.venues = @"venues",
};

const struct TXHUserMOFetchedProperties TXHUserMOFetchedProperties = {
};

@implementation TXHUserMOID
@end

@implementation _TXHUserMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TXHUserMO" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TXHUserMO";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TXHUserMO" inManagedObjectContext:moc_];
}

- (TXHUserMOID*)objectID {
	return (TXHUserMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic email;






@dynamic firstName;






@dynamic secondName;






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
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"user == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}


#endif

@end
