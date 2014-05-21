//
//  TXHRMPickerViewControllerDelegate.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 24/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RMPickerViewController/RMPickerViewController.h>

@interface TXHRMPickerViewControllerDelegate : NSObject

- (void)showWithItems:(NSArray *)items selectionHandler:(RMSelectionBlock)handler;

@end
