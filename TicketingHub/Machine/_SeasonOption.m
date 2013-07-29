// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SeasonOption.m instead.

#import "_SeasonOption.h"

const struct SeasonOptionAttributes SeasonOptionAttributes = {
	.time = @"time",
	.weekDay = @"weekDay",
};

const struct SeasonOptionRelationships SeasonOptionRelationships = {
	.season = @"season",
};

const struct SeasonOptionFetchedProperties SeasonOptionFetchedProperties = {
};

@implementation SeasonOptionID
@end

@implementation _SeasonOption

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SeasonOption" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SeasonOption";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SeasonOption" inManagedObjectContext:moc_];
}

- (SeasonOptionID*)objectID {
	return (SeasonOptionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"timeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"time"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"weekDayValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weekDay"];
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





@dynamic weekDay;



- (int16_t)weekDayValue {
	NSNumber *result = [self weekDay];
	return [result shortValue];
}

- (void)setWeekDayValue:(int16_t)value_ {
	[self setWeekDay:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveWeekDayValue {
	NSNumber *result = [self primitiveWeekDay];
	return [result shortValue];
}

- (void)setPrimitiveWeekDayValue:(int16_t)value_ {
	[self setPrimitiveWeekDay:[NSNumber numberWithShort:value_]];
}





@dynamic season;

	






#if TARGET_OS_IPHONE



#endif

@end
