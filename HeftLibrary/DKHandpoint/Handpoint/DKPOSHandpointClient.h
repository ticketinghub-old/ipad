//
//  DKPOSHandpointClient.h
//  POSTest
//
//  Created by Hjalti Jakobsson on 3.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DKPOSClient.h"
#import "HeftManager.h"
#import "HeftStatusReportPublic.h"

@interface DKPOSHandpointClient : NSObject <DKPOSClient, HeftStatusReportDelegate, HeftDiscoveryDelegate>

@property (nonatomic, weak) NSObject<DKPOSClientDelegate>* delegate;

@end

