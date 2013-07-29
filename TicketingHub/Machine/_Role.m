// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Role.m instead.

#import "_Role.h"

const struct RoleAttributes RoleAttributes = {
	.name = @"name",
};

const struct RoleRelationships RoleRelationships = {
	.permissions = @"permissions",
};

const struct RoleFetchedProperties RoleFetchedProperties = {
};

@implementation RoleID
@end

@implementation _Role

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Role" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Role";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Role" inManagedObjectContext:moc_];
}

- (RoleID*)objectID {
	return (RoleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






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
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"role == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}


#endif

@end
