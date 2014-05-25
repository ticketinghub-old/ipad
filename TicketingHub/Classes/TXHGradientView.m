//
//  TXHGradientView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 25/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHGradientView.h"

@implementation TXHGradientView

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void)setColors:(NSArray *)colors
{
    [(CAGradientLayer *)self.layer setColors:colors];
}

- (void)setLocations:(NSArray *)locations
{
    [(CAGradientLayer *)self.layer setLocations:locations];
}

@end
