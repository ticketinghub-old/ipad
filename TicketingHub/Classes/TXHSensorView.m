//
//  TXHSensorView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 03/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSensorView.h"

@implementation TXHSensorView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    BOOL pointInside = CGRectContainsPoint(self.bounds, point);
    if (pointInside)
    {
        [self.delegate sensorViewDidRecognizeTap:self];
    }
    
    return NO;
}

@end
