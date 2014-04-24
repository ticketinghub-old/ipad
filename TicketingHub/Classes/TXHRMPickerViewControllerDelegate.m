//
//  TXHRMPickerViewControllerDelegate.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 24/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHRMPickerViewControllerDelegate.h"

@interface TXHRMPickerViewControllerDelegate ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation TXHRMPickerViewControllerDelegate


- (void)showWithItems:(NSArray *)items selectionHandler:(RMSelectionBlock)handler
{
    self.items = items;
    
    RMPickerViewController *picker = [[RMPickerViewController alloc] init];
    [picker showWithSelectionHandler:handler];
}


#pragma mark - RMPickerViewControllerDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.items count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.items[row];
}

@end
