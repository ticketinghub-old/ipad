// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Venue.m instead.

#import "_Venue.h"

const struct VenueAttributes VenueAttributes = {
	.businessName = @"businessName",
	.city = @"city",
	.country = @"country",
	.currencyCode = @"currencyCode",
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
	.venueID = @"venueID",
	.websiteURL = @"websiteURL",
};

const struct VenueRelationships VenueRelationships = {
	.permissions = @"permissions",
	.seasons = @"seasons",
	.ticketTypes = @"ticketTypes",
	.variations = @"variations",
};

const struct VenueFetchedProperties VenueFetchedProperties = {
};

@implementation VenueID
@end

@implementation _Venue

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Venue" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Venue";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:moc_];
}

- (VenueID*)objectID {
	return (VenueID*)[super objectID];
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
	if ([key isEqualToString:@"venueIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"venueID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic businessName;






@dynamic city;






@dynamic country;






@dynamic currencyCode;






@dynamic email;






@dynamic establishmentType;






@dynamic latitude;



- (float)latitudeValue {
	NSNumber *result = [self latitude];
	return [result floatValue];
}

- (void)setLatitudeValue:(float)value_ {
	[self setLatitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result floatValue];
}

- (void)setPrimitiveLatitudeValue:(float)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithFloat:value_]];
}





@dynamic longitude;



- (float)longitudeValue {
	NSNumber *result = [self longitude];
	return [result floatValue];
}

- (void)setLongitudeValue:(float)value_ {
	[self setLongitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result floatValue];
}

- (void)setPrimitiveLongitudeValue:(float)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithFloat:value_]];
}





@dynamic postcode;






@dynamic region;






@dynamic street1;






@dynamic street2;






@dynamic stripePublishableKey;






@dynamic telephone;






@dynamic timeZoneName;






@dynamic venueID;



- (int32_t)venueIDValue {
	NSNumber *result = [self venueID];
	return [result intValue];
}

- (void)setVenueIDValue:(int32_t)value_ {
	[self setVenueID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveVenueIDValue {
	NSNumber *result = [self primitiveVenueID];
	return [result intValue];
}

- (void)setPrimitiveVenueIDValue:(int32_t)value_ {
	[self setPrimitiveVenueID:[NSNumber numberWithInt:value_]];
}





@dynamic websiteURL;






@dynamic permissions;

	
- (NSMutableSet*)permissionsSet {
	[self willAccessValueForKey:@"permissions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"permissions"];
  
	[self didAccessValueForKey:@"permissions"];
	return result;
}
	

@dynamic seasons;

	
- (NSMutableSet*)seasonsSet {
	[self willAccessValueForKey:@"seasons"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"seasons"];
  
	[self didAccessValueForKey:@"seasons"];
	return result;
}
	

@dynamic ticketTypes;

	
- (NSMutableSet*)ticketTypesSet {
	[self willAccessValueForKey:@"ticketTypes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"ticketTypes"];
  
	[self didAccessValueForKey:@"ticketTypes"];
	return result;
}
	

@dynamic variations;

	
- (NSMutableSet*)variationsSet {
	[self willAccessValueForKey:@"variations"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"variations"];
  
	[self didAccessValueForKey:@"variations"];
	return result;
}
	






#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newPermissionsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"Permission" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"venue == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}



- (NSFetchedResultsController*)newSeasonsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"Season" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"venue == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}



- (NSFetchedResultsController*)newTicketTypesFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"TicketType" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"venue == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}



- (NSFetchedResultsController*)newVariationsFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"Variation" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"venue == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}


#endif

@end
