// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Ticket.m instead.

#import "_Ticket.h"

const struct TicketAttributes TicketAttributes = {
	.barcode = @"barcode",
	.commission = @"commission",
	.price = @"price",
	.ticketID = @"ticketID",
	.validFrom = @"validFrom",
	.validTo = @"validTo",
};

const struct TicketRelationships TicketRelationships = {
	.customer = @"customer",
	.tier = @"tier",
};

const struct TicketFetchedProperties TicketFetchedProperties = {
};

@implementation TicketID
@end

@implementation _Ticket

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Ticket" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Ticket";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Ticket" inManagedObjectContext:moc_];
}

- (TicketID*)objectID {
	return (TicketID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"ticketIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ticketID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic barcode;






@dynamic commission;






@dynamic price;






@dynamic ticketID;



- (int32_t)ticketIDValue {
	NSNumber *result = [self ticketID];
	return [result intValue];
}

- (void)setTicketIDValue:(int32_t)value_ {
	[self setTicketID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTicketIDValue {
	NSNumber *result = [self primitiveTicketID];
	return [result intValue];
}

- (void)setPrimitiveTicketIDValue:(int32_t)value_ {
	[self setPrimitiveTicketID:[NSNumber numberWithInt:value_]];
}





@dynamic validFrom;






@dynamic validTo;






@dynamic customer;

	

@dynamic tier;

	






#if TARGET_OS_IPHONE





#endif

@end
