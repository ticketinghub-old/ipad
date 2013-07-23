//
//  TXHDateSelectorViewController.h
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHDateSelectorViewController : UIViewController

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view;

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item;

@end
