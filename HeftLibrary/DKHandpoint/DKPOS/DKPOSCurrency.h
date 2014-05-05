//
//  DKPosCurrency.h
//  POSTest
//
//  Created by Hjalti Jakobsson on 3.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKPOSCurrency : NSObject

+ (instancetype)instance;
- (NSString*)currencyNumberForCode:(NSString*)code;
- (NSString*)currentCurrencyNumber;

@end
