//
//  NSString+Hex.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 30/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "NSString+Hex.h"

@implementation NSString (Hex)


/*
    method from handpoint example project for onvering nassting into hexData
 */
- (NSData *)hexData
{
    NSMutableData* data = [NSMutableData data];
    NSString *sharedSecretFromFile = self;
    for (int i = 0 ; i < 32; i++)
    {
        NSRange range = NSMakeRange (i*2, 2);
        NSString *bytes = [sharedSecretFromFile substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:bytes];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }

    return data;
}

@end
