// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHVenueMO.m instead.

#import "_TXHVenueMO.h"

const struct TXHVenueMOAttributes TXHVenueMOAttributes = {
};

const struct TXHVenueMORelationships TXHVenueMORelationships = {
	.user = @"user",
};

const struct TXHVenueMOFetchedProperties TXHVenueMOFetchedProperties = {
};

@implementation TXHVenueMOID
@end

@implementation _TXHVenueMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TXHVenueMO" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TXHVenueMO";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TXHVenueMO" inManagedObjectContext:moc_];
}

- (TXHVenueMOID*)objectID {
	return (TXHVenueMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic user;

	






#if TARGET_OS_IPHONE



#endif

@end
