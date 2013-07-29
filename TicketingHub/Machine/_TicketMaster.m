// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TicketMaster.m instead.

#import "_TicketMaster.h"

const struct TicketMasterAttributes TicketMasterAttributes = {
	.email = @"email",
	.firstName = @"firstName",
	.lastName = @"lastName",
	.telephone = @"telephone",
};

const struct TicketMasterRelationships TicketMasterRelationships = {
	.permissions = @"permissions",
};

const struct TicketMasterFetchedProperties TicketMasterFetchedProperties = {
};

@implementation TicketMasterID
@end

@implementation _TicketMaster

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TicketMaster" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TicketMaster";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TicketMaster" inManagedObjectContext:moc_];
}

- (TicketMasterID*)objectID {
	return (TicketMasterID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic email;






@dynamic firstName;






@dynamic lastName;






@dynamic telephone;






@dynamic permissions;

	
- (NSMutableSet*)permissionsSet {
	[self willAccessValueForKey:@"permissions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"permissions"];
  
	[self didAccessValueForKey:@"permissions"];
	return result;
}
	






#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newPermissionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"Permission" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ticketMaster == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}


#endif

@end
