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
@property (weak, nonatomic) IBOutlet UIButton *couponsButton;

@property (copy, nonatomic) void (^leftButtonAction) (UIButton *);

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
    self.pickerView.delegate               = self;
    self.pickerView.font                   = [UIFont txhThinFontWithSize:25.0f];
    self.pickerView.textColor              = [[UIColor txhDarkBlueColor] colorWithAlphaComponent:0.25];
    self.pickerView.highlightedTextColor   = [UIColor txhDarkBlueColor];
    self.pickerView.interitemSpacing       = 50.0;
    self.pickerView.userInteractionEnabled = NO;
}

- (IBAction)leftButtonAction:(id)sender
{
    if (self.leftButtonAction)
        self.leftButtonAction(self.couponsButton);
}

- (void)setLeftButtonTitle:(NSString *)title
{
    [self.couponsButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Public methods

- (void)reloadWizard
{
    NSUInteger currentIndex = [self.dataSource currentStepIndex];
    
    [self.pickerView reloadData];
    [self.pickerView selectItem:currentIndex animated:YES];
}

- (void)setLeftButtonHidden:(BOOL)hidden
{
    self.couponsButton.hidden = hidden;
    [self setLeftButtonTitle:NSLocalizedString(@"SALESMAN_COUPON_CODE_BUTTON_TITLE", nil)];
}

- (void)setLeftButtonAction:(void(^)(UIButton *button))action
{
    _leftButtonAction = action;
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
