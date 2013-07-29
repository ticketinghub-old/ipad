// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tier.m instead.

#import "_Tier.h"

const struct TierAttributes TierAttributes = {
	.commission = @"commission",
	.limit = @"limit",
	.name = @"name",
	.price = @"price",
	.size = @"size",
	.tierDescription = @"tierDescription",
	.tierID = @"tierID",
};

const struct TierRelationships TierRelationships = {
	.ticketType = @"ticketType",
	.tickets = @"tickets",
};

const struct TierFetchedProperties TierFetchedProperties = {
};

@implementation TierID
@end

@implementation _Tier

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tier" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tier";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tier" inManagedObjectContext:moc_];
}

- (TierID*)objectID {
	return (TierID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"limitValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"limit"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sizeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"size"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"tierIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"tierID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic commission;






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





@dynamic name;






@dynamic price;






@dynamic size;



- (int16_t)sizeValue {
	NSNumber *result = [self size];
	return [result shortValue];
}

- (void)setSizeValue:(int16_t)value_ {
	[self setSize:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSizeValue {
	NSNumber *result = [self primitiveSize];
	return [result shortValue];
}

- (void)setPrimitiveSizeValue:(int16_t)value_ {
	[self setPrimitiveSize:[NSNumber numberWithShort:value_]];
}





@dynamic tierDescription;






@dynamic tierID;



- (int32_t)tierIDValue {
	NSNumber *result = [self tierID];
	return [result intValue];
}

- (void)setTierIDValue:(int32_t)value_ {
	[self setTierID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTierIDValue {
	NSNumber *result = [self primitiveTierID];
	return [result intValue];
}

- (void)setPrimitiveTierIDValue:(int32_t)value_ {
	[self setPrimitiveTierID:[NSNumber numberWithInt:value_]];
}





@dynamic ticketType;

	

@dynamic tickets;

	
- (NSMutableSet*)ticketsSet {
	[self willAccessValueForKey:@"tickets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tickets"];
  
	[self didAccessValueForKey:@"tickets"];
	return result;
}
	






#if TARGET_OS_IPHONE




- (NSFetchedResultsController*)newTicketsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"Ticket" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"tier == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}


#endif

@end
