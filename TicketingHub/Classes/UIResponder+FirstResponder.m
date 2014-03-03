//
//  UIResponder+FirstResponder.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 03/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)

+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}
-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
