// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to VariationOption.m instead.

#import "_VariationOption.h"

const struct VariationOptionAttributes VariationOptionAttributes = {
	.time = @"time",
};

const struct VariationOptionRelationships VariationOptionRelationships = {
	.variation = @"variation",
};

const struct VariationOptionFetchedProperties VariationOptionFetchedProperties = {
};

@implementation VariationOptionID
@end

@implementation _VariationOption

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"VariationOption" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"VariationOption";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"VariationOption" inManagedObjectContext:moc_];
}

- (VariationOptionID*)objectID {
	return (VariationOptionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"timeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"time"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic time;



- (double)timeValue {
	NSNumber *result = [self time];
	return [result doubleValue];
}

- (void)setTimeValue:(double)value_ {
	[self setTime:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveTimeValue {
	NSNumber *result = [self primitiveTime];
	return [result doubleValue];
}

- (void)setPrimitiveTimeValue:(double)value_ {
	[self setPrimitiveTime:[NSNumber numberWithDouble:value_]];
}





@dynamic variation;

	






#if TARGET_OS_IPHONE



#endif

@end
