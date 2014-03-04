//
//  TXHSelectionEntryTableViewCell.m
//  TicketingHub
//
//  Created by Mark on 20/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSelectionEntryTableViewCell.h"

#import "TXHDataEntryFieldErrorView.h"
#import "TXHDataSelectionViewController.h"
#import "UIColor+TicketingHub.h"
#import <QuartzCore/QuartzCore.h>

@interface TXHSelectionEntryTableViewCell () <TXHDataSelectionDelegate>

@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *errorMessageView;
@property (weak, nonatomic) IBOutlet UIButton *selectionField;

@property (strong, nonatomic) UIPopoverController *selectionPopover;

@end

@implementation TXHSelectionEntryTableViewCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupSeletionField];
    [self.selectionField addTarget:self action:@selector(chooseItem:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)chooseItem:(id)sender {
    if (self.selectionPopover.isPopoverVisible) {
        [self.selectionPopover dismissPopoverAnimated:YES];
    }
    TXHDataSelectionViewController *dataSelector = [[TXHDataSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
    dataSelector.items = self.options;
    dataSelector.delegate = self;
    
    self.selectionPopover = [[UIPopoverController alloc] initWithContentViewController:dataSelector];
    self.selectionPopover.popoverContentSize = CGSizeMake(210.0f, (MIN(4,[self.options count]) * 44.0f));
    [self.selectionPopover presentPopoverFromRect:self.selectionField.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)setupSeletionField
{
    self.selectionField.layer.borderColor  = self.selectionField.tintColor.CGColor;
    self.selectionField.layer.cornerRadius = 5.0;
    self.selectionField.layer.borderWidth  = 1.0;
}

- (BOOL)hasErrors
{
    return (self.errorMessageView.message.length > 0);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setValue:(NSString *)value
{
    _value = value;
    [self updateTitle];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self updateTitle];
}

- (void)setErrorMessage:(NSString *)errorMessage
{
    self.errorMessageView.message = errorMessage;
    [self updateColors];
}

- (void)updateTitle
{
    if ([self.value length])
    {
        [self.selectionField setTitle:self.value forState:UIControlStateNormal];
    }
    else
    {
        [self.selectionField setTitle:self.placeholder forState:UIControlStateNormal];
    }
    [self updateColors];
}

- (void)updateColors
{
    UIColor *textColor;
    UIColor *backgroundColor;
    
    if ([self hasErrors])
    {
        textColor       = [[self class] txhFieldErrorTextColor];
        backgroundColor = [[self class] txhFieldErrorBackgroundColor];
    }
    else
    {
        backgroundColor = [[self class] txhFieldNormalBackgroundColor];
        
        if ([self.value length])
            textColor = [[self class] txhFieldNormalTextColor];
        else
            textColor = [[self class] txhFieldPlaceholderTextColor];
    }

    [self.selectionField setTitleColor:textColor forState:UIControlStateNormal];
    [self.selectionField setBackgroundColor:backgroundColor];
}

#pragma mark - TXHDataSelectionDelegate

- (void)dataSelectionViewController:(TXHDataSelectionViewController *)controller didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedValue = [self.options objectAtIndex:indexPath.row];
    self.value = selectedValue;
    
    [self.selectionPopover dismissPopoverAnimated:YES];
    
}

@end

