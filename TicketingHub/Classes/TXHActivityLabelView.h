//
//  TXHActivityLabelView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHActivityLabelView : UIView

+ (instancetype)getInstanceInView:(UIView *)targetView;

- (void)showWithMessage:(NSString *)text indicatorHidden:(BOOL)hidden;

- (void)hide;


@end
