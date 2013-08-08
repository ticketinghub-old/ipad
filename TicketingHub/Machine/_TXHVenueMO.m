// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHVenueMO.m instead.

#import "_TXHVenueMO.h"

const struct TXHVenueMOAttributes TXHVenueMOAttributes = {
	.city = @"city",
	.country = @"country",
	.currency = @"currency",
	.email = @"email",
	.establishmentType = @"establishmentType",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.postcode = @"postcode",
	.region = @"region",
	.street1 = @"street1",
	.street2 = @"street2",
	.stripePublishableKey = @"stripePublishableKey",
	.telephone = @"telephone",
	.timeZoneName = @"timeZoneName",
	.venueId = @"venueId",
	.venueName = @"venueName",
	.website = @"website",
};

const struct TXHVenueMORelationships TXHVenueMORelationships = {
	.permissions = @"permissions",
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
	
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"venueIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"venueId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic city;






@dynamic country;






@dynamic currency;






@dynamic email;






@dynamic establishmentType;






@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic postcode;






@dynamic region;






@dynamic street1;






@dynamic street2;






@dynamic stripePublishableKey;






@dynamic telephone;






@dynamic timeZoneName;






@dynamic venueId;



- (int32_t)venueIdValue {
	NSNumber *result = [self venueId];
	return [result intValue];
}

- (void)setVenueIdValue:(int32_t)value_ {
	[self setVenueId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveVenueIdValue {
	NSNumber *result = [self primitiveVenueId];
	return [result intValue];
}

- (void)setPrimitiveVenueIdValue:(int32_t)value_ {
	[self setPrimitiveVenueId:[NSNumber numberWithInt:value_]];
}





@dynamic venueName;






@dynamic website;






@dynamic permissions;

	
- (NSMutableSet*)permissionsSet {
	[self willAccessValueForKey:@"permissions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"permissions"];
  
	[self didAccessValueForKey:@"permissions"];
	return result;
}
	

@dynamic user;

	






#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newPermissionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"TXHPermissionMO" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"venues CONTAINS %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}




#endif

@end
