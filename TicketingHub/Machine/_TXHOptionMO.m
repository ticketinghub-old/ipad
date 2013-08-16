// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHOptionMO.m instead.

#import "_TXHOptionMO.h"

const struct TXHOptionMOAttributes TXHOptionMOAttributes = {
	.duration = @"duration",
	.timeString = @"timeString",
	.weekdayIndex = @"weekdayIndex",
};

const struct TXHOptionMORelationships TXHOptionMORelationships = {
	.venue = @"venue",
};

const struct TXHOptionMOFetchedProperties TXHOptionMOFetchedProperties = {
};

@implementation TXHOptionMOID
@end

@implementation _TXHOptionMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TXHOptionMO" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TXHOptionMO";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TXHOptionMO" inManagedObjectContext:moc_];
}

- (TXHOptionMOID*)objectID {
	return (TXHOptionMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"durationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"duration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"weekdayIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weekdayIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic duration;



- (double)durationValue {
	NSNumber *result = [self duration];
	return [result doubleValue];
}

- (void)setDurationValue:(double)value_ {
	[self setDuration:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveDurationValue {
	NSNumber *result = [self primitiveDuration];
	return [result doubleValue];
}

- (void)setPrimitiveDurationValue:(double)value_ {
	[self setPrimitiveDuration:[NSNumber numberWithDouble:value_]];
}





@dynamic timeString;






@dynamic weekdayIndex;



- (int16_t)weekdayIndexValue {
	NSNumber *result = [self weekdayIndex];
	return [result shortValue];
}

- (void)setWeekdayIndexValue:(int16_t)value_ {
	[self setWeekdayIndex:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveWeekdayIndexValue {
	NSNumber *result = [self primitiveWeekdayIndex];
	return [result shortValue];
}

- (void)setPrimitiveWeekdayIndexValue:(int16_t)value_ {
	[self setPrimitiveWeekdayIndex:[NSNumber numberWithShort:value_]];
}





@dynamic venue;

	






#if TARGET_OS_IPHONE



#endif

@end
