//
//  DKPOSClientFactory.h
//  POSTest
//
//  Created by Hjalti Jakobsson on 3.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKPOSClient.h"

@interface DKPOSClientFactory : NSObject

+ (NSObject<DKPOSClient>*)currentClient;
+ (Class)currentClientClass;

@end
