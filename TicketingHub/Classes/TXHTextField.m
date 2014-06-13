//
//  TXHTextField.m
//  TicketingHub
//
//  Created by Leszek Kaczor on 13/06/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTextField.h"

@implementation TXHTextField

- (void) drawPlaceholderInRect:(CGRect)rect {
    NSDictionary * attributes = @{NSForegroundColorAttributeName : self.customPlaceholderColor, NSFontAttributeName : self.font};
    
    CGSize textSize = [self.placeholder sizeWithAttributes:attributes];
    rect.origin.y = (rect.size.height - textSize.height)/2;
    [self.placeholder drawInRect:rect withAttributes:attributes];
}

@end
