// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Permission.m instead.

#import "_Permission.h"

const struct PermissionAttributes PermissionAttributes = {
};

const struct PermissionRelationships PermissionRelationships = {
	.role = @"role",
	.ticketMaster = @"ticketMaster",
	.venue = @"venue",
};

const struct PermissionFetchedProperties PermissionFetchedProperties = {
};

@implementation PermissionID
@end

@implementation _Permission

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Permission" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Permission";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Permission" inManagedObjectContext:moc_];
}

- (PermissionID*)objectID {
	return (PermissionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic role;

	

@dynamic ticketMaster;

	

@dynamic venue;

	






#if TARGET_OS_IPHONE







#endif

@end
