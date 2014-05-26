//
//  TXHSalesWizardViewController.m
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesWizardViewController.h"

#import "TXHSalesStep.h"

#import "UIColor+TicketingHub.h"
#import "UIFont+TicketingHub.h"

#import <AKPickerView/AKPickerView.h>

@interface TXHSalesWizardViewController () <AKPickerViewDelegate>

@property (weak, nonatomic) IBOutlet AKPickerView *pickerView;

@end

@implementation TXHSalesWizardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureMenu];
    [self reloadWizard];
}

- (void)configureMenu
{
    self.pickerView.delegate             = self;
    self.pickerView.font                 = [UIFont txhThinFontWithSize:26.0f];
    self.pickerView.textColor            = [UIColor lightGrayColor];
    self.pickerView.highlightedTextColor = [UIColor txhDarkBlueColor];
}

#pragma mark - Public methods

- (void)reloadWizard
{
    NSUInteger currentIndex = [self.dataSource currentStepIndex];
    
    [self.pickerView reloadData];
    [self.pickerView selectItem:currentIndex animated:YES];
}

#pragma mark - AKPickerViewDelegate

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [self.dataSource numberOfsteps];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    TXHSalesStep *step = [self.dataSource stepAtIndex:item];

    return step.title;
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{

}

@end
