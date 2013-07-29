// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Customer.m instead.

#import "_Customer.h"

const struct CustomerAttributes CustomerAttributes = {
	.customerID = @"customerID",
	.email = @"email",
};

const struct CustomerRelationships CustomerRelationships = {
	.tickets = @"tickets",
};

const struct CustomerFetchedProperties CustomerFetchedProperties = {
};

@implementation CustomerID
@end

@implementation _Customer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Customer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Customer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:moc_];
}

- (CustomerID*)objectID {
	return (CustomerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"customerIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"customerID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic customerID;



- (int32_t)customerIDValue {
	NSNumber *result = [self customerID];
	return [result intValue];
}

- (void)setCustomerIDValue:(int32_t)value_ {
	[self setCustomerID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCustomerIDValue {
	NSNumber *result = [self primitiveCustomerID];
	return [result intValue];
}

- (void)setPrimitiveCustomerIDValue:(int32_t)value_ {
	[self setPrimitiveCustomerID:[NSNumber numberWithInt:value_]];
}





@dynamic email;






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
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"customer == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}


#endif

@end
