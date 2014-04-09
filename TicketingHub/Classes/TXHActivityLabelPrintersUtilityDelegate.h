//
//  TXHActivityLabelPrintersUtilityDelegate.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXHPrintersUtility.h"

@class TXHActivityLabelView;

@interface TXHActivityLabelPrintersUtilityDelegate : NSObject <TXHPrintersUtilityDelegate>

@property (nonatomic, weak) TXHActivityLabelView *activityView;

@end
