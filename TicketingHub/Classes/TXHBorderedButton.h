//
//  TXHBorderedButton.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

// Bordered button which fill color is specify by property and text/border color is based on tint color

@interface TXHBorderedButton : UIButton

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) UIColor *highlightedBorderColor;

@property (nonatomic, copy) UIColor *normalFillColor;
@property (nonatomic, copy) UIColor *highlightedFillColor;

@property (nonatomic, copy) UIColor *normalTextColor;
@property (nonatomic, copy) UIColor *highlightedTextColor;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

@end
