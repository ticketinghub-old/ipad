//
//  TXHPayment+PKCard.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 19/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPayment.h"

@class PKCard;

@interface TXHPayment (PKCard)

+ (instancetype)createWithCard:(PKCard *)card cardTrackData:(NSString *)cardTrackData inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
