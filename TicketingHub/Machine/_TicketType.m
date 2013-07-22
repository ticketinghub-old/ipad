// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TicketType.m instead.

#import "_TicketType.h"

const struct TicketTypeAttributes TicketTypeAttributes = {
	.date = @"date",
	.duration = @"duration",
	.limit = @"limit",
	.time = @"time",
};

const struct TicketTypeRelationships TicketTypeRelationships = {
	.tiers = @"tiers",
	.venue = @"venue",
};

const struct TicketTypeFetchedProperties TicketTypeFetchedProperties = {
};

@implementation TicketTypeID
@end

@implementation _TicketType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TicketType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TicketType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TicketType" inManagedObjectContext:moc_];
}

- (TicketTypeID*)objectID {
	return (TicketTypeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"durationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"duration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"limitValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"limit"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"timeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"time"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic date;






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





@dynamic limit;



- (int16_t)limitValue {
	NSNumber *result = [self limit];
	return [result shortValue];
}

- (void)setLimitValue:(int16_t)value_ {
	[self setLimit:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLimitValue {
	NSNumber *result = [self primitiveLimit];
	return [result shortValue];
}

- (void)setPrimitiveLimitValue:(int16_t)value_ {
	[self setPrimitiveLimit:[NSNumber numberWithShort:value_]];
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





@dynamic tiers;

	
- (NSMutableSet*)tiersSet {
	[self willAccessValueForKey:@"tiers"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tiers"];
  
	[self didAccessValueForKey:@"tiers"];
	return result;
}
	

@dynamic venue;

	






#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newTiersFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"Tier" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ticketType == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}




#endif

@end
