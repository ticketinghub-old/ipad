// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHSeasonMO.m instead.

#import "_TXHSeasonMO.h"

const struct TXHSeasonMOAttributes TXHSeasonMOAttributes = {
	.endDate = @"endDate",
	.startDate = @"startDate",
};

const struct TXHSeasonMORelationships TXHSeasonMORelationships = {
	.venue = @"venue",
};

const struct TXHSeasonMOFetchedProperties TXHSeasonMOFetchedProperties = {
};

@implementation TXHSeasonMOID
@end

@implementation _TXHSeasonMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TXHSeasonMO" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TXHSeasonMO";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TXHSeasonMO" inManagedObjectContext:moc_];
}

- (TXHSeasonMOID*)objectID {
	return (TXHSeasonMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic endDate;






@dynamic startDate;






@dynamic venue;

	






#if TARGET_OS_IPHONE



#endif

@end
