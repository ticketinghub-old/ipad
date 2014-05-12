//
//  TXHGateway+CNPHelper.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 12/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHGateway+CNPHelper.h"

@implementation TXHGateway (CNPHelper)

- (BOOL)isCNPGateway
{
    for (NSString *inputType in self.inputTypes)
    {
        if ([[inputType lowercaseString] isEqualToString:@"cnp"])
        {
            return YES;
        }
    }
    
    return NO;
}

@end
