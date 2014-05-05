//
//  DKPOSClientFactory.m
//  POSTest
//
//  Created by Hjalti Jakobsson on 3.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

#import "DKPOSClientFactory.h"
#import "DKPOSHandpointClient.h"

@implementation DKPOSClientFactory

+ (NSObject<DKPOSClient>*)currentClient
{
    
#if !(TARGET_IPHONE_SIMULATOR)
    
    //At the moment we only support Handpoint so there's nothing to do here
    //but it makes it easy in the future to return different types of clients
    //based on settings
    
    DKPOSHandpointClient *client = [[DKPOSHandpointClient alloc] init];
    [client initialize];
    
    return client;
#endif
    
    return nil;
}

+ (Class)currentClientClass;
{
#if !(TARGET_IPHONE_SIMULATOR)
    return [DKPOSHandpointClient class];
#endif
    
    return nil;
}

@end
